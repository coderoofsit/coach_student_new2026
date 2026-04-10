import 'models/product_model.dart';
import 'models/purchase_state.dart';

abstract class BillingService {
  /// Initialize the billing service with a set of product IDs
  Future<void> init(Set<String> productIds);

  /// Fetch products from the store
  Future<List<ProductModel>> getProducts();

  /// Start the purchase flow for a product
  Future<void> purchase(String productId, {bool isConsumable = true});

  /// Restore previous purchases
  Future<void> restorePurchases();

  /// Stream of purchase updates
  Stream<PurchaseState> get purchaseStream;

  /// Complete a purchase (acknowledge/consume)
  Future<void> completePurchase(dynamic purchaseDetails);
  
  /// Dispose the service
  void dispose();
}
