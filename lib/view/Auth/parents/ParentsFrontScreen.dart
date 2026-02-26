import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_outlined_button.dart';

import '../../../core/utils/utils.dart';

class ParentsAuthScreen extends StatelessWidget {
  final String userType;
  const ParentsAuthScreen({required this.userType, Key? key})
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
              SizedBox(height: 61.v),
              CustomImageView(
                imagePath: ImageConstant.imgGroup2266,
                height: 254.v,
                width: 255.h,
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 27.h),
                fit: BoxFit.fill,
              ),
              SizedBox(height: 33.v),
              Text(
                "Welcome Parent",
                style: theme.textTheme.headlineMedium,
              ),
              SizedBox(height: 4.v),
              Text(
                "Find students who wants to learn",
                style: CustomTextStyles.titleLargeOnErrorContainerRegular,
              ),
              SizedBox(height: 46.v),
              CustomOutlinedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.loginScreen, arguments: {
                    'userType': userType,
                  });
                },
                text: "I have an Account",
              ),
              SizedBox(height: 25.v),
              CustomElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.registationScreen,
                      arguments: {
                        'userType': userType,
                      });
                },
                text: "Get Started",
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
