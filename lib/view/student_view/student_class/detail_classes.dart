import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../models/CoachClassModel.dart';
import '../../../widgets/custom_app_bar_student.dart';
import '../coach_profile_screen/coach_added_profile_screen.dart';

class DetailClassesScreen extends StatelessWidget {
  CoachClassesModel coachData;
  DetailClassesScreen({required this.coachData, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarStudent(title: 'Class details'),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>  CoachAddedProfileScreen(coachData: coachData,)));
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 11.v,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF5F8FE),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFDCE5FD)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CustomImageView(
                        imagePath: coachData.coach?.image?.url,
                        height: 40.adaptSize,
                        width: 40.adaptSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${coachData.coach?.name}",
                            style: CustomTextStyles.titleMediumBlack900,
                          ),
                          SizedBox(height: 1.v),
                          Text(
                            coachData.typeOfClass ?? "",
                            style: theme.textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    CustomImageView(
                      imagePath: ImageConstant.imgArrowRight,
                      margin: EdgeInsets.only(
                        top: 12.v,
                        right: 4.h,
                        bottom: 12.v,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 11.v,
              ),
              decoration: ShapeDecoration(
                color: const Color(0xFFF5F8FE),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFDCE5FD)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.calender,
                    height: 40.adaptSize,
                    width: 40.adaptSize,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Utils.formatNameDate(
                              coachData.day!.toIso8601String()),
                          style: CustomTextStyles.titleMediumBlack900,
                        ),
                        SizedBox(height: 1.v),
                        Text(
                          "${Utils.formatTime(coachData.startTime!.toLocal())} - ${Utils.formatTime(coachData.endTime!.toLocal())}",
                          style: theme.textTheme.labelLarge,
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 11.v,
              ),
              decoration: ShapeDecoration(
                color: const Color(0xFFF5F8FE),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFDCE5FD)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.coinImage,
                    height: 40.adaptSize,
                    width: 40.adaptSize,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${coachData.classFess} Tokens Per Hour",
                          style: CustomTextStyles.titleMediumBlack900,
                        ),
                        SizedBox(height: 1.v),
                        Text(
                          "charged",
                          style: theme.textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Utils.openMapUrl(
                  context,
                  lat: double.parse(coachData.latitude.toString()),
                  lng: double.parse(coachData.longitude.toString()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.h,
                  vertical: 11.v,
                ),
                decoration: ShapeDecoration(
                  color: const Color(0xFFF5F8FE),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Color(0xFFDCE5FD)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomImageView(
                      imagePath: ImageConstant.mapIcon,
                      height: 40.adaptSize,
                      width: 40.adaptSize,
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coachData.location.toString(),
                              style: CustomTextStyles.titleMediumBlack900,
                            ),
                            SizedBox(height: 1.v),
                            const Text(
                              'Click here to view the Map.',
                              style: TextStyle(
                                color: Color(0xFF3D6DF5),
                                fontSize: 12,
                                fontFamily: 'Nunito Sans',
                                fontWeight: FontWeight.w600,
                                height: 0,
                                decoration: TextDecoration.underline,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
