import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContactUsCoachScreen extends StatelessWidget {
  const ContactUsCoachScreen({Key? key})
      : super(
          key: key,
        );

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
        appBar: const CustomAppBarStudent(
          title: 'Contact Us',
        ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            SizedBox(height: 20.v),
            _buildVuesaxLinearSmsEdit(context),
            const Spacer(),
          ],
        ),
      ),
      // bottomNavigationBar: _buildSendEmail(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildVuesaxLinearSmsEdit(BuildContext context) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.symmetric(
        horizontal: 53.h,
        vertical: 18.v,
      ),
      decoration: AppDecoration.fillGray50.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 2.v),
          CustomImageView(
            imagePath: ImageConstant.imgVuesaxLinearSmsEdit,
            height: 45.adaptSize,
            width: 45.adaptSize,
          ),
          SizedBox(height: 20.v),
          Text(
            "Write us your query through mail",
            style: CustomTextStyles.titleMediumBlack900SemiBold,
          ),
          SizedBox(height: 3.v),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 1.v),
                  child: Text(
                    "Email : ",
                    style: CustomTextStyles.titleSmallGray500,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 3.h),
                  child: Text(
                    "creditvaultapp@gmail.com",
                    style: CustomTextStyles.titleSmallGray500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  // Widget _buildSendEmail(BuildContext context) {
  //   return CustomElevatedButton(
  //     onPressed: () {
  //       Utils.email(email: 'happytales@gmail.com');
  //     },
  //     text: "Send Email",
  //     margin: EdgeInsets.only(
  //       left: 30.h,
  //       right: 30.h,
  //       bottom: 60.v,
  //     ),
  //   );
  // }
}
