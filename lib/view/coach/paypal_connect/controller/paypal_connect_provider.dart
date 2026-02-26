import 'package:coach_student/services/api/api_serivce_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/dialogs.dart';

class PaypalConnectProvider extends ChangeNotifier {
  bool isLoading = false;
  Map<String, dynamic>? paymentInfo;

  Future<void> fetchPaymentInfo(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    final result = await DioApi.get(path: ConfigUrl.paypalGetInfo);
    if (result.response != null) {
      if (result.response!.statusCode == 200) {
        final data = result.response!.data;
        if (data['success'] == true && data['paypalAccount'] != null) {
          // Handle both array and object responses
          final paypalAccountData = data['paypalAccount'];
          if (paypalAccountData is List && paypalAccountData.isNotEmpty) {
            // If it's an array, take the first element
            paymentInfo = paypalAccountData[0] as Map<String, dynamic>;
          } else if (paypalAccountData is Map) {
            // If it's already an object, use it directly
            paymentInfo = paypalAccountData as Map<String, dynamic>;
          }
        }
      }
      // 404 is expected when no payment info exists yet, so we don't show error
    } else if (result.dioError?.response?.statusCode != 404) {
      // Only show error if it's not a 404 (not found is expected)
      result.handleError(context);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> paypalConnectPost(BuildContext context,
      {required Map<String, dynamic> info}) async {
    isLoading = true;
    notifyListeners();
    final result =
        await DioApi.post(path: ConfigUrl.paypalConnected, data: info);
    if (result.response != null) {
      isLoading = false;
      notifyListeners();
      // Update local payment info after successful save
      paymentInfo = info;
      notifyListeners();
      // Navigator.of(context).pop();
      Dialogs.showSuccessDialog(
        context,
        title: "Successful!",
        subtitle: "PayPal account connected",
      ).then((value) {
        Navigator.of(context).pop();
      });
    } else {
      isLoading = false;
      notifyListeners();
      result.handleError(context);
    }
  }
}

final paypalConnectProvider =
    ChangeNotifierProvider<PaypalConnectProvider>((ref) {
  return PaypalConnectProvider();
});
