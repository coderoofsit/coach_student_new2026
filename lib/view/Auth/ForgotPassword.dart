import 'package:coach_student/core/extension.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/view/Auth/AuthProvider/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore_for_file: must_be_immutable
class ForgotPasswordScreen extends ConsumerWidget {
  final String userType;
  ForgotPasswordScreen({Key? key, required this.userType}) : super(key: key);

  TextEditingController emailController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                children: [
                  _buildView(context),
                  SizedBox(height: 20.v),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 30.h),
                          child: Text("Forgot Password?",
                              style: theme.textTheme.headlineLarge))),
                  SizedBox(height: 1.v),
                  Text("Please provide the Registered Email address",
                      style: theme.textTheme.bodyLarge),
                  SizedBox(height: 27.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 33.h),
                      child: Text("Email Address",
                          style: CustomTextStyles.titleMediumBlack900_3),
                    ),
                  ),
                  SizedBox(height: 4.v),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.h),
                    child: CustomTextFormField(
                        controller: emailController,
                        hintText: "Enter your email address",
                        validator: (input) => input!.isValidEmail()
                            ? null
                            : "Please enter your email address",
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.emailAddress),
                  ),
                  SizedBox(height: 50.v),
                  ref.watch(authNotifier).isLoadingForgetPassword ? Utils.progressIndicator:
                  CustomElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ref.read(authNotifier).forgetPassword(context,
                            userType: userType, email: emailController.text);
                      }
                    },
                    text: "Submit",
                    margin: EdgeInsets.symmetric(horizontal: 30.h),
                  ),
                  SizedBox(height: 5.v)
                ],
              ),
            ),
          ),
        ));
  }

  /// Section Widget
  Widget _buildView(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      decoration: AppDecoration.fillPrimary2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 29.v),
          Padding(
              padding: EdgeInsets.only(right: 87.h),
              child: Row(children: [
                SizedBox(
                    height: 30.adaptSize,
                    width: 30.adaptSize,
                    child: Stack(alignment: Alignment.center, children: [
                      CustomImageView(
                          imagePath: ImageConstant.imgArrowLeft,
                          height: 30.adaptSize,
                          width: 30.adaptSize,
                          alignment: Alignment.center,
                          onTap: () {
                            Navigator.of(context).pop();
                          }),
                      CustomImageView(
                          imagePath: ImageConstant.imgArrowLeft,
                          height: 30.adaptSize,
                          width: 30.adaptSize,
                          alignment: Alignment.center)
                    ])),
                Padding(
                    padding: EdgeInsets.only(left: 58.h, top: 2.v),
                    child: Text("Forgot Password",
                        style: CustomTextStyles.titleLargeGray900))
              ])),
          SizedBox(height: 15.v)
        ],
      ),
    );
  }

  /// Navigates back to the previous screen.
  onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
