import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';

// ignore: must_be_immutable
class SelectcoachorStudentoneItemWidget extends StatelessWidget {
  String imageString;
  String title;
  Function() onTap;

  SelectcoachorStudentoneItemWidget(
      {Key? key,
      required this.imageString,
      required this.title,
      required this.onTap})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    // initMediaQueary(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 33.h,
          vertical: 14.v,
        ),
        decoration: AppDecoration.outlineOnErrorContainer.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        width: 150.h,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20.v),
            CustomImageView(
              imagePath: imageString,
              height: 88.v,
              width: 100.h,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            SizedBox(height: 14.v),
            Text(
              title,
              style: CustomTextStyles.titleMediumOnErrorContainerBold,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
