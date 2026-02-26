import 'dart:developer';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/coach_model/CoachClassDetails_model.dart';
import 'package:coach_student/models/coach_model/StudentListClientModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../../../provider/coach/class_coach_details_provider.dart';
import '../../../widgets/custom_app_bar_student.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../client_profile_screen/StudentProfileById.dart';

class ListStudentCoach extends ConsumerStatefulWidget {
  final String classScheduleId;
  final num tokenPerClass;
  final Schedule scheduleDetails;
  const ListStudentCoach(
      {required this.classScheduleId,
      required this.tokenPerClass,
      super.key,
      required this.scheduleDetails});

  @override
  ConsumerState<ListStudentCoach> createState() =>
      _ListStudentCoachConsumerState();
}

class _ListStudentCoachConsumerState extends ConsumerState<ListStudentCoach> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(classDetailsCoachNotifier).fetchScheduleParticipants(
            context,
            scheduleId: widget.classScheduleId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    initMediaQueary(context);
    final StudentListClientModel studentListClientModel = ref.watch(
      classDetailsCoachNotifier
          .select((value) => value.classAttendedStudentList),
    );
    final bool areAllSelected = ref.watch(
      classDetailsCoachNotifier.select((value) => value.areAllStudentsSelected),
    );
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: "Attendance",
      ),
      body: ref.watch(classDetailsCoachNotifier
              .select((value) => value.isLoadingStudentList))
          ? Utils.progressIndicator
          : studentListClientModel.clients.isEmpty
              ? Center(
                  child: Text(
                    "No participants available",
                    style: CustomTextStyles.titleLargeBold,
                  ),
                )
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.v),
                  child: Column(
                    children: [
                      // Select All checkbox
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10.v),
                        child: Row(
                          children: [
                            Checkbox(
                              value: areAllSelected,
                              side: const BorderSide(),
                              fillColor: WidgetStateProperty.all(areAllSelected
                                  ? theme.primaryColor
                                  : Colors.white),
                              checkColor: Colors.white,
                              onChanged: (val) {
                                if (val != null) {
                                  ref
                                      .read(classDetailsCoachNotifier)
                                      .selectAllStudents(selectAll: val);
                                }
                              },
                            ),
                            const Gap(8),
                            const Text(
                              "Select All",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (_, index) => SizedBox(
                            height: 10.v,
                          ),
                          itemCount: studentListClientModel.clients.length,
                          itemBuilder: (context, index) {
                            studentListClientModel.clients
                                .sort((a, b) => a.token.compareTo(b.token));
                            final Client student =
                                studentListClientModel.clients[index];

                            return Container(
                              height: 95.v,
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
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.h, vertical: 5.v),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                StudentProfileByIdClient(
                                                    studentUserIdClient:
                                                        student.id,
                                                    scheduleDetails:
                                                        widget.scheduleDetails),
                                          ),
                                        );
                                      },
                                      child: CustomImageView(
                                        imagePath: student.image?.url ??
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            student.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Nunito Sans',
                                              fontWeight: FontWeight.w700,
                                              height: 0,
                                            ),
                                          ),
                                          SizedBox(height: 4.v),
                                          Row(
                                            children: [
                                              Text(
                                                '${student.gender} - ${student.age} years',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(
                                                          0.6000000238418579),
                                                  fontSize: 12,
                                                  fontFamily: 'Nunito Sans',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              if (widget.tokenPerClass >
                                                  (student.credits +
                                                      student.token))
                                                const Row(
                                                  children: [
                                                    Text(" | "),
                                                    Text(
                                                      'Low balance',
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Nunito Sans',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 4.v),
                                          Row(
                                            children: [
                                              CustomImageView(
                                                imagePath:
                                                    ImageConstant.coinImage,
                                                height: 15.adaptSize,
                                                width: 15.adaptSize,
                                              ),
                                              SizedBox(width: 4.h),
                                              Text(
                                                "Credits: ${student.credits} | Tokens: ${student.token}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontFamily: 'Nunito Sans',
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 35.h,
                                      height: 30.v,
                                      child: Checkbox(
                                        value: student.isSelected,
                                        side: const BorderSide(),
                                        fillColor: WidgetStateProperty.all(
                                            student.isSelected
                                                ? theme.primaryColor
                                                : Colors.white),
                                        checkColor: Colors.white,
                                        onChanged: (val) {
                                          ref
                                              .read(classDetailsCoachNotifier)
                                              .updateIsSelected(
                                                  value: val, index: index);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8.h),
                                    CustomImageView(
                                      imagePath: ImageConstant.arrowForward,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: SafeArea(
        child: CustomElevatedButton(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          text: "Class Ended",
          onPressed: () {
            List<Client> participantsListAdd = studentListClientModel.clients
                .where((element) => element.isSelected)
                .toList();
            log(
              "participants $participantsListAdd",
            );
            if (participantsListAdd.isNotEmpty) {
              List<String> participants =
                  participantsListAdd.map((e) => e.id).toList();

              // Calculate actual tokens coach will receive (after credits are deducted first)
              num totalTokensCoachWillReceive = 0;
              num totalCreditsToBeUsed = 0;
              num totalTokensToBeUsed = 0;

              for (var participant in participantsListAdd) {
                final studentCredits = participant.credits;
                final studentTokens = participant.token;
                final providerClassFee =
                    ref.read(classDetailsCoachNotifier).currentClassFee;
                final classFee = providerClassFee > 0
                    ? providerClassFee
                    : widget.tokenPerClass;

                // Calculate how much credits and tokens this student will use
                num usedCredits = 0;
                num usedTokens = 0;

                if (studentCredits > 0) {
                  // Credits are deducted first
                  usedCredits =
                      studentCredits < classFee ? studentCredits : classFee;
                }

                // Remaining fee after credits
                num remainingFee = classFee - usedCredits;

                if (remainingFee > 0 && studentTokens > 0) {
                  // Tokens are used for remaining fee
                  usedTokens = studentTokens < remainingFee
                      ? studentTokens
                      : remainingFee;
                }

                // Coach only receives the token portion
                totalTokensCoachWillReceive += usedTokens;
                totalCreditsToBeUsed += usedCredits;
                totalTokensToBeUsed += usedTokens;
              }

              // Build subtitle message with breakdown
              String subtitle;
              if (totalCreditsToBeUsed > 0 && totalTokensToBeUsed > 0) {
                subtitle =
                    'Students will pay using ${totalCreditsToBeUsed.toInt()} credits and ${totalTokensToBeUsed.toInt()} tokens.\nYou will receive ${totalTokensCoachWillReceive.toInt()} tokens from ${participantsListAdd.length} students.';
              } else if (totalCreditsToBeUsed > 0) {
                subtitle =
                    'Students will pay using ${totalCreditsToBeUsed.toInt()} credits (offline payment).\nYou will receive 0 tokens from ${participantsListAdd.length} students.';
              } else {
                subtitle =
                    'You will receive ${totalTokensCoachWillReceive.toInt()} tokens from ${participantsListAdd.length} students.';
              }

              paymentAlertDialog(
                context,
                title: totalTokensCoachWillReceive.toInt().toString(),
                subtitle: subtitle,
                participants: participants,
              );
            } else {
              Utils.showSnackbarErrror(context, "Please add student");
            }
          },
          // leftIcon: CustomImageView(
          //   imagePath: ImageConstant1.coinImage,
          //   width: 20.h,
          //   margin: EdgeInsets.only(right: 10.h),
          // ),
        ),
      ),
    );
  }

  Future<bool?> paymentAlertDialog(BuildContext context,
      {required String title,
      required String subtitle,
      required List<String> participants}) async {
    mediaQueryData = MediaQuery.of(context);
    bool? showSuccessDialogBoolValue = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            constraints: BoxConstraints(
              minHeight: 250.0.v,
              maxHeight: 400.0.v,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: 20.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text: Success Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.fSize,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Gap(5),
                        CustomImageView(
                          imagePath:
                              "${ImageConstant.imagePath}/golden_icon.png",
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),

                    // Text: Success Subtitle (can be multi-line now)
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.fSize,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 20.0),

                    // Done Button
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close dialog first
                        ref.read(classDetailsCoachNotifier).addParticipants(
                            context,
                            participants: participants,
                            classSheduleId: widget.classScheduleId);
                      },
                      text: 'Collect',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    return showSuccessDialogBoolValue;
  }
}
