import 'dart:developer';

import 'package:coach_student/core/extension.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/view/Auth/AuthProvider/AuthProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_icon_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../SharedPref/Shared_pref.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String userType;
  const LoginScreen({required this.userType, Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenConsumerState();
}

class _LoginScreenConsumerState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;

 Future<void> setFcm() async{
   await  SharedPreferencesManager().init();
   await FirebaseMessaging.instance.setAutoInitEnabled(true);
   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
     alert: true, // Required to display a heads up notification
     badge: true,
     sound: true,
   );
   FirebaseMessaging messaging = FirebaseMessaging.instance;

   NotificationSettings settings = await messaging.requestPermission(
     alert: true,
     announcement: true,
     badge: true,
     carPlay: true,
     criticalAlert: true,
     provisional: true,
     sound: true,
   );
   log('User granted permission: ${settings.authorizationStatus}');
   FirebaseMessaging.instance.getToken().then((value) {
     SharedPreferencesManager.setFcmToken(fcmToken: value ?? "");
     logger.i("fcm token Main ${SharedPreferencesManager.getFcmToken()}");
   });
 }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setFcm();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildView(context),
                SizedBox(height: 20.v),
                Padding(
                  padding: EdgeInsets.only(left: 30.h),
                  child: Text(
                    "Hi, How are you?",
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                SizedBox(height: 1.v),
                Padding(
                  padding: EdgeInsets.only(left: 30.h,),
                  child: Text(
                    "Please provide the email id & password",
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 27.v),
                Padding(
                  padding: EdgeInsets.only(left: 33.h,),
                  child: Text(
                    "Email address",
                    style: CustomTextStyles.titleMediumBlack900_3,
                  ),
                ),
                SizedBox(height: 4.v,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.h),
                  child: CustomTextFormField(
                    controller: emailController,
                    hintText: "Enter your email address",
                    onTapOutside: (val) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    textInputType: TextInputType.emailAddress,
                    validator: (input) => input!.isValidEmail()
                        ? null
                        : "Please enter your email address",
                    alignment: Alignment.center,
                  ),
                ),
                SizedBox(height: 18.v),
                Padding(
                  padding: EdgeInsets.only(left: 33.h),
                  child: Text(
                    "Password",
                    style: CustomTextStyles.titleMediumBlack900_3,
                  ),
                ),
                SizedBox(height: 4.v),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.h),
                  child: CustomTextFormField(
                    textCapitalization: TextCapitalization.none,
                    controller: passwordController,
                    hintText: "Enter your password",
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.visiblePassword,
                    validator: (val) => val!.isEmpty
                        ? "Please Enter your valid password"
                        : null,
                    alignment: Alignment.center,
                    onTapOutside: (val) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    obscureText: _isPasswordVisible,
                    suffix: GestureDetector(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.h),
                        child: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 30.adaptSize,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 8.v),
                Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutes.forgotPasswordScreen , arguments: {
                            'userType':widget.userType
                          });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 30.h),
                      child: Text(
                        "Forgot password?",
                        style: CustomTextStyles.titleSmallPrimary_1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.v),
                _buildLogin(context, ref)
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _buildLogin(context, ref),
    );
  }

  /// Section Widget
  Widget _buildView(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      decoration: AppDecoration.fillPrimary1,
      child: Column(
        children: [
          SizedBox(height: 22.v),
          Padding(
            padding: EdgeInsets.only(right: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Icon(Icons.arrow_back_ios)),
                    CustomIconButton(
                      height: 42.adaptSize,
                      width: 42.adaptSize,
                      padding: EdgeInsets.all(3.h),
                      child: CustomImageView(
                        imagePath: ImageConstant.imgGroup2270,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 11.v,
                    bottom: 10.v,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "New user?",
                          style: theme.textTheme.bodyMedium,
                        ),
                        const TextSpan(
                          text: " ",
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              log("usertype + ${widget.userType}");
                              // Navigator.popUntil(
                              //     context, (route) => route.isFirst);
                              Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.registationScreen,
                                  arguments: {'userType': widget.userType});
                            },
                          text: "Register",
                          style: CustomTextStyles.titleMediumPrimaryBold18,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 11.v),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildLogin(BuildContext context, WidgetRef ref) {
    return ref.watch(authNotifier).isLoadingSign
        ? Utils.progressIndicator
        : CustomElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref.read(authNotifier).signIn(context,
                    email: emailController.text,
                    password: passwordController.text,
                    userType: widget.userType);
              }
              // Navigator.of(context).pushNamed(
              //   AppRoutes.studentHomeScreen,
              // );
            },
            text: "Login",
            margin: EdgeInsets.only(
              left: 30.h,
              right: 30.h,
              bottom: 40.v,
            ),
          );
  }
}
