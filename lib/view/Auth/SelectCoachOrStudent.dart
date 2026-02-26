import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/utils.dart';
import 'AuthWidgets/SelectCoachOrStudentWidget.dart';

class SelectCoachOrStudentOneScreen extends ConsumerWidget {
  const SelectCoachOrStudentOneScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: SafeArea(child: LayoutBuilder(
        builder: (context, constraints) {
          double verticalSpace =
              constraints.maxHeight * 0.04; // 5% of screen height

          return SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: verticalSpace),

                  // Logo responsive size
                  CustomImageView(
                    imagePath: ImageConstant.logo,
                    height: constraints.maxHeight * 0.2, // 20% screen height
                    width: constraints.maxWidth * 0.3, // 20% screen width
                  ),

                  SizedBox(height: verticalSpace * 0.5),

                  // Welcome text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Welcome to",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(width: 6),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Credit",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            TextSpan(
                              text: "Vault",
                              style: CustomTextStyles
                                  .headlineSmallPublicSansYellowA400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: verticalSpace * 2),

                  Text(
                    "Please choose your account type",
                    style: CustomTextStyles.titleLargeOnErrorContainer,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: verticalSpace),

                  _buildSelectcoachorstudentOne(context),
                ],
              ),
            ),
          );
        },
      )),
    );
  }

  /// Section Widget
  Widget _buildSelectcoachorstudentOne(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWide =
            constraints.maxWidth > 600; // Fold / Tablet layout threshold

        if (isWide) {
          // Grid for foldables/tablets
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: [
              SelectcoachorStudentoneItemWidget(
                imageString: ImageConstant.studentImage,
                title: "Student",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.studentRegScreen,
                      arguments: {'userType': Utils.studentType});
                },
              ),
              SelectcoachorStudentoneItemWidget(
                imageString: ImageConstant.coach,
                title: "Coach/Freelancer",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.coachAuthScreen,
                      arguments: {'userType': Utils.coachType});
                },
              ),
              SelectcoachorStudentoneItemWidget(
                imageString: ImageConstant.parentsImage,
                title: "Parents",
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.parentsAuthScreen,
                      arguments: {'userType': Utils.parentsType});
                },
              ),
            ],
          );
        }

        // Normal phone portrait layout
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SelectcoachorStudentoneItemWidget(
                    imageString: ImageConstant.studentImage,
                    title: "Student",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.studentRegScreen,
                          arguments: {'userType': Utils.studentType});
                    },
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: SelectcoachorStudentoneItemWidget(
                    imageString: ImageConstant.coach,
                    title: "Coach/Freelancer",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.coachAuthScreen,
                          arguments: {'userType': Utils.coachType});
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            SelectcoachorStudentoneItemWidget(
              imageString: ImageConstant.parentsImage,
              title: "Parents",
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.parentsAuthScreen,
                    arguments: {'userType': Utils.parentsType});
              },
            ),
          ],
        );
      },
    );
  }
}
