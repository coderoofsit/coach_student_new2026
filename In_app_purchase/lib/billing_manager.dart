import 'dart:io';
import 'billing_service.dart';
import 'google/google_billing_service.dart';
import 'apple/apple_billing_service.dart';
import 'models/product_model.dart';
import 'models/purchase_state.dart';

class BillingManager {
  static final BillingManager _instance = BillingManager._internal();
  factory BillingManager() => _instance;
  BillingManager._internal();

  late final BillingService _service;
  bool _initialized = false;

  /// Initialize the billing manager with product IDs
  Future<void> init(Set<String> productIds) async {
    if (_initialized) return;

    if (Platform.isAndroid) {
      _service = GoogleBillingService();
    } else if (Platform.isIOS) {
      _service = AppleBillingService();
    } else {
      throw UnsupportedError('Platform not supported for billing');
    }

    await _service.init(productIds);
    _initialized = true;
  }

  /// Get available products
  Future<List<ProductModel>> getProducts() async {
    _checkInitialized();
    return await _service.getProducts();
  }

  /// Start purchase flow
  Future<void> purchase(String productId, {bool isConsumable = true}) async {
    _checkInitialized();
    await _service.purchase(productId, isConsumable: isConsumable);
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    _checkInitialized();
    await _service.restorePurchases();
  }

  /// Complete a purchase
  Future<void> completePurchase(dynamic purchaseDetails) async {
    _checkInitialized();
    await _service.completePurchase(purchaseDetails);
  }

  /// Stream of purchase updates
  Stream<PurchaseState> get purchaseStream {
    _checkInitialized();
    return _service.purchaseStream;
  }

  void _checkInitialized() {
    if (!_initialized) {
      throw StateError('BillingManager not initialized. Call init() first.');
    }
  }

  /// Dispose the manager
  void dispose() {
    if (_initialized) {
      _service.dispose();
      _initialized = false;
    }
  }
}
