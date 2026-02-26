import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/provider/student_provider/settings_provider.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/custom_text_form_field.dart';
import '../../../../widgets/dialogs.dart';

class DeleteAccountStudentScreen extends ConsumerWidget {
  const DeleteAccountStudentScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, ref) {
    mediaQueryData = MediaQuery.of(context);

    final settingsData = ref.watch(studentSettingProvider);

    return Scaffold(
      appBar: const CustomAppBarStudent(title: 'Delete Account') ,
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 30.h,
          vertical: 43.v,
        ),
        child: Column(
          children: [
            CustomImageView(
              imagePath: SharedPreferencesManager.getStudentPorfile()?.image?.url,
              height: 95.adaptSize,
              width: 95.adaptSize,
              radius: BorderRadius.circular(
                47.h,
              ),
            ),
            SizedBox(height: 18.v),
            Container(
              width: 268.h,
              margin: EdgeInsets.symmetric(horizontal: 31.h),
              child: Text(
                "Are you sure you want to delete\n your account?",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: CustomTextStyles.titleMediumBlack90018.copyWith(
                  height: 1.11,
                ),
              ),
            ),
            SizedBox(height: 56.v),
            _buildDeletingYourAccount(context),
            const Spacer(),
            SizedBox(height: 19.v),
            CustomElevatedButton(
              onPressed: () async{
                final bool? isLogout = await Dialogs.deleteDialog(context);
                 if(isLogout ?? false){
                   settingsData.deleteAccount(context);
                 }

    
              },
              text: "Delete account",
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildDeletingYourAccount(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 9.h),
      padding: EdgeInsets.symmetric(
        horizontal: 18.h,
        vertical: 20.v,
      ),
      decoration: AppDecoration.fillGray50.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant1.imgGroup379,
            height: 45.adaptSize,
            width: 45.adaptSize,
          ),
          SizedBox(height: 10.v),
          Text(
            "Deleting your account is permanent",
            style: CustomTextStyles.titleSmallBlack900,
          ),
          SizedBox(height: 6.v),
          SizedBox(
            width: 282.h,
            child: Text(
              "Your classes, favourite coaches and Meetings\n will be permanently deleted.",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.bodyMediumBlack900,
            ),
          ),
          SizedBox(height: 8.v),
        ],
      ),
    );
  }
}

Widget _buildLogout(BuildContext context,StudentSettingProvider settingProvider) {
  return CustomTextFormField(
    readOnly: true,
    hintText: "Logout",
    onTap: () async {
      final bool? isLogout = await Dialogs.deleteDialog(context);

      if (isLogout == true) {
        SharedPreferencesManager.instance.clear();
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.selectCoachOrStudentOneScreen,
              (route) => false,
        );
      }


    },
    hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
    prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.logout,
          size: 25.adaptSize,
        )

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
