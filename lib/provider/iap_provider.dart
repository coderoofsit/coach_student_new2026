import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iap_package/iap_package.dart';
import 'dart:developer' as dev;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../services/api/api_serivce_export.dart';
import 'coach/coach_profile_provider.dart';

// --- Constants ---
const Set<String> _kProductIds = {
  'Monthly_Sub',
  'yearly_sub',
};

// --- Models ---
class IAPState {
  final List<ProductModel> products;
  final bool isLoading;
  final bool isInitialized;
  final String? errorMessage;
  final PurchaseState? latestPurchase;

  IAPState({
    this.products = const [],
    this.isLoading = false,
    this.isInitialized = false,
    this.errorMessage,
    this.latestPurchase,
  });

  IAPState copyWith({
    List<ProductModel>? products,
    bool? isLoading,
    bool? isInitialized,
    String? errorMessage,
    PurchaseState? latestPurchase,
  }) {
    return IAPState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      errorMessage: errorMessage,
      latestPurchase: latestPurchase ?? this.latestPurchase,
    );
  }
}

// --- Provider ---
final iapProvider = StateNotifierProvider<IAPNotifier, IAPState>((ref) {
  return IAPNotifier(ref);
});

class IAPNotifier extends StateNotifier<IAPState> {
  final Ref _ref;
  final BillingManager _billingManager = BillingManager();
  StreamSubscription<PurchaseState>? _subscription;

  IAPNotifier(this._ref) : super(IAPState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      dev.log('IAP: Initializing with IDs: $_kProductIds');
      // 1. Initialize the BillingManager
      await _billingManager.init(_kProductIds);

      // 2. Load available products
      final products = await _billingManager.getProducts();
      dev.log('IAP: Found ${products.length} products');
      for (var p in products) {
        dev.log('IAP: Product loaded - ${p.id}: ${p.title} (${p.price})');
      }

      // 3. Keep state updated
      state = state.copyWith(
        products: products,
        isLoading: false,
        isInitialized: true,
      );

      // 4. Listen for purchase updates
      _subscription = _billingManager.purchaseStream.listen(_handlePurchaseUpdates);
    } catch (e) {
      dev.log('IAP Initialization Error: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to initialize store. Please check your internet connection and store configuration.',
      );
    }
  }

  void _handlePurchaseUpdates(PurchaseState purchaseState) async {
    state = state.copyWith(latestPurchase: purchaseState);

    switch (purchaseState.status) {
      case PurchaseStatus.loading:
        dev.log("Purchase Processing: ${purchaseState.productId}");
        break;
      case PurchaseStatus.pending:
        dev.log("Purchase Pending: ${purchaseState.productId}");
        break;
      case PurchaseStatus.success:
        dev.log("Purchase Success: ${purchaseState.productId}");
        // IMPORTANT: Complete the purchase after delivering the content
        if (purchaseState.originalPurchaseDetails != null) {
          await _billingManager.completePurchase(purchaseState.originalPurchaseDetails);
        }
        // Sync with backend
        _verifyWithBackend(purchaseState);
        break;
      case PurchaseStatus.error:
        dev.log("Purchase Error: ${purchaseState.productId} - ${purchaseState.error}");
        state = state.copyWith(
          errorMessage: _getFriendlyErrorMessage(purchaseState.error ?? "Purchase failed"),
          isLoading: false,
        );
        break;
      case PurchaseStatus.cancelled:
        dev.log("Purchase Cancelled: ${purchaseState.productId}");
        state = state.copyWith(isLoading: false);
        break;
    }
  }

  /// Start a purchase flow
  Future<void> buyProduct(String productId, {bool isConsumable = false}) async {
    if (!state.isInitialized) {
      state = state.copyWith(errorMessage: "Store not initialized");
      return;
    }
    
    if (state.isLoading) return; // Prevent concurrent actions
    
    try {
      dev.log("IAP: Starting purchase for $productId (consumable: $isConsumable)");
      state = state.copyWith(isLoading: true, errorMessage: null);
      await _billingManager.purchase(productId, isConsumable: isConsumable);
    } catch (e) {
      dev.log("IAP: Purchase request failed: $e");
      final String errorMsg = _getFriendlyErrorMessage(e);
      state = state.copyWith(errorMessage: errorMsg, isLoading: false);
      
      // If we hit a duplicate transaction error, attempt to clear the queue by restoring
      if (e.toString().contains('storekit_duplicate_product_object')) {
        dev.log("IAP: Duplicate transaction detected. Attempting to clear queue via restore...");
        state = state.copyWith(errorMessage: "Synchronizing store transactions. Please try again in a moment.", isLoading: true);
        await restore(); 
      }
    }
  }

  /// Restore past purchases (especially for non-consumables/subscriptions)
  Future<void> restore() async {
    if (!state.isInitialized || state.isLoading) return;
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      await _billingManager.restorePurchases();
      // Restore typically doesn't trigger the purchase stream if nothing is found, 
      // so we set loading to false after a short delay or after the call completes
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Restore failed: $e', isLoading: false);
    }
  }

  /// Verification with backend
  Future<void> _verifyWithBackend(PurchaseState purchase) async {
    try {
      final String? serverData = purchase.originalPurchaseDetails?.verificationData.serverVerificationData;
      
      final data = {
        'productId': purchase.productId,
        'purchaseToken': serverData, // Backend expects purchaseToken for Android and receiptData for iOS
        'receiptData': Platform.isIOS ? serverData : null,
        'packageName': "com.credit.creditvault", // Target package name
        'platform': Platform.isAndroid ? 'android' : 'ios',
      };

      dev.log("IAP: Verifying with backend: ${purchase.productId} on ${data['platform']}");

      // Call the sync endpoint
      final result = await DioApi.post(
        path: ConfigUrl.verifySubscription,
        data: data,
      );

      if (result.dioError?.response?.statusCode == 404) {
        dev.log("Backend Sync: Subscription verification endpoint not yet implemented (404). Ready for backend update.");
      } else if (result.dioError != null) {
        dev.log("Backend Sync Error: ${result.dioError?.message}");
      }
      
      // Always refresh the user profile to catch any updates that DO exist
      await _ref.read(coachProfileProvider.notifier).getCoachProfile();
      
      // Sync with backend Done, safe to clear local temporary state
      state = state.copyWith(isLoading: false, latestPurchase: null);
      
    } catch (e) {
      dev.log("Sync Exception: $e");
      state = state.copyWith(isLoading: false);
    }
  }

  /// Open OS-specific subscription management page
  Future<void> openSubscriptionManagement() async {
    final url = Platform.isAndroid
        ? "https://play.google.com/store/account/subscriptions?package=com.credit.creditvault"
        : "https://apps.apple.com/account/subscriptions";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      state = state.copyWith(errorMessage: "Could not open store subscriptions page.");
    }
  }

  /// Map technical errors to user-friendly messages
  String _getFriendlyErrorMessage(Object error) {
    final errorStr = error.toString();
    
    // Check for StoreKit duplicate transaction error
    if (errorStr.contains('storekit_duplicate_product_object')) {
      return "Please wait, restoring previous plans or checking plans...";
    }
    
    // Clean up other PlatformException technical strings
    if (errorStr.startsWith('PlatformException(')) {
      // Extract only the message part if possible
      final parts = errorStr.split(',');
      if (parts.length > 1) {
        return parts[1].trim();
      }
    }
    
    return errorStr.replaceFirst('Exception: ', '').replaceFirst('Purchase request failed: ', '');
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _billingManager.dispose();
    super.dispose();
  }
}
