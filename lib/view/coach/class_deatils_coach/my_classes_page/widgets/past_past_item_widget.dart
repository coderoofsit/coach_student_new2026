import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';

import '../../../../../SharedPref/Shared_pref.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../models/coach_model/CoachClassDetails_model.dart';
import '../../class_details/class_deatils.dart';

class PastClassesItemWidget extends StatelessWidget {
  final Schedule scheduleDetails;

  const PastClassesItemWidget({Key? key, required this.scheduleDetails})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.outlineBlack9001.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassDetailsCoach(
                    classScheduleId: scheduleDetails.id,
                    tokenPerClass: scheduleDetails.classFess,
                    scheduleDetails: scheduleDetails,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 11.v,
              ),
              decoration: AppDecoration.fillGray50.copyWith(
                borderRadius: BorderRadiusStyle.customBorderTL10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: SharedPreferencesManager.getCoachProfile()!
                            .image
                            ?.url ??
                        "https://github.com/coderoofsit/images/assets/141501346/9c7ede81-3218-441b-879c-682446e8b1df",
                    height: 50.adaptSize,
                    width: 50.adaptSize,
                    fit: BoxFit.cover,
                    radius: BorderRadius.circular(
                      25.h,
                    ),
                    alignment: Alignment.center,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scheduleDetails.typeOfClass,
                          style: CustomTextStyles.titleMediumBlack900,
                        ),
                        SizedBox(height: 1.v),
                        if (scheduleDetails.participants.isNotEmpty)
                          Text(
                            "${scheduleDetails.enrolled} Students enrolled till now",
                            style: theme.textTheme.labelLarge,
                          ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  CustomImageView(
                    imagePath: ImageConstant.imgFrame,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(
                      top: 12.v,
                      right: 4.h,
                      bottom: 12.v,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15.v),
          Padding(
            padding: EdgeInsets.only(left: 16.h),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgFrameGray50,
                  height: 20.adaptSize,
                  width: 20.adaptSize,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    Utils.formatNameDate(
                        scheduleDetails.day!.toLocal().toIso8601String()),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    Utils.formatTime(scheduleDetails.startTime!.toLocal()),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.v),
          Padding(
            padding: EdgeInsets.only(left: 17.h, right: 10.h),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgLayer1Primary,
                  height: 17.adaptSize,
                  width: 17.adaptSize,
                  margin: EdgeInsets.only(bottom: 2.v),
                ),
                Flexible(
                  child: GestureDetector(
                    onTap: () {
                      Utils.openMapUrl(context,
                          lat: scheduleDetails.latitude,
                          lng: scheduleDetails.longitude);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 7.h,
                      ),
                      child: Text(
                        scheduleDetails.location,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: theme.textTheme.titleSmall!.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(left: 7.h),
                //   child: Text(
                //     scheduleDetails.location,
                //     style: theme.textTheme.titleSmall!.copyWith(
                //       decoration: TextDecoration.underline,
                //     ),
                //   ),
                // ),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowRight,
                  height: 15.adaptSize,
                  width: 15.adaptSize,
                  margin: EdgeInsets.only(
                    left: 2.h,
                    bottom: 2.v,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.v),
          Padding(
            padding: EdgeInsets.only(left: 17.h),
            child: Row(
              children: [
                CustomImageView(
                  imagePath: ImageConstant.coinImage,
                  height: 17.adaptSize,
                  width: 17.adaptSize,
                  margin: EdgeInsets.only(bottom: 2.v),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    "${scheduleDetails.classFess} Tokens for this class",
                    style: theme.textTheme.titleSmall!,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 17.v),
        ],
      ),
    );
  }
}
