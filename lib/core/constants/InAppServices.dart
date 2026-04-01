import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = true;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;

  Future<void> initialize() async {
    final bool available = await _iap.isAvailable();
    if (!available) {
      _available = false;
      return;
    }

    const Set<String> _kIds = {"test_product_id", "year_plan_test"};
    final ProductDetailsResponse response = await _iap.queryProductDetails(_kIds);
    if (response.error != null) {
      // Handle error here
    }
    _products = response.productDetails;
  }

  Future<void> buySubscription(ProductDetails productDetails) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void verifyPurchase(PurchaseDetails purchase) {
    // Here you should verify the purchase with your server
  }

  void handlePurchaseUpdates() {
    purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
      for (var purchaseDetails in purchaseDetailsList) {
        if (purchaseDetails.status == PurchaseStatus.pending) {
          // Handle pending purchase here
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          // Handle successful purchase here
          verifyPurchase(purchaseDetails);
          // Deliver the content, then confirm the purchase
          _iap.completePurchase(purchaseDetails);
        } else if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle error here
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          // Handle restored purchases here
          verifyPurchase(purchaseDetails);
          _iap.completePurchase(purchaseDetails);
        }
      }
      _purchases.addAll(purchaseDetailsList);
    });
  }
}
