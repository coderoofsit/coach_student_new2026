import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';

// ignore: must_be_immutable
class StudentClasessWiget extends StatelessWidget {
  String coachName;
  String coachType;
  String dateTime;
  String location;
  String token;
  String imageUrl;

   StudentClasessWiget(
      {Key? key,
      required this.coachName,
      required this.coachType,
      required this.dateTime,
      required this.token,
      required this.imageUrl,
      required this.location,})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius : BorderRadius.circular(50),
                  child: CustomImageView(
                    imagePath: imageUrl,
                    height: 40.adaptSize,
                    width: 40.adaptSize,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coachName,
                        style: CustomTextStyles.titleMediumBlack900,
                      ),
                      SizedBox(height: 1.v),
                      Text(
                        "Coaching for $coachType",
                        style: theme.textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CustomImageView(
                  imagePath: ImageConstant.img1,
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
                    dateTime,
                    style: theme.textTheme.titleSmall,
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
                  imagePath: ImageConstant.imgLayer1Primary,
                  height: 17.adaptSize,
                  width: 17.adaptSize,
                  margin: EdgeInsets.only(bottom: 2.v),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    location,
                    style: theme.textTheme.titleSmall!.copyWith(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
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
                    "$token token for the class",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.v,
          ),
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
          //     child: CustomElevatedButton(text: "Join Class")),
        ],
      ),
    );
  }
}
