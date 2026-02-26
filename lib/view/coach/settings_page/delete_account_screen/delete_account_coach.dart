import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/provider/coach/coach_profile_provider.dart';
import 'package:coach_student/view/coach/settings_page/setting_provider/setting_provider.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../widgets/dialogs.dart';

class DeleteAccountCoachScreen extends ConsumerStatefulWidget {
  const DeleteAccountCoachScreen({Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<DeleteAccountCoachScreen> createState() =>
      _DeleteAccountCoachScreenConsumerState();
}

class _DeleteAccountCoachScreenConsumerState
    extends ConsumerState<DeleteAccountCoachScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    // final imageUrl = ref.watch(coachProfileProvider).coachProfileDetailsModel.;

    return Scaffold(
      appBar: const CustomAppBarStudent(title: 'Delete account'),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 30.h,
          vertical: 43.v,
        ),
        child: Column(
          children: [
            CustomImageView(
              imagePath: ref
                  .watch(coachProfileProvider)
                  .coachProfileDetailsModel
                  .image
                  ?.url,
              height: 95.adaptSize,
              width: 95.adaptSize,
              fit: BoxFit.cover,
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
            isLoading
                ? Utils.progressIndicator
                : CustomElevatedButton(
                    onPressed: () async {
                      bool? isAlertTrue = await Dialogs.confirmDeleteDialog(
                          context,
                          message: "Are you sure ");
                      if (isAlertTrue == true) {
                        isLoading = true;
                        setState(() {});

                        bool isSuccess = await SettingCoachProvider()
                            .coachDeleteAccount(context);
                        isLoading = false;
                        setState(() {});
                        if (isSuccess) {
                          bool isCloseDone = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const DeleteAccountDialog(
                                message: 'Account Deleted',
                              );
                            },
                          );
                          SharedPreferencesManager.clearPref();
                          if (isCloseDone == true) {
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.selectCoachOrStudentOneScreen,
                                (route) => false);
                          }
                        }
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
              "Your classes, clients and meetings\n will be permanently deleted.",
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
