import 'package:coach_student/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/provider/student_provider/settings_provider.dart';
import 'package:coach_student/core/app_export.dart';

class ChangePasswordStudentScreen extends StatefulWidget {
  const ChangePasswordStudentScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordStudentScreenState createState() =>
      _ChangePasswordStudentScreenState();
}

class _ChangePasswordStudentScreenState
    extends State<ChangePasswordStudentScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController newpasswordController1 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  bool _isNewPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;

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
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Consumer(
      builder: (context, ref, child) {
        final settingsProvider = ref.watch(studentSettingProvider);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar:  AppBar(title: const Text('Change password')),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 35),
                      child: Text(
                        "Current password",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildPassword(context),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 35),
                      child: Text(
                        "New password",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildNewpassword(context),
                  const SizedBox(height: 18),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 35),
                      child: Text(
                        "Confirm new password",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildNewpassword1(context),
                  const SizedBox(height: 30),
                  _buildSaveChanges(context, settingsProvider),
                ],
              ),
            ),
          ),
        );
      },
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
        hintText: "Current password",
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
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

  Widget _buildSaveChanges(
      BuildContext context, StudentSettingProvider settings) {
    return settings.isLoading ? Utils.progressIndicator : CustomElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          settings.changePassword(
            context,
            {
              "currentPassword": passwordController.text,
              "newPassword": newpasswordController.text,
              "confirmPassword": newpasswordController1.text,
            },
          );
        }
      },
      text: "Save changes",
      margin: const EdgeInsets.only(left: 30, right: 28),
    );
  }
}
