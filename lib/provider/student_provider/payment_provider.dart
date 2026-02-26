import 'package:coach_student/services/api/api_serivce_export.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/student_model/payments_history_student.dart';

class PaymentsHistoryStudentNotifier extends ChangeNotifier {
  PaymentsHistoryStudent paymentsHistoryStudent =
      PaymentsHistoryStudent(payments: []);
  bool isLoading = false;
  Future<void> getPaymentHistory() async {
    isLoading = true;
    notifyListeners();
    Result result = await DioApi.get(path: ConfigUrl.paymentTokenGetStudent);
    if (result.response != null) {
      paymentsHistoryStudent =
          PaymentsHistoryStudent.fromJson(result.response?.data);
      isLoading = false;

      notifyListeners();
    } else {
      isLoading = false;

      notifyListeners();
    }
  }

   Future<void> studentPayemntTokenUpdate({ required num token}) async {
    Result result = await DioApi.post(
      path: ConfigUrl.paymentTokenUpdateStudent,
      data: {"token": token},
    );
    // if(result.response!=null){}
  }
}

final paymentsHistoryStudentProvider =
    ChangeNotifierProvider<PaymentsHistoryStudentNotifier>((ref) {
  return PaymentsHistoryStudentNotifier();
});
