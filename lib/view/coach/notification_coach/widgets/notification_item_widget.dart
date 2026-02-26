import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../models/coach_model/NotificationCoachModel.dart'
    as NotificationModel;

// ignore: must_be_immutable
class NotificationItemWidget extends StatelessWidget {
  final NotificationModel.Notification notificationData;
  const NotificationItemWidget({Key? key, required this.notificationData})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: notificationData.notificationWith?.image?.url ??
                imageUrlDummyProfile,
            height: 45.adaptSize,
            width: 45.adaptSize,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(
              22.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 13.h,
              top: 2.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: mediaQueryData.size.width * 0.7,
                        child: Text(
                          notificationData.body,
                          style: CustomTextStyles.titleSmallBlack900Bold,

                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.v),
                Row(
                  children: [
                    // RichText(
                    //   text: TextSpan(
                    //     children: [
                    //       TextSpan(
                    //         text: "30",
                    //         style:
                    //             CustomTextStyles.labelLargeSecondaryContainer,
                    //       ),
                    //       const TextSpan(
                    //         text: " ",
                    //       ),
                    //     ],
                    //   ),
                    //   textAlign: TextAlign.left,
                    // ),
                    // CustomImageView(
                    //   imagePath: ImageConstant.coinImage,
                    //   height: 13.adaptSize,
                    //   width: 13.adaptSize,
                    //   margin: EdgeInsets.only(left: 1.h),
                    // ),
                    Text(
                      DateFormat('d MMM').format(notificationData.updatedAt!),
                      style: theme.textTheme.labelLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 11.h),
                      child: Text(
                        Utils.formatTime(notificationData.updatedAt!.toLocal()),
                        // DateFormat('HH:mm').format(notificationData.updatedAt!),
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
