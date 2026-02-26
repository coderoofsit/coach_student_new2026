import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/coach_model/CoachClassDetails_model.dart';
import 'package:coach_student/models/coach_model/StudentListClientModel.dart';
import 'package:coach_student/provider/coach/class_coach_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../../widgets/custom_app_bar_student.dart';

import '../../client_profile_screen/StudentProfileById.dart';

class ListStudentCoachPast extends ConsumerStatefulWidget {
  final String classScheduleId;
  final num tokenPerClass;
  final Schedule scheduleDetails;
  const ListStudentCoachPast({
    required this.classScheduleId,
    required this.tokenPerClass,
    super.key,
    required this.scheduleDetails,
  });

  @override
  ConsumerState<ListStudentCoachPast> createState() =>
      _ListStudentCoachPastState();
}

class _ListStudentCoachPastState extends ConsumerState<ListStudentCoachPast> {
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
      classDetailsCoachNotifier.select((value) => value.classAttendedStudentList),
    );
    final bool isLoading = ref.watch(
      classDetailsCoachNotifier.select((value) => value.isLoadingStudentList),
    );
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: "Participants",
      ),
      body: isLoading
          ? Utils.progressIndicator
          : studentListClientModel.clients.isEmpty
              ? Center(
                  child: Text(
                    "No participants available",
                    style: CustomTextStyles.titleLargeBold,
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.v),
                  child: ListView.separated(
                    separatorBuilder: (_, index) => SizedBox(
                      height: 10.v,
                    ),
                    itemCount: studentListClientModel.clients.length,
                    itemBuilder: (context, index) {
                      final student = studentListClientModel.clients[index];

                      return Container(
                width: 350.h,
                height: 75.v,
                alignment: Alignment.center,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentProfileByIdClient(
                                  studentUserIdClient: student.id,
                                  scheduleDetails: widget.scheduleDetails),
                            ),
                          );
                        },
                        child: CustomImageView(
                          imagePath: student.image?.url ?? imageUrlDummyProfile,
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
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    student.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Nunito Sans',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.h,
                                ),
                                CustomImageView(
                                  imagePath: ImageConstant.coinImage,
                                  height: 15.adaptSize,
                                  width: 15.adaptSize,
                                ),
                                SizedBox(
                                  width: 4.h,
                                ),
                                Text(
                                  "${student.token}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w700,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${student.gender} - ${student.age} years',
                                  style: TextStyle(
                                    color: Colors.black
                                        .withOpacity(0.6000000238418579),
                                    fontSize: 12,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                if (widget.tokenPerClass >= student.token)
                                  const Row(
                                    children: [
                                      Text(" | "),
                                      Text(
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
                              ],
                            )
                          ],
                        ),
                      ),
                      const Gap(10),
                      // Icon(
                      //   FontAwesomeIcons.forwa,
                      //   size: 45.adaptSize,
                      // )
                      // CustomImageView(
                      //   imagePath: ImageConstant.arrowForward,
                      // )
                    ],
                  ),
                ),
              );
            },
          )),
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
            height: 250.0.v,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                // top: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16.0),

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
                        imagePath: "${ImageConstant.imagePath}/golden_icon.png",
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),

                  // Text: Success Subtitle
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.fSize,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ),
        );
      },
    );
    return showSuccessDialogBoolValue;
  }
}
