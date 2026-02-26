import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/provider/coach/class_coach_details_provider.dart';
import 'package:coach_student/provider/coach/coach_profile_provider.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../models/coach_model/CoachClassDetails_model.dart';
import '../../../provider/coach/coach_notification_provider.dart';
import '../../../widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';

import '../CoachClassSchedule/new_class.dart';
import '../class_deatils_coach/class_schdule_tab.dart';
import '../class_deatils_coach/list_of_student.dart';
import '../qr_screen/qr_screen_coach.dart';

class HomeCoachScreens extends ConsumerStatefulWidget {
  const HomeCoachScreens({Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<HomeCoachScreens> createState() =>
      _HomeCoachScreensConsumerState();
}

class _HomeCoachScreensConsumerState extends ConsumerState<HomeCoachScreens> {
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(classDetailsCoachNotifier).upcommingListFetch(
            context,
          );
      ref.read(notificationCoachProvider).getNotifcationCount(context);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coachData = ref.watch(
      coachProfileProvider.select(
        (value) => value.coachProfileDetailsModel,
      ),
    );
    final List<Schedule> upcommingListData = ref.watch(
        classDetailsCoachNotifier.select((value) => value.upcommingList));

    initMediaQueary(context);
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(classDetailsCoachNotifier)
                .upcommingListFetch(context);
            await ref
                .read(notificationCoachProvider)
                .getNotifcationCount(context);
          },
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 5.v),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 5.v),
                    // fix schedule class
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  const NewClassScheduleaCoach(),
                            ),
                          );
                        },
                        child: const FixScheduleSection()),

                    SizedBox(height: 14.v),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const ClassscheduleCoachView()));
                        },
                        child: _buildScheduleSection(
                          context,
                          upcommingClassNum: upcommingListData.length,
                        )),

                    if (ref.watch(classDetailsCoachNotifier
                        .select((value) => value.isUpcommingLoading)))
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.v),
                          child: Utils.progressIndicator)
                    else if (upcommingListData.isEmpty)
                      const SizedBox.shrink()
                    else
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 12.v),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 19.h),
                                child: Text(
                                  "Upcoming Class",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.fSize,
                                    fontFamily: 'Nunito Sans',
                                    fontWeight: FontWeight.w700,
                                    height: 0.07,
                                    letterSpacing: -0.44,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Padding(
                                padding: EdgeInsets.only(right: 19.h),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ClassscheduleCoachView(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "View All",
                                    style: TextStyle(
                                      // color: Colors.black,
                                      fontSize: 15.fSize,
                                      fontFamily: 'Nunito Sans',
                                      fontWeight: FontWeight.w700,
                                      height: 0.07,
                                      letterSpacing: -0.44,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.v),
                          SizedBox(
                            width: 390.h,
                            height: 282.v,
                            child: PageView.builder(
                              itemCount: upcommingListData.length,
                              // shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final Schedule upcommingData =
                                    upcommingListData.reversed.toList()[index];

                                return _buildUpcomingClassInfoCard(context,
                                    upcommingData: upcommingData,
                                    className: coachData.name ?? "",
                                    coachUrl: coachData.image?.url ??
                                        imageUrlDummyProfile);
                              },
                            ),
                          ),
                        ],
                      ),

                    // _buildClassesSection(context),
                    SizedBox(height: 37.v),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.h),
                        child: Text(
                          "My passcode",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.fSize,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                            height: 0.07,
                            letterSpacing: -0.44,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.v),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const QrScreenCoach(),
                          ),
                        );
                      },
                      child: Container(
                        width: 350.h,
                        height: 75.v,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 12,
                              color: Color.fromRGBO(0, 0, 0, 0.16),
                            )
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: ListTile(
                            leading: CustomImageView(
                              imagePath: ImageConstant.qrScanIcan,
                            ),
                            title: Text(
                              "${SharedPreferencesManager.getCoachProfile()?.passcode! ?? 0}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: const Text(
                              "Share this number or show QR code",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 37.v),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildScheduleSection(BuildContext context,
      {required int upcommingClassNum}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.symmetric(
        horizontal: 19.h,
        vertical: 9.v,
      ),
      decoration: AppDecoration.outlinePrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgGroup2296,
            height: 34.adaptSize,
            width: 34.adaptSize,
            margin: EdgeInsets.only(
              top: 4.v,
              bottom: 3.v,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 18.h,
              top: 1.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (upcommingClassNum != 0)
                  Text(
                    "$upcommingClassNum Classes schedule",
                    style: CustomTextStyles.titleMediumBlack900,
                  )
                else
                  Text(
                    "No upcoming classes",
                    style: CustomTextStyles.titleMediumBlack900,
                  ),
                SizedBox(height: 1.v),
                Text(
                  "Check the class details",
                  style: CustomTextStyles.labelLarge_1,
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.v),
            child: CustomIconButton(
              height: 25.adaptSize,
              width: 25.adaptSize,
              padding: EdgeInsets.all(1.h),
              child: CustomImageView(
                imagePath: ImageConstant.forwardIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildClassesSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.symmetric(
        horizontal: 19.h,
        vertical: 10.v,
      ),
      decoration: AppDecoration.outlinePrimary.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath: ImageConstant1.imgGroup2296,
                height: 31.adaptSize,
                width: 31.adaptSize,
                margin: EdgeInsets.symmetric(vertical: 4.v),
              ),
              Padding(
                padding: EdgeInsets.only(left: 21.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "3 Upcoming Classes",
                      style: CustomTextStyles.titleMediumBlack900,
                    ),
                    Text(
                      "Check the class details",
                      style: CustomTextStyles.labelLarge_1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 7.v),
            child: CustomIconButton(
              height: 25.adaptSize,
              width: 25.adaptSize,
              padding: EdgeInsets.all(1.h),
              child: CustomImageView(
                imagePath: ImageConstant.forwardIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// _buildUpcommingClassInfoCard
  Widget _buildUpcomingClassInfoCard(
    BuildContext context, {
    required Schedule upcommingData,
    required String className,
    required String coachUrl,
  }) {
    // Get the current date without time
    DateTime currentDate = DateTime.now();
    DateTime startTimeDate = DateTime.parse(
      formatUtcDate(upcommingData.startTime!.toIso8601String()),
    );
    DateTime endTimeDate =
        DateTime.parse(formatUtcDate(upcommingData.endTime!.toIso8601String()));

    bool isClassOngoing =
        currentDate.isAfter(startTimeDate) && currentDate.isBefore(endTimeDate);

    bool isClassEnded = currentDate.isAfter(endTimeDate);

    // Determine the text to display on the button
    String textButtonText = isClassOngoing
        ? "Class Ongoing"
        : isClassEnded
            ? "Class Ended"
            : "Class Not Started";
    // logger.i(textButtonText);
    String className = upcommingData.typeOfClass;
    String time =
        '${Utils.formatNameDate(upcommingData.day!.toIso8601String())}, ${Utils.formatTime(upcommingData.startTime!)}-${Utils.formatTime(upcommingData.endTime!)}';
    // String locationName = upcommingData.location;
    String tokenQ = '${upcommingData.classFess} Tokens for this class';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h, vertical: 9.v),
      // padding: const EdgeInsets.symmetric(
      //     // horizontal: 19.h,
      //     // vertical: 9.v,
      //     ),
      decoration: AppDecoration.outlineBlack9002.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 11.v,
            ),
            decoration: AppDecoration.fillGray50.copyWith(
              borderRadius: BorderRadiusStyle.customBorderTL10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: coachUrl,
                  height: 50.adaptSize,
                  width: 50.adaptSize,
                  fit: BoxFit.cover,
                  radius: BorderRadius.circular(
                    25.h,
                  ),
                  alignment: Alignment.center,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Text(
                    className,
                    style: CustomTextStyles.titleMediumBlack900,
                  ),
                  // child: Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       scheduleDetails.typeOfClass,
                  //       style: CustomTextStyles.titleMediumBlack900,
                  //     ),
                  //     // SizedBox(height: 1.v),
                  //     // Text(
                  //     //   "10 Students enrolled till now",
                  //     //   style: theme.textTheme.labelLarge,
                  //     // ),
                  //   ],
                  // ),
                ),
                // const Spacer(),
                // CustomImageView(
                //   imagePath: ImageConstant.imgFrame,
                //   height: 16.adaptSize,
                //   width: 16.adaptSize,
                //   margin: EdgeInsets.only(
                //     top: 12.v,
                //     right: 4.h,
                //     bottom: 12.v,
                //   ),
                // ),
              ],
            ),
          ),
          // Flexible(
          //   child: Container(
          //     constraints: BoxConstraints(maxHeight: 80.v),
          //     padding: EdgeInsets.symmetric(
          //       horizontal: 16.h,
          //       vertical: 11.v,
          //     ),
          //     decoration: AppDecoration.fillGray50.copyWith(
          //       borderRadius: BorderRadiusStyle.customBorderTL10,
          //     ),
          //     child: Row(
          //       children: [
          //         CustomImageView(
          //           imagePath: coachUrl,
          //           height: 50.adaptSize,
          //           width: 50.adaptSize,
          //           fit: BoxFit.cover,
          //           radius: BorderRadius.circular(
          //             15.h,
          //           ),
          //           alignment: Alignment.center,
          //         ),
          //         Padding(
          //           padding: EdgeInsets.only(left: 12.h),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Text(
          //                 className,
          //                 style: theme.textTheme.titleMedium!.copyWith(
          //                   color: appTheme.black900.withOpacity(0.8),
          //                 ),
          //               ),
          //               // SizedBox(height: 1.v),
          //               // Text(
          //               //   numberOfStudent,
          //               //   style: theme.textTheme.labelLarge!.copyWith(
          //               //     color: appTheme.black900.withOpacity(0.6),
          //               //   ),
          //               // ),
          //             ],
          //           ),
          //         ),
          //         const Spacer(),
          //         CustomImageView(
          //           imagePath: ImageConstant.imgFrame,
          //           height: 24.adaptSize,
          //           width: 24.adaptSize,
          //           margin: EdgeInsets.only(
          //             top: 8.v,
          //             right: 9.h,
          //             bottom: 8.v,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          SizedBox(height: 15.v),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 19.h,
              // vertical: 9.v,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.imgFrameGray50,
                      height: 20.adaptSize,
                      width: 20.adaptSize,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7.h),
                      child: Text(
                        time,
                        style: theme.textTheme.titleSmall!.copyWith(
                          color: appTheme.gray80001,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.v),
                GestureDetector(
                  onTap: () {
                    Utils.openMapUrl(context,
                        lat: upcommingData.latitude,
                        lng: upcommingData.longitude);
                  },
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgLayer1Primary,
                        height: 17.adaptSize,
                        width: 17.adaptSize,
                        margin: EdgeInsets.only(bottom: 2.v),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 7.h,
                          ),
                          child: Text(
                            upcommingData.location,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: theme.textTheme.titleSmall!.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Utils.openMapUrl(context,
                      //         lat: upcommingData.latitude,
                      //         lng: upcommingData.longitude);
                      //   },
                      //   child: Padding(
                      //     padding: EdgeInsets.only(left: 7.h),
                      //     child: Text(
                      //       locationName,
                      //       style: theme.textTheme.titleSmall!.copyWith(
                      //         decoration: TextDecoration.underline,
                      //         color: appTheme.gray80001,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      CustomImageView(
                        imagePath: ImageConstant.imgArrowRight,
                        height: 15.adaptSize,
                        width: 15.adaptSize,
                        margin: EdgeInsets.only(
                          left: 2.h,
                          bottom: 2.v,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 17.v),
                Row(
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.coinImage,
                      height: 17.adaptSize,
                      width: 17.adaptSize,
                      margin: EdgeInsets.only(bottom: 2.v),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7.h),
                      child: Text(
                        tokenQ,
                        style: theme.textTheme.titleSmall!.copyWith(
                          // decoration: TextDecoration.underline,
                          color: appTheme.gray80001,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 17.v),
                if (DateTime.parse(formatUtcDate(
                        upcommingData.startTime!.toIso8601String()))
                    .isBefore(DateTime.now()))
                  Center(
                    child: SizedBox(
                      height: 40.v,
                      width: 338.h,
                      child: CustomElevatedButton(
                        text: textButtonText,
                        onPressed: () {
                          if (isClassEnded) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListStudentCoach(
                                  classScheduleId: upcommingData.id,
                                  tokenPerClass: upcommingData.classFess,
                                  scheduleDetails: upcommingData,
                                ),
                              ),
                            );
                          } else {}
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10.v),
        ],
      ),
    );
  }
}

class FixScheduleSection extends StatelessWidget {
  const FixScheduleSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.h,
      // height: 206.v,
      decoration: ShapeDecoration(
        color: const Color(0xFFF8FAFF),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFD8E2FD)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10.h,
          ),
          CustomImageView(
            imagePath: ImageConstant.addPlusIcon,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            'Add new class',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 25.h,
          ),
          Container(
            width: 330.h,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 0.50,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFAFAFAF),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Text(
            'Looks like you haven’t added any dates yet in your schedule. Click + to get started.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black.withOpacity(0.75),
              fontSize: 14,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
              // height: 0.10,
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}

String formatUtcDate(String originalDateStr) {
  // Parse the original date string
  DateTime originalDate = DateTime.parse(originalDateStr);

  // Format the date as desired
  String formattedDateStr =
      DateFormat('yyyy-MM-dd HH:mm:ss.SSSSSS').format(originalDate);

  return formattedDateStr;
}
