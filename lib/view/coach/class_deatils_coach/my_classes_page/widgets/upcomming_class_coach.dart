import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../models/coach_model/CoachClassDetails_model.dart';
import '../../../../../provider/coach/class_coach_details_provider.dart';
import '../../../../../widgets/dialogs.dart';
import '../../list_of_student.dart';

String formatUtcDate(String originalDateStr) {
  // Parse the original date string
  DateTime originalDate = DateTime.parse(originalDateStr);

  // Format the date as desired
  String formattedDateStr =
      DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(originalDate);

  return formattedDateStr;
}

class MyUpCommingClassesItemWidget extends ConsumerWidget {
  final Schedule scheduleDetails;
  const MyUpCommingClassesItemWidget({Key? key, required this.scheduleDetails})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // // Get the current time

    // Get the current date without time
    DateTime currentDate = DateTime.now();
    DateTime startTimeDate = DateTime.parse(
      formatUtcDate(scheduleDetails.startTime!.toIso8601String()),
    );
    DateTime endTimeDate = DateTime.parse(
        formatUtcDate(scheduleDetails.endTime!.toIso8601String()));

// Check if the current date is between the start and end date of the class
    bool isClassOngoing =
        currentDate.isAfter(startTimeDate) && currentDate.isBefore(endTimeDate);

// Check if the class has already ended
    bool isClassEnded = currentDate.isAfter(endTimeDate);

    // Determine the text to display on the button
    String buttonText = isClassOngoing
        ? "Class Ongoing"
        : isClassEnded
            ? "Class Ended"
            : "Class Not Started";

    return Container(
      decoration: AppDecoration.outlineBlack9001.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 11.v,
            ),
            decoration: AppDecoration.fillGray50.copyWith(
              borderRadius: BorderRadiusStyle.customBorderTL10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                  child: Text(
                    scheduleDetails.typeOfClass,
                    style: CustomTextStyles.titleMediumBlack900,
                  ),
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       scheduleDetails.typeOfClass,
                  //       style: CustomTextStyles.titleMediumBlack900,
                  //     ),
                  //     // SizedBox(height: 1.v),
                  //     // Text(
                  //     //   "10 Students enrolled till now",
                  //     //   style: theme.textTheme.labelLarge,
                  //     // ),
                  //   ],
                  // ),
                ),
                // const Spacer(),
                // CustomImageView(
                //   imagePath: ImageConstant.imgFrame,
                //   height: 16.adaptSize,
                //   width: 16.adaptSize,
                //   margin: EdgeInsets.only(
                //     top: 12.v,
                //     right: 4.h,
                //     bottom: 12.v,
                //   ),
                // ),
                const Spacer(),
                if (!isClassEnded)
                  IconButton(
                    onPressed: () async {
                      bool? isDelete = await Dialogs.confirmDeleteDialog(
                          context,
                          message: "Are you Sure");
                      if (isDelete == true) {
                        ref.read(classDetailsCoachNotifier).deleteScheduleClass(
                            context,
                            sheduleCLassId: scheduleDetails.id);
                      }
                    },
                    icon: const Icon(Icons.delete),
                  )
              ],
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
                        scheduleDetails.day!.toIso8601String()),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    "${Utils.formatTime(scheduleDetails.startTime!)} - ${Utils.formatTime(scheduleDetails.endTime!)}",
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
              mainAxisSize: MainAxisSize.min,
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
                        maxLines: 2,
                        style: theme.textTheme.titleSmall!.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgArrowRight,
                  height: 15.adaptSize,
                  width: 15.adaptSize,
                  margin: EdgeInsets.only(left: 2.h, bottom: 2.v, right: 5.h),
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
          // if (DateTime.parse(
          //         formatUtcDate(scheduleDetails.startTime!.toIso8601String()))
          //     .isBefore(DateTime.now()))
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 330.h,
              height: 40.v,
              child: CustomElevatedButton(
                onPressed: () {
                  if (isClassEnded) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListStudentCoach(
                          classScheduleId: scheduleDetails.id,
                          tokenPerClass: scheduleDetails.classFess,
                          scheduleDetails: scheduleDetails,
                        ),
                      ),
                    ).then((_) {
                      // Refresh data when returning from list of students screen
                      ref.read(classDetailsCoachNotifier).fetchClassDeatilsProvider(context);
                    });
                  } else {}
                },
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                text: buttonText,
              ),
            ),
          ),
          SizedBox(height: 17.v),
        ],
      ),
    );
  }
}
