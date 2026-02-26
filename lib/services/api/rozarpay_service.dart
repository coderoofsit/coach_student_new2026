// import 'package:guru_study_centre/SharedPref/Shared_pref.dart';
// import 'package:guru_study_centre/screens/my_account/models/user_model.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class RazorPayServices {
//   static final _instance = Razorpay();

//   static Future<void> checkoutOrder(
//       // OrderModel orderModel,
//       {required num amount,
//       required Function(PaymentSuccessResponse) onSuccess,
//       required Function(PaymentFailureResponse) onFailure}) async {
//     final UserModel? userModel = SharedPreferencesManager.getUser();
//     var options = {
//       'key': 'rzp_test_MagzLHSUMsh4IP',
//       'amount': amount * 100,
//       // 'order_id': "",
//       'name': '${userModel?.name}',
//       // 'description': "",
//       "currency": "INR",
//       'prefill': {
//         'contact': "${userModel?.mob}",
//         'email': "${userModel?.email}"
//       }
//     };

//     _instance.on(Razorpay.EVENT_PAYMENT_SUCCESS,
//         (PaymentSuccessResponse response) {
//       onSuccess(response);
//       _instance.clear();
//     });

//     _instance.on(Razorpay.EVENT_PAYMENT_ERROR,
//         (PaymentFailureResponse response) {
//       onFailure(response);
//       _instance.clear();
//     });

//     _instance.open(options);
//   }
// }
