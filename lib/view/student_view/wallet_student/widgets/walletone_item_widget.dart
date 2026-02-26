import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/models/student_model/payments_history_student.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils.dart';

// ignore: must_be_immutable
class WalletoneItemWidget extends StatelessWidget {
  final Payment paymentData;
  const WalletoneItemWidget({Key? key, required this.paymentData})
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
                  "Bought ${paymentData.token} Tokens",
                  style: CustomTextStyles.titleMediumBlack900,
                ),
                SizedBox(height: 2.v),
                Row(
                  children: [
                    Text(
                      Utils.formatTime(paymentData.createdAt!.toLocal()),
                      style: theme.textTheme.labelLarge,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 6.h),
                      child: Text(
                        Utils.formatNameDate(
                            paymentData.createdAt!.toIso8601String()),
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
            child: Text(
              "+ ${paymentData.token}",
              style: CustomTextStyles.titleMediumPrimaryBold,

              // style: CustomTextStyles.titleMediumPrimary_1,
            ),
          ),
        ],
      ),
    );
  }
}
