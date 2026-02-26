import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WalletoneItemWidget extends StatelessWidget {
  const WalletoneItemWidget({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 12.h,
        vertical: 11.v,
      ),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: ImageConstant.coinImage,
            height: 38.adaptSize,
            width: 38.adaptSize,
            margin: EdgeInsets.only(bottom: 2.v),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bought 100 Tokens",
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: 2.v),
                Row(
                  children: [
                    Text(
                      "10:23",
                      style: theme.textTheme.labelLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.h),
                      child: Text(
                        "17th Nov, 2023",
                        style: theme.textTheme.labelLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(
              top: 11.v,
              right: 8.h,
              bottom: 9.v,
            ),
            child: const Text(
              "100",
              // style: CustomTextStyles.titleMediumPrimary_1,
            ),
          ),
        ],
      ),
    );
  }
}
