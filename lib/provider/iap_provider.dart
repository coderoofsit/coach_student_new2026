import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iap_package/iap_package.dart';
import 'dart:developer' as dev;

// --- Constants ---
const Set<String> _kProductIds = {
  'test_product_id',
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
  return IAPNotifier();
});

class IAPNotifier extends StateNotifier<IAPState> {
  final BillingManager _billingManager = BillingManager();
  StreamSubscription<PurchaseState>? _subscription;

  IAPNotifier() : super(IAPState()) {
    _init();
  }

  Future<void> _init() async {
    state = state.copyWith(isLoading: true);
    try {
      // 1. Initialize the BillingManager
      await _billingManager.init(_kProductIds);

      // 2. Load available products
      final products = await _billingManager.getProducts();

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
        errorMessage: 'Failed to initialize store: $e',
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
        break;
      case PurchaseStatus.error:
        dev.log("Purchase Error: ${purchaseState.productId} - ${purchaseState.error}");
        state = state.copyWith(errorMessage: purchaseState.error);
        break;
      case PurchaseStatus.cancelled:
        dev.log("Purchase Cancelled: ${purchaseState.productId}");
        break;
    }
  }

  /// Start a purchase flow
  Future<void> buyProduct(String productId, {bool isConsumable = true}) async {
    if (!state.isInitialized) {
      state = state.copyWith(errorMessage: "Store not initialized");
      return;
    }
    
    try {
      await _billingManager.purchase(productId, isConsumable: isConsumable);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Purchase request failed: $e');
    }
  }

  /// Restore past purchases (especially for non-consumables/subscriptions)
  Future<void> restore() async {
    if (!state.isInitialized) return;
    try {
      await _billingManager.restorePurchases();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Restore failed: $e');
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _billingManager.dispose();
    super.dispose();
  }
}
