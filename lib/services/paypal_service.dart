import 'package:flutter/foundation.dart';
import '../services/api/api.dart';
import '../services/api/configurl.dart';

class PayPalService {
  // sandboxMode, clientId, secretKey are no longer needed on the frontend.

  /// Creates a PayPal order via the backend.
  /// Returns the approval URL for the user to authorize payment.
  Future<String?> createBackendOrder({required String amount}) async {
    try {
      final result = await DioApi.post(
        path: ConfigUrl.createPayPalOrder,
        data: {'amount': amount},
      );

      if (result.response != null && result.response!.statusCode == 200) {
        final data = result.response!.data as Map<String, dynamic>;
        return data['approvalUrl'];
      } else {
        if (kDebugMode)
          print('Backend createOrder failed: ${result.dioError?.message}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('PayPal createBackendOrder error: $e');
      }
    }
    return null;
  }
}
