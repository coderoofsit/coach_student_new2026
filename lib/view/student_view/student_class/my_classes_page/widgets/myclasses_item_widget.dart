import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../models/CoachClassModel.dart';
import '../../detail_classes.dart';

// ignore: must_be_immutable
class MyclassesItemWidget extends StatelessWidget {
  CoachClassesModel coachData;

  MyclassesItemWidget({super.key, 
    required this.coachData,
  });

  @override
  Widget build(BuildContext context) {
    return coachData.coach?.name == null ? const SizedBox(): GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context){
          return DetailClassesScreen(coachData: coachData,);
        }));
      },
      child: Container(
        margin: const EdgeInsets.symmetric( vertical: 5),
        decoration: AppDecoration.outlineBlack9001.copyWith(
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: CustomImageView(
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                      imagePath: coachData.coach?.image?.url ?? "",
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
                    imagePath: ImageConstant.img1,
                    height: 16.adaptSize,
                    width: 16.adaptSize,
                    margin: EdgeInsets.only(
                      top: 12.v,
                      right: 4.h,
                      bottom: 12.v,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.v),
            Padding(
              padding: EdgeInsets.only(left: 16.h),
              child: Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgFrameGray50,
                    height: 20.adaptSize,
                    width: 20.adaptSize,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 7.h),
                  //   child: Text(
                  //     "Thu, 23rd Dec",
                  //     style: theme.textTheme.titleSmall,
                  //   ),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(left: 7.h),
                    child: Text(
                      Utils.formatNameDate(
                          coachData.day!.toIso8601String()),
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7.h),
                    child: Text(
                      "${Utils.formatTime(coachData.startTime!.toLocal())} - ${Utils.formatTime(coachData.endTime!.toLocal())}",
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.v),
            Padding(
              padding: EdgeInsets.only(left: 17.h),
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
                      padding: EdgeInsets.only(left: 7.h),
                      child: Text(
                        coachData.location ?? "",
                        style: theme.textTheme.titleSmall!.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
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
            SizedBox(height: 12.v),
            Padding(
              padding: EdgeInsets.only(left: 17.h),
              child: Row(
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.coinImage,
                    height: 17.adaptSize,
                    width: 17.adaptSize,
                    margin: EdgeInsets.only(bottom: 2.v),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 7.h),
                    child:  Text(
                      "${coachData.classFess} token for the class",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.v,
            ),
            // Container(
            //   margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
            //     child: CustomElevatedButton(text: "Join Class")),
          ],
        ),
      ),
    );
  }
}


String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  String day = _getDayOfWeek(dateTime.weekday);
  String month = _getMonth(dateTime.month);
  String hour = dateTime.hour.toString().padLeft(2, '0');
  String minute = dateTime.minute.toString().padLeft(2, '0');
  String period = dateTime.hour < 12 ? 'AM' : 'PM';
  String hourPlusHalf = (dateTime.hour + 1).toString().padLeft(2, '0');
  String formattedDateTime =
      '$day $month: $hour:$minute-$hourPlusHalf:$minute $period';
  return formattedDateTime;
}

String _getDayOfWeek(int day) {
  switch (day) {
    case 1:
      return 'Sun';
    case 2:
      return 'Mon';
    case 3:
      return 'Tue';
    case 4:
      return 'Wed';
    case 5:
      return 'Thu';
    case 6:
      return 'Fri';
    case 7:
      return 'Sat';
    default:
      return '';
  }
}

String _getMonth(int month) {
  switch (month) {
    case 1:
      return 'Jan';
    case 2:
      return 'Feb';
    case 3:
      return 'Mar';
    case 4:
      return 'Apr';
    case 5:
      return 'May';
    case 6:
      return 'Jun';
    case 7:
      return 'Jul';
    case 8:
      return 'Aug';
    case 9:
      return 'Sep';
    case 10:
      return 'Oct';
    case 11:
      return 'Nov';
    case 12:
      return 'Dec';
    default:
      return '';
  }
}