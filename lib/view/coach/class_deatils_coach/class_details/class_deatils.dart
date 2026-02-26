
import 'package:coach_student/core/utils/size_utils.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/image_constant.dart';
import '../../../../core/utils/utils.dart';
import '../../../../models/coach_model/CoachClassDetails_model.dart';
import '../../../../widgets/custom_image_view.dart';
import 'ListOfStudentPast.dart';

class ClassDetailsCoach extends StatelessWidget {
  final String classScheduleId;
  final num tokenPerClass;

  final Schedule scheduleDetails;
  const ClassDetailsCoach(
      {super.key,
      required this.tokenPerClass,
      required this.classScheduleId,
      required this.scheduleDetails});

  @override
  Widget build(BuildContext context) {
    initMediaQueary(context);
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: "Class details",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.v),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(24),
            Text(
              scheduleDetails.typeOfClass,
              style: TextStyle(
                color: const Color(0xFF171327),
                fontSize: 20.fSize,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
                height: 0.05,
              ),
            ),
            const Gap(20),
            if (scheduleDetails.participants.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListStudentCoachPast(
                        classScheduleId: scheduleDetails.id,
                        tokenPerClass: tokenPerClass,
                        scheduleDetails: scheduleDetails,
                      ),
                    ),
                  );
                },
                child: CustomCardCourse(
                  imagePath: ImageConstant.classIcon,
                  icons: Icons.arrow_forward_ios_outlined,
                  title: '${scheduleDetails.enrolled} Students enrolled',
                  subtitle: 'Check profiles',
                ),
              ),
            const Gap(16),
            CustomCardCourse(
              imagePath: ImageConstant.calender,
              icons: FontAwesomeIcons.penToSquare,
              title: Utils.formatNameDate(
                scheduleDetails.day!.toIso8601String(),
              ),
              subtitle:
                  'Time: ${Utils.formatTime(scheduleDetails.startTime!)}-${Utils.formatTime(scheduleDetails.endTime!)}',
            ),
            const Gap(16),
            CustomCardCourse(
              imagePath: ImageConstant1.coinImage,
              icons: FontAwesomeIcons.penToSquare,
              title: '${scheduleDetails.classFess} Tokens for this class',
              subtitle: '',
            ),
            const Gap(16),
            GestureDetector(
              onTap: () {
                Utils.openMapUrl(context,
                    lat: scheduleDetails.latitude,
                    lng: scheduleDetails.longitude);
              },
              child: CustomCardCourse(
                imagePath: ImageConstant.mapIcon,
                icons: FontAwesomeIcons.penToSquare,
                title: scheduleDetails.location,
                subtitle: 'Click here to view the Map.',
              ),
            ),
            const Spacer(),
            // CustomElevatedButton(
            //   text: "End Class",
            //   leftIcon: CustomImageView(
            //     imagePath: ImageConstant1.coinImage,
            //     width: 20.h,
            //     margin: EdgeInsets.only(right: 10.h),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CustomCardCourse extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final IconData? icons;

  const CustomCardCourse({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.h,
      height: 66.v,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        horizontal: 19.h,
        // vertical: 10.v,
      ),
      decoration: ShapeDecoration(
        color: const Color(0xFFF5F8FE),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFDCE5FD)),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        children: [
          CustomImageView(
            imagePath: imagePath,
            height: 31.adaptSize,
            width: 31.adaptSize,
            // margin: EdgeInsets.symmetric(vertical: 4.v),
          ),
          const Gap(20),
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.fSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                const Gap(5),
                // Text(
                //   subtitle,
                // style: TextStyle(
                //   color: Colors.black.withOpacity(0.5),
                //   fontSize: 12,
                //   fontFamily: 'Nunito Sans',
                //   fontWeight: FontWeight.w600,
                //   height: 0,
                // ),
                // ),
                Flexible(
                  child: Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const Spacer(),
          // Icon(
          //   icons,
          //   color: const Color(0xFF3D6DF5),
          // )
        ],
      ),
    );
  }
}
