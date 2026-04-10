# Integration Guide: iap_package

This guide explains how to integrate the `iap_package` into a real-world Flutter application using a `ChangeNotifier` (or any other state management). This approach is used in the **TimeSavor** project.

## 1. Create an In-App Purchase Service

Create a service class that wraps the `BillingManager` and handles app-specific logic like backend verification and UI state.

```dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:iap_package/iap_package.dart';

class InAppPurchaseService extends ChangeNotifier {
  final BillingManager _billingManager = BillingManager();
  
  List<ProductModel> _products = [];
  bool isLoading = false;
  late StreamSubscription<PurchaseState> _subscription;

  List<ProductModel> get products => _products;

  // Define your product IDs
  final Set<String> _productIds = {
    'com.yourapp.monthly',
    'com.yourapp.yearly',
  };

  /// Initialize the service
  Future<void> initialize() async {
    try {
      // 1. Initialize BillingManager
      await _billingManager.init(_productIds);
      
      // 2. Listen to purchase updates
      _subscription = _billingManager.purchaseStream.listen((state) {
        _handlePurchaseState(state);
      });

      // 3. Fetch products to show in UI
      _products = await _billingManager.getProducts();
      notifyListeners();
      
    } catch (e) {
      debugPrint("Error initializing IAP: $e");
    }
  }

  /// Handle stream updates
  void _handlePurchaseState(PurchaseState state) async {
    switch (state.status) {
      case PurchaseStatus.loading:
        isLoading = true;
        break;
      case PurchaseStatus.success:
        isLoading = false;
        await _verifyAndComplete(state);
        break;
      case PurchaseStatus.error:
        isLoading = false;
        debugPrint("Purchase Error: ${state.error}");
        // Important: Still complete the purchase to dismiss the store UI
        await _billingManager.completePurchase(state.originalPurchaseDetails);
        break;
      case PurchaseStatus.cancelled:
        isLoading = false;
        break;
      case PurchaseStatus.pending:
        isLoading = false;
        break;
    }
    notifyListeners();
  }

  /// Verification with Backend
  Future<void> _verifyAndComplete(PurchaseState state) async {
    try {
      // Step 1: Send state.originalPurchaseDetails to your server
      // Step 2: Server verifies with Google/Apple
      // Step 3: If server returns success:
      
      await _billingManager.completePurchase(state.originalPurchaseDetails);
      debugPrint("Purchase finalized for ${state.productId}");
      
    } catch (e) {
      debugPrint("Verification failed: $e");
    }
  }

  /// Trigger a purchase
  Future<void> buyProduct(String productId) async {
    await _billingManager.purchase(productId, isConsumable: false);
  }

  @override
  void dispose() {
    _subscription.cancel();
    _billingManager.dispose();
    super.dispose();
  }
}
```

## 2. Using the Service in your UI

You can provide this service at the top of your app tree and consume it where needed.

### Initializing at Startup

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final iapService = InAppPurchaseService();
  await iapService.initialize();
  
  runApp(
    ChangeNotifierProvider.value(
      value: iapService,
      child: MyApp(),
    ),
  );
}
```

### Building a Subscription Screen

```dart
class SubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final iapService = Provider.of<InAppPurchaseService>(context);
    
    if (iapService.isLoading) return Center(child: CircularProgressIndicator());

    return ListView.builder(
      itemCount: iapService.products.length,
      itemBuilder: (context, index) {
        final product = iapService.products[index];
        return ListTile(
          title: Text(product.title),
          subtitle: Text(product.price),
          onTap: () => iapService.buyProduct(product.id),
        );
      },
    );
  }
}
```

## 3. Best Practices

### The `completePurchase` Requirement
You **MUST** call `BillingManager().completePurchase()` for every transaction that reaches a `success` or `error` (final) state. 
- If you don't call it on `success`, the user might be charged multiple times or the transaction will stay "pending" on the store's side.
- On Android, this triggers the `acknowledge` or `consume` call.
- On iOS, this finishes the transaction in the `SKPaymentQueue`.

### Handling App Restarts
If a purchase is successful but the app crashes before verification, the store will re-emit the `success` event the next time the app starts and initializes the `BillingManager`. Your listener should be ready to handle these "resumed" transactions.

### Testing
- **Android**: Use a Licensed Tester account on a real device.
- **iOS**: Use a Sandbox Tester account in the iOS Simulator or a real device.

---

*Maintained for TimeSavor project.*
