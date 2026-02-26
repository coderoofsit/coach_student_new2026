import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../setting_provider/setting_provider.dart';

class ChangePasswordCoachScreen extends ConsumerStatefulWidget {
  const ChangePasswordCoachScreen({Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<ChangePasswordCoachScreen> createState() =>
      _ChangePasswordCoachScreenConsumerState();
}

class _ChangePasswordCoachScreenConsumerState
    extends ConsumerState<ChangePasswordCoachScreen> {
  bool _isPasswordVisible = true;
  bool _isNewPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController passwordController = TextEditingController();

  TextEditingController newpasswordController = TextEditingController();

  TextEditingController newpasswordController1 = TextEditingController();
  String? validateCurrentPassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your current password';
    }
    // Add additional validation logic here if needed.
    return null;
  }

  String? validateNewPassword(String? value, String currentPassword) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value!.isEmpty) {
      return 'Please enter a new password';
    }

    if (value == currentPassword) {
      return 'New password must be different from\nthe current password';
    }

    if (!regex.hasMatch(value)) {
      return 'Password must contain at least 8 characters,\nincluding one uppercase letter, one lowercase \nletter, one digit, and one special character (!@#\$&*~)';
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String? value, String? newPassword) {
    if (value!.isEmpty) {
      return 'Please confirm your new password';
    }

    if (value != newPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void dispose() {
    passwordController.dispose();
    newpasswordController.dispose();
    newpasswordController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: const CustomAppBarStudent(title: 'Change password'),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          // width: double.maxFinite,
          child: Column(
            children: [
              SizedBox(height: 28.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 35.h),
                  child: Text(
                    "Current password",
                    style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                  ),
                ),
              ),
              SizedBox(height: 4.v),
              _buildPassword(context),
              SizedBox(height: 18.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 35.h),
                  child: Text(
                    "New password",
                    style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                  ),
                ),
              ),
              SizedBox(height: 4.v),
              _buildNewpassword(context),
              SizedBox(height: 18.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 35.h),
                  child: Text(
                    "Confirm new password",
                    style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                  ),
                ),
              ),
              SizedBox(height: 4.v),
              _buildNewpassword1(context),
              // const Spacer(),
              SizedBox(height: 62.v),
              _buildSaveChanges(context),
              SizedBox(height: 62.v),
            ],
          ),
        ),
      ),
      ),
    );
  }

   

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 32.h,
        right: 28.h,
      ),
      child: CustomTextFormField(
          onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        hintText: "Current password",
        validator: validateCurrentPassword,
        suffix: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            size: 30.adaptSize,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
        controller: passwordController,
        obscureText: _isPasswordVisible,
      ),
    );
  }

  /// Section Widget
  Widget _buildNewpassword(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        left: 32.h,
        right: 28.h,
      ),
      child: CustomTextFormField(
        hintText: "New password",
          onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        validator: (val) => validateNewPassword(val, passwordController.text),
        suffix: IconButton(
          icon: Icon(
            _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
            size: 30.adaptSize,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isNewPasswordVisible = !_isNewPasswordVisible;
            });
          },
        ),
        controller: newpasswordController,
        obscureText: _isNewPasswordVisible,
      ),
    );
  }

  /// Section Widget
  Widget _buildNewpassword1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 32.h,
        right: 28.h,
      ),
      child: CustomTextFormField(
        hintText: "Confirm new password",
          onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        validator: (value) =>
            validateConfirmPassword(value, newpasswordController.text),
        suffix: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
            size: 30.adaptSize,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
        controller: newpasswordController1,
        textInputAction: TextInputAction.done,
        obscureText: _isConfirmPasswordVisible,
      ),
    );
  }

  /// Section Widget
  Widget _buildSaveChanges(BuildContext context) {
    return ref.watch(settingCoachProvider).isLoadingPasswordChange ? Utils.progressIndicator : CustomElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          ref.read(settingCoachProvider).changePassword(
                context,
                currentPassword: passwordController.text,
                newPassword: newpasswordController.text,
                confirmsPassword: newpasswordController1.text,
              );
        }
      },
      text: "Save Changes",
      margin: EdgeInsets.only(
        left: 30.h,
        right: 28.h,
      ),
    );
  }
}
