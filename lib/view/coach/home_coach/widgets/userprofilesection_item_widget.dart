 
import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class UserprofilesectionItemWidget extends StatelessWidget {
  const UserprofilesectionItemWidget({Key? key})
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
            imagePath: ImageConstant.imgEllipse36,
            height: 45.adaptSize,
            width: 45.adaptSize,
            radius: BorderRadius.circular(
              22.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 13.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ashish Mittal",
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: 2.v),
                Text(
                  "Male - 22 years",
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
          const Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgLayer3,
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: EdgeInsets.only(
              top: 12.v,
              bottom: 13.v,
            ),
          ),
          CustomImageView(
            imagePath: "noo",
            height: 16.v,
            width: 9.h,
            margin: EdgeInsets.fromLTRB(23.h, 13.v, 16.h, 14.v),
          ),
        ],
      ),
    );
  }
}
