import 'package:coach_student/core/app_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/utils.dart';
import '../../../../models/coach_model/LowStudentBalanceModel.dart';
import '../../../../provider/coach/TranscationHistoryProvider.dart';
import '../../../../widgets/custom_elevated_button.dart';

class LowStudentWidget extends ConsumerWidget {
  final StudentElement studentData;
  const LowStudentWidget({required this.studentData, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calculate total balance (credits + tokens) for enabling Collect button and showing Low balance
    final studentCredits = studentData.student?.credits ?? 0;
    final studentTokens = studentData.student?.token ?? 0;
    final totalBalance = studentCredits + studentTokens;
    final classFees = studentData.classScheduled?.classFess ?? 0;
    final hasLowBalance = classFees > totalBalance;
    final canCollect = totalBalance >= classFees &&
        studentData.classScheduled != null &&
        studentData.student != null;

    return studentData.children != null
        ? Container(
            height: 110
                .v, // Increased height to accommodate extra line for credits/tokens
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 10,
                  offset: Offset(2, 2),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 10,
                  offset: Offset(-2, -2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: CustomImageView(
                      imagePath: studentData.children?.image?.url ??
                          imageUrlDummyProfile,
                      height: 50.adaptSize,
                      width: 50.adaptSize,
                      fit: BoxFit.cover,
                      radius: BorderRadius.circular(
                        25.h,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentData.children?.name ?? "Unknown",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 4.v),
                        Wrap(
                          spacing: 4.h,
                          runSpacing: 2.v,
                          children: [
                            Text(
                              '${studentData.children?.gender} - ${studentData.children?.age} years',
                              style: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.6000000238418579),
                                fontSize: 12,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            // Check if credits + tokens < class fee for "Low balance"
                            if (hasLowBalance)
                              const Text(
                                'Low balance',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4.v),
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.coinImage,
                              height: 15.adaptSize,
                              width: 15.adaptSize,
                            ),
                            SizedBox(width: 4.h),
                            Flexible(
                              child: Text(
                                "Credits: $studentCredits | Tokens: $studentTokens",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.v),
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.coinImage,
                              height: 15.adaptSize,
                              width: 15.adaptSize,
                            ),
                            SizedBox(width: 4.h),
                            Text(
                              "Class Fee: $classFees",
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.h), // Fixed spacing instead of Spacer

                  // const Gap(10),
                  // // Icon(
                  // //   FontAwesomeIcons.forwa,
                  // //   size: 45.adaptSize,
                  // // )
                  if (studentData.classScheduled != null &&
                      studentData.student != null)
                    _buildCollectButton(
                      context: context,
                      ref: ref,
                      // Enable Collect button if credits + tokens >= class fee
                      isDisabled: !canCollect,
                      isChild: true,
                    )
                ],
              ),
            ),
          )
        : Container(
            height: 110
                .v, // Increased height to accommodate extra line for credits/tokens
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 10,
                  offset: Offset(2, 2),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 10,
                  offset: Offset(-2, -2),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: CustomImageView(
                      imagePath: studentData.student?.image?.url ??
                          imageUrlDummyProfile,
                      height: 50.adaptSize,
                      width: 50.adaptSize,
                      fit: BoxFit.cover,
                      radius: BorderRadius.circular(
                        25.h,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          studentData.student?.name ?? "Unknown",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                            height: 0,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 4.v),
                        Wrap(
                          spacing: 4.h,
                          runSpacing: 2.v,
                          children: [
                            Text(
                              '${studentData.student?.gender} - ${studentData.student?.age} years',
                              style: TextStyle(
                                color: Colors.black
                                    .withOpacity(0.6000000238418579),
                                fontSize: 12,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                            // Check if credits + tokens < class fee for "Low balance"
                            if (hasLowBalance)
                              const Text(
                                'Low balance',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4.v),
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.coinImage,
                              height: 15.adaptSize,
                              width: 15.adaptSize,
                            ),
                            SizedBox(width: 4.h),
                            Flexible(
                              child: Text(
                                "Credits: $studentCredits | Tokens: $studentTokens",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Nunito Sans',
                                  fontWeight: FontWeight.w700,
                                  height: 0,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.v),
                        Row(
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.coinImage,
                              height: 15.adaptSize,
                              width: 15.adaptSize,
                            ),
                            SizedBox(width: 4.h),
                            Text(
                              "Class Fee: $classFees",
                              style: const TextStyle(
                                fontSize: 12,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.h), // Fixed spacing instead of Spacer

                  // const Gap(10),
                  // // Icon(
                  // //   FontAwesomeIcons.forwa,
                  // //   size: 45.adaptSize,
                  // // )
                  if (studentData.classScheduled != null &&
                      studentData.student != null)
                    _buildCollectButton(
                      context: context,
                      ref: ref,
                      // Enable Collect button if credits + tokens >= class fee
                      isDisabled: !canCollect,
                      isChild: false,
                    )
                ],
              ),
            ),
          );
  }

  Widget _buildCollectButton({
    required BuildContext context,
    required WidgetRef ref,
    required bool isDisabled,
    required bool isChild,
  }) {
    return GestureDetector(
      onTap: isDisabled
          ? null
          : () {
              if (isChild) {
                _showClassCollectDialogForChildren(context, ref);
              } else {
                _showClassCollectDialog(context, ref);
              }
            },
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 6.v),
          decoration: ShapeDecoration(
            color: isDisabled
                ? Colors.grey.withOpacity(0.2)
                : const Color(0xFF3D6DF5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: BorderSide(
                width: 1,
                color: isDisabled
                    ? Colors.grey.withOpacity(0.3)
                    : const Color(0xFF3D6DF5),
              ),
            ),
          ),
          child: Text(
            "Collect",
            style: TextStyle(
              fontSize: 14.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
              color: isDisabled ? Colors.grey : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showClassCollectDialog(BuildContext context, WidgetRef ref) {
    if (studentData.classScheduled == null) {
      Utils.toast(message: "No class scheduled found");
      return;
    }

    if (studentData.student == null) {
      Utils.toast(message: "Student data not found");
      return;
    }

    final classFees = studentData.classScheduled?.classFess ?? 0;
    final studentName = studentData.student?.name ?? "Student";
    final studentId = studentData.student?.id ?? "";
    final classScheduleId = studentData.classScheduled?.id ?? "";
    final pendingBalanceId = studentData.id;
    final typeOfClass = studentData.classScheduled?.typeOfClass ?? "";
    final classDescription = studentData.classScheduled?.classDescription ?? "";

    // Store parent context before showing dialog
    final parentContext = context;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Collect Fee",
                  style: CustomTextStyles.titleLargeBlack900,
                ),
                SizedBox(height: 16.v),
                Text(
                  "Student: $studentName",
                  style: CustomTextStyles.titleMediumBlack900,
                ),
                if (typeOfClass.isNotEmpty) ...[
                  SizedBox(height: 8.v),
                  Text(
                    "Class Type: $typeOfClass",
                    style: CustomTextStyles.titleMediumBlack900,
                  ),
                ],
                if (classDescription.isNotEmpty) ...[
                  SizedBox(height: 8.v),
                  Text(
                    "Description: $classDescription",
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
                SizedBox(height: 8.v),
                Row(
                  children: [
                    Text(
                      "Class Fee: ",
                      style: theme.textTheme.bodyLarge,
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.coinImage,
                      height: 16.adaptSize,
                      width: 16.adaptSize,
                    ),
                    SizedBox(width: 4.h),
                    Text(
                      "$classFees",
                      style: CustomTextStyles.titleMediumPrimaryBold,
                    ),
                  ],
                ),
                SizedBox(height: 24.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.fSize,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.h),
                    CustomElevatedButton(
                      width: 100.h,
                      text: "Collect",
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close dialog first
                        // Use parent context for async operations
                        ref
                            .read(transcationHistoryProvider)
                            .collectFeeFromOwedStudent(
                              parentContext,
                              studentId: studentId,
                              classScheduleId: classScheduleId,
                              classFees: classFees,
                              pendingBalanceId: pendingBalanceId,
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showClassCollectDialogForChildren(BuildContext context, WidgetRef ref) {
    if (studentData.classScheduled == null) {
      Utils.toast(message: "No class scheduled found");
      return;
    }

    if (studentData.student == null) {
      Utils.toast(message: "Student data not found");
      return;
    }

    if (studentData.children == null) {
      Utils.toast(message: "Children data not found");
      return;
    }

    final classFees = studentData.classScheduled?.classFess ?? 0;
    final childName = studentData.children?.name ?? "Child";
    final studentId = studentData.student?.id ?? "";
    final classScheduleId = studentData.classScheduled?.id ?? "";
    final pendingBalanceId = studentData.id;
    final typeOfClass = studentData.classScheduled?.typeOfClass ?? "";
    final classDescription = studentData.classScheduled?.classDescription ?? "";

    // Store parent context before showing dialog
    final parentContext = context;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Collect Fee",
                  style: CustomTextStyles.titleLargeBlack900,
                ),
                SizedBox(height: 16.v),
                Text(
                  "Child: $childName",
                  style: CustomTextStyles.titleMediumBlack900,
                ),
                if (typeOfClass.isNotEmpty) ...[
                  SizedBox(height: 8.v),
                  Text(
                    "Class Type: $typeOfClass",
                    style: CustomTextStyles.titleMediumBlack900,
                  ),
                ],
                if (classDescription.isNotEmpty) ...[
                  SizedBox(height: 8.v),
                  Text(
                    "Description: $classDescription",
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
                SizedBox(height: 8.v),
                Row(
                  children: [
                    Text(
                      "Class Fee: ",
                      style: theme.textTheme.bodyLarge,
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.coinImage,
                      height: 16.adaptSize,
                      width: 16.adaptSize,
                    ),
                    SizedBox(width: 4.h),
                    Text(
                      "$classFees",
                      style: CustomTextStyles.titleMediumPrimaryBold,
                    ),
                  ],
                ),
                SizedBox(height: 24.v),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.fSize,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.h),
                    CustomElevatedButton(
                      width: 100.h,
                      text: "Collect",
                      onPressed: () {
                        Navigator.of(dialogContext).pop(); // Close dialog first
                        // Use parent context for async operations
                        ref
                            .read(transcationHistoryProvider)
                            .collectFeeFromOwedStudent(
                              parentContext,
                              studentId: studentId,
                              classScheduleId: classScheduleId,
                              classFees: classFees,
                              pendingBalanceId: pendingBalanceId,
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
