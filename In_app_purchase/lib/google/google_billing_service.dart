import 'dart:async';
import '../billing_service.dart';
import '../models/product_model.dart';
import '../models/purchase_state.dart';

class GoogleBillingService implements BillingService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final StreamController<PurchaseState> _purchaseStateController = StreamController<PurchaseState>.broadcast();
  Set<String> _productIds = {};

  @override
  Stream<PurchaseState> get purchaseStream => _purchaseStateController.stream;

  @override
  Future<void> init(Set<String> productIds) async {
    _productIds = productIds;
    final bool available = await _iap.isAvailable();
    if (!available) {
      _purchaseStateController.add(PurchaseState.error(error: 'Store not available'));
      return;
    }

    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription.cancel(),
      onError: (error) => _purchaseStateController.add(PurchaseState.error(error: error.toString())),
    );
  }

  @override
  Future<List<ProductModel>> getProducts() async {
    final ProductDetailsResponse response = await _iap.queryProductDetails(_productIds);
    if (response.error != null) {
      throw Exception(response.error!.message);
    }

    return response.productDetails.map((pd) => ProductModel(
      id: pd.id,
      title: pd.title,
      description: pd.description,
      price: pd.price,
      currencyCode: pd.currencyCode,
      rawPrice: pd.rawPrice,
    )).toList();
  }

  @override
  Future<void> purchase(String productId, {bool isConsumable = true}) async {
    final ProductDetailsResponse response = await _iap.queryProductDetails({productId});
    if (response.productDetails.isEmpty) {
      _purchaseStateController.add(PurchaseState.error(productId: productId, error: 'Product not found'));
      return;
    }

    final productDetails = response.productDetails.first;
    late PurchaseParam purchaseParam;

    if (isConsumable) {
      purchaseParam = PurchaseParam(productDetails: productDetails);
      await _iap.buyConsumable(purchaseParam: purchaseParam);
    } else {
      // For non-consumables/subscriptions on Android, we might need to handle changes
      purchaseParam = GooglePlayPurchaseParam(productDetails: productDetails);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  @override
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  @override
  Future<void> completePurchase(dynamic purchaseDetails) async {
    if (purchaseDetails is PurchaseDetails) {
      await _iap.completePurchase(purchaseDetails);
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    for (var purchase in purchaseDetailsList) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          _purchaseStateController.add(PurchaseState.pending(productId: purchase.productID));
          break;
        case PurchaseStatus.error:
          _purchaseStateController.add(PurchaseState.error(productId: purchase.productID, error: purchase.error?.message ?? 'Unknown error'));
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _purchaseStateController.add(PurchaseState.success(
            productId: purchase.productID,
            originalPurchaseDetails: purchase,
          ));
          break;
        case PurchaseStatus.canceled:
          _purchaseStateController.add(PurchaseState.cancelled(productId: purchase.productID));
          break;
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    _purchaseStateController.close();
  }
}
