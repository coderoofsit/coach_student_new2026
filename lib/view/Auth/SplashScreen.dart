import 'dart:async';
import 'dart:developer';

import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';

import '../../services/notification_service/local_notificaiton.dart';

class SplashOneScreen extends StatefulWidget {
  const SplashOneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<SplashOneScreen> createState() => _SplashOneScreenState();
}

class _SplashOneScreenState extends State<SplashOneScreen> {
  @override
  void initState() {
    // initMediaQueary(context);
    log("userType--------${SharedPreferencesManager.getUserType()}");
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //     LocalNotification.showNotificationContent(
    //         id: 1,
    //         title: message.notification?.title ?? "",
    //         body: message.notification?.body ?? ""
    //
    //         // urlImage: message.da
    //         );
    //   }
    // });
    Timer(const Duration(milliseconds: 700), () {
      String userType = SharedPreferencesManager.getUserType();

      print("user type == $userType");

      if (SharedPreferencesManager.getToken().isNotEmpty) {
        switch (userType) {
          case Utils.coachType:
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.coachBottomNavBar, (route) => false);

            // (context, AppRoutes.coachBottomNavBar);
            break;
          case Utils.studentType:
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.studentBottomNavBarScreen, (route) => false);
            break;

          case Utils.parentsType:
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.studentBottomNavBarScreen, (route) => false);
            break;
          default:
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.pushNamedAndRemoveUntil(context,
                AppRoutes.selectCoachOrStudentOneScreen, (route) => false);
        }
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.selectCoachOrStudentOneScreen, (route) => false);
      }
    });

    // Timer(const Duration(seconds: 1), () {
    //   if (SharedPreferencesManager.getToken().isNotEmpty) {
    //     // Navigator.pushReplacementNamed(context, AppRoutes.selectCoachOrStudentOneScreen);
    //     if (SharedPreferencesManager.getUserType() == Utils.coachType) {
    //       Navigator.pushNamed(context, AppRoutes.coachBottomNavBar);
    //     } else if (SharedPreferencesManager.getUserType() ==
    //         Utils.studentType) {
    //       Navigator.pushNamed(context, AppRoutes.studentBottomNavBarScreen);
    //     } else {
    //       Navigator.pushReplacementNamed(
    //           context, AppRoutes.selectCoachOrStudentOneScreen);
    //     }
    //   } else {
    //     Navigator.pushReplacementNamed(
    //         context, AppRoutes.selectCoachOrStudentOneScreen);
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 24.h),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(
                flex: 40,
              ),
              CustomImageView(
                imagePath: ImageConstant.appLogo,
                height: 200.v,
                // width: 130.h,
                fit: BoxFit.cover,
                // margin: EdgeInsets.only(right: 33.h),
              ),
              // SizedBox(height: 20.v),
              // RichText(
              //   text: TextSpan(
              //     children: [
              //       TextSpan(
              //         text: "Credit",
              //         style: CustomTextStyles.displayMediumPublicSans,
              //       ),
              //       TextSpan(
              //         text: "Vault",
              //         style: CustomTextStyles.displayMediumPublicSansYellowA400,
              //       ),
              //     ],
              //   ),
              //   textAlign: TextAlign.left,
              // ),
              const Spacer(
                flex: 59,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
