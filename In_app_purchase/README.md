# IAP Package

`iap_package` is a streamlined, platform-agnostic wrapper for handling In-App Purchases (IAP) in Flutter applications. It abstracts the complexities of `in_app_purchase` for both Android and iOS, providing a unified API for fetching products, making purchases, and handling transaction states.

## Features

- **Simplified Singleton**: Access all IAP logic through a single `BillingManager`.
- **Platform Agnostic**: Handles differences between Google Play Billing and Apple StoreKit automatically.
- **State Analysis**: Stream-based updates for real-time purchase status tracking.
- **Easy Verification**: Provides all necessary data for backend receipt verification.
- **Supports Consumables & Subscriptions**: Flexible purchase options.

## Getting Started

### 1. Add Dependency

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  iap_package:
    path: ../In_app_purchase # Or your specific path
```

### 2. Basic Setup

Initialize the `BillingManager` with your product IDs (from Google Play Console / App Store Connect) as early as possible (e.g., in `main` or your service's `init`).

```dart
import 'package:iap_package/iap_package.dart';

final Set<String> _productIds = {
  'com.yourapp.monthly_sub',
  'com.yourapp.yearly_pro',
  'com.yourapp.coins_pack'
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BillingManager().init(_productIds);
  runApp(MyApp());
}
```

## Core API Reference

### `BillingManager` (Singleton)

| Method | Description |
| :--- | :--- |
| `init(Set<String> productIds)` | Initializes the manager and fetches product details from the stores. |
| `getProducts()` | Returns a `List<ProductModel>` containing fetched product information. |
| `purchase(String productId, {bool isConsumable = true})` | Starts the purchase flow for the given product ID. |
| `restorePurchases()` | Triggers the platform's "Restore Purchases" flow (useful for iOS). |
| `completePurchase(dynamic purchaseDetails)` | Finalizes a transaction. **Crucial** to call this after verification to avoid duplicate charges or "ghost" transactions. |
| `purchaseStream` | A `Stream<PurchaseState>` that emits updates on the current purchase process. |
| `dispose()` | Cleans up subscriptions and resources. |

---

### `ProductModel`

This model represents a product available in the store.

- `id`: The unique product ID.
- `title`: The localized title of the product.
- `description`: The localized description.
- `price`: The formatted price string (e.g., "$9.99").
- `currencyCode`: The ISO currency code (e.g., "USD").
- `rawPrice`: The numerical price value (e.g., 9.99).

---

### `PurchaseState`

Emitted by the `purchaseStream` to track the state of a transaction.

- `status`: A `PurchaseStatus` enum value.
- `productId`: The ID of the product being purchased.
- `error`: An error message if the status is `error`.
- `originalPurchaseDetails`: The raw platform-specific data (used for backend verification).

---

### `PurchaseStatus` (Enum)

- `loading`: The purchase flow is starting.
- `pending`: Payment is processing (e.g., waiting for bank approval).
- `success`: Payment was successful. **Proceed to verification.**
- `error`: Something went wrong during the process.
- `cancelled`: The user closed the store UI without purchasing.

## Usage Example

For a detailed implementation guide including backend verification and state management (like Riverpod), see [INTEGRATION_GUIDE.md](./INTEGRATION_GUIDE.md).

```dart
// Listening to updates
BillingManager().purchaseStream.listen((state) {
  if (state.status == PurchaseStatus.success) {
    // 1. Verify receipt with your backend
    // 2. Call BillingManager().completePurchase(state.originalPurchaseDetails)
  }
});

// Triggering a purchase
await BillingManager().purchase('com.yourapp.premium_monthly');
```

## Platform-Specific Configuration

### Android
Ensure the billing permission is in your `AndroidManifest.xml`:
```xml
<uses-permission android:name="com.android.vending.BILLING" />
```

### iOS
Enable "In-App Purchase" in your project's "Signing & Capabilities" tab in Xcode.

---

*Maintained for TimeSavor project.*
