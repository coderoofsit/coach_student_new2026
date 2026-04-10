import 'purchase_status_enum.dart';

class PurchaseState {
  final PurchaseStatus status;
  final String? productId;
  final String? error;
  final dynamic originalPurchaseDetails; // Store original details for backend verification if needed

  PurchaseState({
    required this.status,
    this.productId,
    this.error,
    this.originalPurchaseDetails,
  });

  factory PurchaseState.loading({String? productId}) => PurchaseState(
        status: PurchaseStatus.loading,
        productId: productId,
      );

  factory PurchaseState.success({required String productId, dynamic originalPurchaseDetails}) => PurchaseState(
        status: PurchaseStatus.success,
        productId: productId,
        originalPurchaseDetails: originalPurchaseDetails,
      );

  factory PurchaseState.error({String? productId, required String error}) => PurchaseState(
        status: PurchaseStatus.error,
        productId: productId,
        error: error,
      );

  factory PurchaseState.cancelled({String? productId}) => PurchaseState(
        status: PurchaseStatus.cancelled,
        productId: productId,
      );

  factory PurchaseState.pending({String? productId}) => PurchaseState(
        status: PurchaseStatus.pending,
        productId: productId,
      );
}
