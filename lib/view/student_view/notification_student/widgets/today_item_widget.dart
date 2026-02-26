import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/NotificationModel.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TodayItemWidget extends StatelessWidget {
  NotificationClassModel notification;
   TodayItemWidget({required this.notification ,Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CustomImageView(
              imagePath: "${notification.to?.image?.url}",
              height: 45.adaptSize,
              width: 45.adaptSize,
              fit: BoxFit.cover,
              radius: BorderRadius.circular(
                22.h,
              ),
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
                SizedBox(
                  width : 200,
                  child: Text(
                    notification.body,
                    style: CustomTextStyles.titleSmallBlack900Bold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 3.v),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: notification.to?.token.toString() ?? "",
                            style:
                                CustomTextStyles.labelLargeSecondaryContainer,
                          ),
                          const TextSpan(
                            text: "     ",
                          ),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.coinImage,
                      height: 13.adaptSize,
                      width: 13.adaptSize,
                      margin: EdgeInsets.only(left: 1.h),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 11.h),
                      child: Text(
                        Utils.formatNameDate(notification.createdAt.toString()),
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 11.h),
                      child: Text(
                        Utils.formatTime(notification.createdAt as DateTime),
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
