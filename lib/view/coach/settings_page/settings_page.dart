import 'dart:developer';

import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/view/coach/paypal_connect/paypal_connect_screen.dart';
import 'package:coach_student/view/coach/qr_screen/qr_screen_coach.dart';
import 'package:coach_student/view/coach/settings_page/MyClinetStudentListScreen/MyClinetStudentList.dart';
import 'package:coach_student/view/coach/settings_page/user_feedback/user_feedback.dart';
import 'package:flutter/widgets.dart';

import '../../../widgets/dialogs.dart';
import '../../student_view/settings_page/faq_screen/faq_screen.dart';
import '../../student_view/settings_page/legal_policies_screen/legal_policies_screen.dart';
import 'about_us/about_us_screen.dart';
import 'account_info/account_info_coach.dart';
import 'change_password_screen/change_password_screen.dart';
import 'contact_us_screen/contact_us_screen.dart';
import 'delete_account_screen/delete_account_coach.dart';
import 'my_profile_coach/my_profile_coach.dart';
import 'manage_plans/manage_plans_screen.dart';
import 'package:coach_student/core/app_export.dart';

import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class SettingsCoachPage extends StatelessWidget {
  const SettingsCoachPage({Key? key})
      : super(
          key: key,
        );
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 0.v),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20.h,
            right: 20.h,
            bottom: 5.v,
          ),
          child: Column(
            children: [
              //  student section end
              SizedBox(height: 24.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Payment settings",
                  style: CustomTextStyles.titleLargeBlack900,
                ),
              ),
              SizedBox(height: 10.v),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PayPalConnectScreen()));
                  },
                  child: _buildConnect(context),),
              SizedBox(height: 15.v),
              _buildManagePlans(context),
              SizedBox(height: 19.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Settings",
                  style: CustomTextStyles.titleLargeBlack900,
                ),
              ),
              SizedBox(height: 13.v),
              _buildIconoiruser(context),
              SizedBox(height: 15.v),
              _buildAccountInformation(context),

              SizedBox(height: 15.v),
              _buildPasscode(context),
              SizedBox(height: 15.v),
              _buildStarredAccount(context),
              SizedBox(height: 15.v),
              _buildPassword(context),

              SizedBox(height: 15.v),
              _buildContactUs(context),

              SizedBox(height: 15.v),
              _buildAboutUS(context),

              SizedBox(height: 15.v),
              _buildLegalPolicies(context),
              SizedBox(height: 15.v),
              _buildFaq(context),
              SizedBox(height: 15.v),
              _buildUserFeedback(context),
              SizedBox(height: 15.v),
              _buildAntdesigndeleteoutlined(context),
              SizedBox(height: 15.v),
              _buildLogout(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildConnect(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.paypalLogo,
            height: 43.adaptSize,
            width: 43.adaptSize,
            radius: BorderRadius.circular(
              3.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 19.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect to PayPal',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.fSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5.v),
                Text(
                  'Link for payouts',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6000000238418579),
                    fontSize: 12.fSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                    height: 0.12,
                    letterSpacing: -0.26,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgFrame,
            height: 24.adaptSize,
            width: 24.adaptSize,
            margin: EdgeInsets.only(
              top: 9.v,
              right: 10.h,
              bottom: 10.v,
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildIconoiruser(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "Profile info",
      onTap: () {
        log("Tap ");
        // SettingCoachProvider().getProfileInfoCaoch(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyProfileCoach(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(15.h, 12.v, 12.h, 13.v),
        child: Icon(
          Icons.settings_outlined,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildAccountInformation(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountInfoScreenCoach(),
          ),
        );
      },
      hintText: "Account info",
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(17.h, 14.v, 14.h, 15.v),
        child: Icon(
          Icons.account_circle_outlined,
          size: 21.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildPasscode(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      onTap: () {
        log("Tap ");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QrScreenCoach(),
          ),
        );
      },
      hintText: "My passcode",
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(17.h, 14.v, 13.h, 14.v),
        child: Icon(
          Icons.qr_code_scanner,
          size: 20.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildStarredAccount(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      onTap: () {
        log("Tap ");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyClientStudentList(),
          ),
        );
      },
      hintText: "Clients list",
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(17.h, 14.v, 13.h, 14.v),
        child: Icon(
          Icons.group,
          color: Colors.grey[600],
          size: 25.adaptSize,
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChangePasswordCoachScreen(),
          ),
        );
      },
      hintText: "Change password",
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      textInputType: TextInputType.visiblePassword,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(18.h, 14.v, 13.h, 15.v),
        child: Icon(
          Icons.lock_outline,
          size: 21.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      obscureText: true,
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildAntdesigndeleteoutlined(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeleteAccountCoachScreen(),
          ),
        );
      },
      hintText: "Delete account",
      hintStyle: theme.textTheme.titleMedium!.copyWith(
        color: Colors.red,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      ),
      // CustomTextStyles.titleMediumBlack900SemiBold18 ,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(17.h, 13.v, 12.h, 14.v),
        child: CustomImageView(
          imagePath: ImageConstant.imgAntdesigndeleteoutlined,
          height: 23.adaptSize,
          width: 23.adaptSize,
          color: Colors.red,
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  Widget _buildAboutUS(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "About us",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  const AboutUsAboutScreen(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.info_outline,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
        // child: CustomImageView(
        //   imagePath: ,
        //   height: 25.adaptSize,
        //   width: 25.adaptSize,
        // ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  Widget _buildUserFeedback(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "User Feedback ",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>  UserFeedbackScreen(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.feed_outlined,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
        // child: CustomImageView(
        //   imagePath: ,
        //   height: 25.adaptSize,
        //   width: 25.adaptSize,
        // ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildLegalPolicies(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "Legal & Policies",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LegalPoliciesScreen(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.gavel,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildFaq(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "FAQ",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FaqScreen(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.help_outline,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildContactUs(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "Contact us",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ContactUsCoachScreen(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.phone_outlined,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  Widget _buildLogout(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "Logout",
      onTap: () async {
        final bool? isLogout = await Dialogs.logoutDialog(context);

        if (isLogout == true) {
          SharedPreferencesManager.instance.clear();
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.selectCoachOrStudentOneScreen,
            (route) => false,
          );
        }

        // final bool? isLogout = await Dialogs.logoutDialog(context);
        // if (isLogout != null) {
        //   if (isLogout == true) {
        //     SharedPreferencesManager.instance.clear();
        //     Navigator.popUntil(context, (route) => route.isFirst);
        //     Navigator.pushNamedAndRemoveUntil(context, AppRoutes.selectCoachOrStudentOneScreen, (route) => false);
        //   }
        // }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const ContactUsCoachScreen(),
        //   ),
        // );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
          margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
          child: Icon(
            Icons.logout,
            size: 25.adaptSize,
            color: Colors.grey[600],
          )
          // CustomImageView(
          //   imagePath: ImageConstant1.imgPhphonelight,
          //   height: 25.adaptSize,
          //   width: 25.adaptSize,
          // ),
          ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  Widget _buildManagePlans(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "Manage Subscription",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ManagePlansScreen(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.workspace_premium_outlined,
          size: 25.adaptSize,
          color: Colors.blueAccent,
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }
}
