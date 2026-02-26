import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_outlined_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/utils/utils.dart';

class StudentRegScreen extends StatelessWidget {
  final String userType;
  const StudentRegScreen({required this.userType, Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 30.h),
          child: Column(
            children: [

             Utils.arrowBackButton(context),
              SizedBox(height: 30.v),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Credit",
                      style: CustomTextStyles.displaySmallPublicSans,
                    ),
                    TextSpan(
                      text: "Vault",
                      style: CustomTextStyles.displaySmallPublicSansYellowA400,
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
             const SizedBox(
               height: 60,
             ),

             Center(child: CustomImageView(
               imagePath: ImageConstant.imgGroup2266,
               height: 254.v,
               width: 255.h,
               alignment: Alignment.center,
               fit: BoxFit.fill,
             )
               ,) ,
              SizedBox(height: 33.v),
              Text(
                "Welcome Student",
                style: theme.textTheme.headlineMedium,
              ),
              SizedBox(height: 6.v),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "under 13 must register in ",
                      style: CustomTextStyles.titleLargeOnErrorContainerRegular,
                    ),
                    TextSpan(
                      text: "Parent",
                      style: CustomTextStyles.titleLargeOnErrorContainerRegular.copyWith(
                        decoration: TextDecoration.underline,
                        color: theme.colorScheme.secondary,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.parentsAuthScreen,
                            arguments: {'userType': Utils.parentsType},
                          );
                        },
                    ),
                    TextSpan(
                      text: " section",
                      style: CustomTextStyles.titleLargeOnErrorContainerRegular,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 45.v),
              CustomOutlinedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.loginScreen, arguments: {
                    'userType': userType,
                  });
                },
                text: "I have an account",
              ),
              SizedBox(height: 25.v),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registationScreen,
                      arguments: {
                        'userType': userType,
                      });
                },
                text: "Get started",
                buttonStyle: CustomButtonStyles.fillOnErrorContainer,
                buttonTextStyle: CustomTextStyles.titleMediumBlack90018,
              ),
              SizedBox(height: 5.v),
            ],
          ),
        ),
      ),
    );
  }
}
