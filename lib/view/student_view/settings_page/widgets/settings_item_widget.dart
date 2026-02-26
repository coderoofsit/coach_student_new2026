import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SettingsItemWidget extends StatelessWidget {
  const SettingsItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58.h,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 3.v),
          padding: EdgeInsets.symmetric(horizontal: 3.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 3.v),
              CustomImageView(
                imagePath: ImageConstant.imgEllipse3550x50,
                height: 50.adaptSize,
                width: 50.adaptSize,
                radius: BorderRadius.circular(
                  25.h,
                ),
              ),
              SizedBox(height: 7.v),
              Padding(
                padding: EdgeInsets.only(left: 3.h),
                child: Text(
                  "Ashish",
                  style: CustomTextStyles.titleSmallPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
