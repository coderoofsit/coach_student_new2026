import 'package:coach_student/models/coach_model/CoachClassDetails_model.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../../models/CoachChatModel.dart';
import '../../../provider/coach/student_profile_coach_provider.dart';
import '../coach_chat/chats_page/chats_page.dart';

class StudentProfileByIdClient extends ConsumerStatefulWidget {
  final String studentUserIdClient;
  final Schedule scheduleDetails;
  const StudentProfileByIdClient({
    Key? key,
    required this.studentUserIdClient,
    required this.scheduleDetails,
  }) : super(
          key: key,
        );

  @override
  ConsumerState<StudentProfileByIdClient> createState() =>
      _StudentProfileByIdClientConsumerState();
}

class _StudentProfileByIdClientConsumerState
    extends ConsumerState<StudentProfileByIdClient> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(studentProfileByIdCoachProvider)
          .fetchStdeuntById(context, studentId: widget.studentUserIdClient);
    });
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final studentData = ref.watch(studentProfileByIdCoachProvider
        .select((value) => value.studentProfileIdClinetCoachModel));

    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: "Student Profile",
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.star_outline_rounded,
        //       size: 25.adaptSize,
        //     ),
        //   )
        // ],
      ),
      body: ref.watch(studentProfileByIdCoachProvider
              .select((value) => value.isLoadingStudent))
          ? Utils.progressIndicator
          : SizedBox(
              width: mediaQueryData.size.width,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 24.v),
                child: Column(
                  children: [
                    CustomImageView(
                      imagePath: studentData.image?.url ?? imageUrlDummyProfile,
                      height: 101.adaptSize,
                      width: 101.adaptSize,
                      fit: BoxFit.cover,
                      radius: BorderRadius.circular(
                        50.h,
                      ),
                    ),
                    SizedBox(height: 15.v),
                    Text(
                      studentData.name ?? "",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.800000011920929),
                        fontSize: 18.fSize,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    Text(
                      "${studentData.gender} - ${studentData.age} years",
                      style: CustomTextStyles.titleSmallBlack900_1,
                    ),
                    SizedBox(height: 10.v),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomImageView(
                          imagePath: ImageConstant.coinImage,
                          color: widget.scheduleDetails.classFess >=
                                  (studentData.token ?? 0)
                              ? const Color(0xffEB5757)
                              : const Color(0xffF1BB41),
                          height: 20.adaptSize,
                          width: 20.adaptSize,
                          // margin: EdgeInsets.only(
                          //   top: 2.v,
                          //   bottom: 12.v,
                          // ),
                        ),
                        SizedBox(
                          width: 5.h,
                        ),
                        Text(
                          "${studentData.token} Token",
                          style: CustomTextStyles.titleSmallBlack900_1,
                        ),
                      ],
                    ),
                    SizedBox(height: 23.v),
                    // _buildCoachProfile(context),
                    Container(
                      width: 350.h,
                      height: 66.v,
                      padding: EdgeInsets.symmetric(
                        horizontal: 19.h,
                        // vertical: 10.v,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF5F8FE),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFDCE5FD)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: ListTile(
                          leading: CustomImageView(
                            imagePath: ImageConstant.calender,
                            height: 31.adaptSize,
                            width: 31.adaptSize,
                            // margin: EdgeInsets.symmetric(vertical: 4.v),
                          ),
                          title: Text(
                            Utils.formatNameDate(
                                widget.scheduleDetails.day!.toIso8601String()),
                            style: TextStyle(
                              // color: const Color(0xFF3D6DF5),
                              fontSize: 16.fSize,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          subtitle: Text(
                            'Time: ${Utils.formatTime(widget.scheduleDetails.startTime!)} - ${Utils.formatTime(widget.scheduleDetails.endTime!)}',
                            style: TextStyle(
                              // color: const Color(0xCC3D6DF5),
                              fontSize: 12.fSize,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          // trailing: CustomImageView(
                          //   imagePath: ImageConstant.clearIcon,
                          //   height: 25.adaptSize,
                          //   width: 25.adaptSize,
                          //   // margin: const EdgeInsets.only(left: 10),
                          // ),
                        ),
                      ),
                    ),
                    SizedBox(height: 23.v),
                    // const SlotsAvaliable(),
                    // SizedBox(height: 20.v),
                    Container(
                      width: 350.h,
                      height: 75.v,
                      padding: EdgeInsets.symmetric(
                        horizontal: 19.h,
                        // vertical: 10.v,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF5F8FE),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFDCE5FD)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: ListTile(
                          leading: CustomImageView(
                            imagePath: ImageConstant.coinImage,
                            color: widget.scheduleDetails.classFess >=
                                    (studentData.token ?? 0)
                                ? const Color(0xffEB5757)
                                : const Color(0xffF1BB41),
                            height: 31.adaptSize,
                            width: 31.adaptSize,
                            margin: EdgeInsets.only(
                              top: 2.v,
                              bottom: 12.v,
                            ),
                          ),
                          title: Text(
                            '${widget.scheduleDetails.classFess} Tokens for this class',
                            style: TextStyle(
                              color:
                                  Colors.black.withOpacity(0.800000011920929),
                              fontSize: 16.fSize,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          subtitle: Text(
                            widget.scheduleDetails.classFess >=
                                    (studentData.token ?? 0)
                                ? 'Low Balance - Less tokens'
                                : "",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 12.fSize,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                          // trailing: CustomImageView(
                          //   imagePath: ImageConstant.editIcon,
                          //   height: 25.adaptSize,
                          //   width: 25.adaptSize,
                          //   // margin: const EdgeInsets.only(left: 10),
                          // ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.v),
                    Container(
                      width: 350.h,
                      height: 80.v,
                      padding: EdgeInsets.symmetric(
                        horizontal: 19.h,
                        // vertical: 10.v,
                      ),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFF5F8FE),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: Color(0xFFDCE5FD)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: ListTile(
                          // isThreeLine: true,
                          leading: CustomImageView(
                            imagePath: ImageConstant.mapIcon,
                            height: 31.adaptSize,
                            width: 31.adaptSize,
                            // margin: EdgeInsets.symmetric(vertical: 4.v),
                          ),
                          title: Text(
                            widget.scheduleDetails.location,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color:
                                  Colors.black.withOpacity(0.800000011920929),
                              fontSize: 16.fSize,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w700,
                              height: 0,
                            ),
                          ),
                          subtitle: GestureDetector(
                            onTap: () {
                              Utils.openMapUrl(context,
                                  lat: widget.scheduleDetails.latitude,
                                  lng: widget.scheduleDetails.longitude);
                            },
                            child: Text(
                              'Click here to view the Map.',
                              style: TextStyle(
                                color: const Color(0xFF3D6DF5),
                                fontSize: 12.fSize,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                                decorationColor: const Color(0xFF3D6DF5),
                                height: 0,
                              ),
                            ),
                          ),
                          // trailing: CustomImageView(
                          //   imagePath: ImageConstant.editIcon,
                          //   height: 25.adaptSize,
                          //   width: 25.adaptSize,
                          //   // margin: const EdgeInsets.only(left: 10),
                          // ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.v),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: SizedBox(
        height: 50.v,
        child: CustomElevatedButton(
          text: "Message",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatsPageCoach(
                  user: CoachChatModel(
                    imageUrl: studentData.image?.url ?? imageUrlDummyProfile,
                    name: studentData.name ?? "",
                    userId: studentData.id ?? "",
                  ),
                ),
              ),
            );
          },
        ),
      ),
      // floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Section Widget
  Widget _buildScheduleCoach(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 19.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomElevatedButton(
              text: "Collect payment",
              leftIcon: Container(
                margin: EdgeInsets.only(right: 10.h),
                child: CustomImageView(
                  imagePath: ImageConstant.coinImage,
                  height: 19.adaptSize,
                  width: 19.adaptSize,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.h),
            child: CustomIconButton(
              height: 50.adaptSize,
              width: 50.adaptSize,
              padding: EdgeInsets.all(15.h),
              child: CustomImageView(
                imagePath: ImageConstant.imgCapa1Primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
