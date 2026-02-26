import 'package:coach_student/core/extension.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_icon_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String userType;
  const RegisterScreen({required this.userType, Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenConsumerState();
}

class _RegisterScreenConsumerState extends ConsumerState<RegisterScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = true;
  bool _isPasswordVisibleC = true;
  String? validatePassword(String? value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

    if (value!.isEmpty) {
      return 'Password is required'; // More explicit message for empty field
    } else {
      if (!regex.hasMatch(value)) {
        return 'Password must contain at least 8 characters, including\n one uppercase letter, one lowercase letter, one digit,\n and one special character (!@#\$&*~)'; // Detailed error message
      } else {
        return null;
      }
    }
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
          // autovalidateMode: AutovalidateMode.,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSixtyFour(context, ref),
                SizedBox(height: 20.v),
                Padding(
                  padding: EdgeInsets.only(left: 30.h),
                  child: Text(
                    "Register",
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                SizedBox(height: 1.v),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 320.h,
                    margin: EdgeInsets.only(
                      left: 30.h,
                      right: 39.h,
                    ),
                    child: Text(
                      "Please provide the details below and create \nan account.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: CustomTextStyles.bodyLargeLato.copyWith(
                        height: 1.29,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 32.v),
                Padding(
                  padding: EdgeInsets.only(left: 33.h),
                  child: Text(
                    "Email address",
                    style: CustomTextStyles.titleMediumBlack900_3,
                  ),
                ),
                SizedBox(height: 4.v),
                _buildEmail(context),
                SizedBox(height: 19.v),
                Padding(
                  padding: EdgeInsets.only(left: 33.h),
                  child: Text(
                    "Password",
                    style: CustomTextStyles.titleMediumBlack900_3,
                  ),
                ),
                SizedBox(height: 4.v),
                _buildPassword(context),
                SizedBox(height: 18.v),
                Padding(
                  padding: EdgeInsets.only(left: 33.h),
                  child: Text(
                    "Confirm password",
                    style: CustomTextStyles.titleMediumBlack900_3,
                  ),
                ),
                SizedBox(height: 4.v),
                _buildConfirmpassword(context),
                SizedBox(height: 15.v),
                _buildContinue(context, ref),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _buildContinue(context, ref),
    );
  }

  String? validateMatchPasswords() {
    String newPassword = passwordController.text;
    String confirmPassword = confirmpasswordController.text;

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      return 'Please enter both passwords';
    }

    if (newPassword != confirmPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Section Widget
  Widget _buildSixtyFour(BuildContext context, WidgetRef ref) {
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
                    )
                  ],
                )
                ,
                Padding(
                  padding: EdgeInsets.only(
                    top: 11.v,
                    bottom: 10.v,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already user?",
                          style: theme.textTheme.bodyMedium,
                        ),
                        const TextSpan(
                          text: " ",
                        ),
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Navigator.popUntil(
                              //     context, (route) => route.isFirst);
                              Navigator.of(context).pushReplacementNamed(
                                  AppRoutes.loginScreen,
                                  arguments: {'userType': widget.userType});
                            },
                          text: "Login",
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
  Widget _buildEmail(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
        controller: emailController,
        hintText: "Enter your email address",
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        textInputType: TextInputType.emailAddress,
        alignment: Alignment.center,
        validator: (input) =>
            input!.isValidEmail() ? null : "Please enter your email address",
        //  Validators.compose([
        //   Validators.required('Email is required'),
        //   Validators.email('Invalid email address'),
        // ]),
      ),
    );
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
          onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
          controller: passwordController,

          hintText: "Enter your password",
          textCapitalization: TextCapitalization.none,
          textInputType: TextInputType.visiblePassword,
          alignment: Alignment.center,
          obscureText: _isPasswordVisible,
          suffix: GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(right: 8.h),
              child: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
          validator: validatePassword
          //    validator: Validators.compose([
          //   Validators.required('Password is required'),

          //   Validators.patternString(
          //       r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
          //       'Password must be at least 8 characters long and \ninclude at least one uppercase letter, one lowercase\n letter, one digit, and one special character (!@#\$&*~)')
          // ]),
          ),
    );
  }

  /// Section Widget
  Widget _buildConfirmpassword(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
        controller: confirmpasswordController,
        textCapitalization: TextCapitalization.none,
        hintText: "Enter the same password ",
        textInputAction: TextInputAction.done,
        textInputType: TextInputType.visiblePassword,

        alignment: Alignment.center,
        suffix: GestureDetector(
          child: Padding(
            padding: EdgeInsets.only(right: 8.h),
            child: Icon(
              _isPasswordVisibleC ? Icons.visibility : Icons.visibility_off,
              size: 30.adaptSize,
              color: Colors.grey,
            ),
          ),
          onTap: () {
            setState(() {
              _isPasswordVisibleC = !_isPasswordVisibleC;
            });
          },
        ),
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        obscureText: _isPasswordVisibleC,
        validator: (val) => validateMatchPasswords(),
      ),
    );
  }

  /// Section Widget
  Widget _buildContinue(BuildContext context, WidgetRef ref) {
    // final studentProvider = ref.read(authNotifier);
    // Provider.of<StudentProvider>(context, listen:  false);
    return CustomElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Map<String, String> arguments = {
            'email': emailController.text,
            'password': passwordController.text,
            'userType': widget.userType,
          };

          String route;

          switch (widget.userType) {
            case Utils.studentType:
              route = AppRoutes.studentSignup;
              break;
            case Utils.parentsType:
              route = AppRoutes.parentsRegistation;
              break;
            default:
              route = AppRoutes.registerCoach;
              break;
          }

          Navigator.pushNamed(context, route, arguments: arguments);
        }
      },
      text: "Continue",
      margin: EdgeInsets.only(
        left: 30.h,
        right: 30.h,
        bottom: 40.v,
      ),
    );
  }
}
