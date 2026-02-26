import 'package:coach_student/core/utils/size_utils.dart';
import 'package:coach_student/widgets/custom_image_view.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class AppbarTrailingImage extends StatelessWidget {
  AppbarTrailingImage({
    Key? key,
    this.imagePath,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String? imagePath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath,
          height: 25.adaptSize,
          width: 25.adaptSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
