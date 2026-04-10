# Example Usage

Here is how you can integrate the `In_app_purchase` package into any Flutter application without using `setState` in the package itself.

### 1. Initialize the Billing Manager

```dart
import 'package:in_app_purchase/in_app_purchase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final billingManager = BillingManager();
  
  await billingManager.init({
    'com.example.monthly',
    'com.example.yearly',
  });
  
  runApp(MyApp());
}
```

### 2. Fetch Products

```dart
Future<void> loadProducts() async {
  final products = await BillingManager().getProducts();
  for (var product in products) {
    print('Product: ${product.title} - ${product.price}');
  }
}
```

### 3. Listen to Purchase Updates (Stream)

You can use a `StreamBuilder` or any state management (e.g., Riverpod, Bloc) to listen to updates.

```dart
StreamBuilder<PurchaseState>(
  stream: BillingManager().purchaseStream,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final state = snapshot.data!;
      switch (state.status) {
        case PurchaseStatus.loading:
          return CircularProgressIndicator();
        case PurchaseStatus.success:
          // Handle backend verification and complete purchase
          _handleSuccess(state);
          return Text('Purchase Successful!');
        case PurchaseStatus.error:
          return Text('Error: ${state.error}');
        default:
          return Container();
      }
    }
    return Container();
  },
)

void _handleSuccess(PurchaseState state) async {
  // 1. Verify with your backend if needed
  // ...
  
  // 2. Complete the purchase to finalize transaction
  await BillingManager().completePurchase(state.originalPurchaseDetails);
}
```

### 4. Start a Purchase

```dart
ElevatedButton(
  onPressed: () => BillingManager().purchase('com.example.monthly'),
  child: Text('Buy Monthly Subscription'),
)
```

### 5. Restore Purchases

```dart
ElevatedButton(
  onPressed: () => BillingManager().restorePurchases(),
  child: Text('Restore Purchases'),
)
```
