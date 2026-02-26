import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';

class MapAdress extends StatelessWidget {
  const MapAdress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.h,
      height: 80.v,
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
            'Melobourne park',
            style: TextStyle(
              color: Colors.black.withOpacity(0.800000011920929),
              fontSize: 16.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          subtitle: Text(
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
          trailing: CustomImageView(
            imagePath: ImageConstant.editIcon,
            height: 25.adaptSize,
            width: 25.adaptSize,
            // margin: const EdgeInsets.only(left: 10),
          ),
        ),
      ),
    );
  }
}

class TokenPerHour extends StatelessWidget {
  const TokenPerHour({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.h,
      height: 75.v,
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
      child: Center(
        child: ListTile(
          leading: CustomImageView(
            imagePath: ImageConstant.coinImage,
            height: 31.adaptSize,
            width: 31.adaptSize,
            margin: EdgeInsets.only(
              top: 2.v,
              bottom: 12.v,
            ),
          ),
          title: Text(
            '30 Tokens for this class',
            style: TextStyle(
              color: Colors.black.withOpacity(0.800000011920929),
              fontSize: 16.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          subtitle: Text(
            'You can change the amount',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 12.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          trailing: CustomImageView(
            imagePath: ImageConstant.editIcon,
            height: 25.adaptSize,
            width: 25.adaptSize,
            // margin: const EdgeInsets.only(left: 10),
          ),
        ),
      ),
    );
  }
}

class SlotsAvaliable extends StatelessWidget {
  const SlotsAvaliable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.h,
      height: 66.v,
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
      child: Center(
        child: ListTile(
          leading: CustomImageView(
            imagePath: ImageConstant.calender,
            height: 31.adaptSize,
            width: 31.adaptSize,
            // margin: EdgeInsets.symmetric(vertical: 4.v),
          ),
          title: Text(
            '52 Slots Avaliable',
            style: TextStyle(
              color: Colors.black.withOpacity(0.800000011920929),
              fontSize: 16.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          subtitle: Text(
            'This week (12th -18th NOV)',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
              fontSize: 12.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ),
      ),
    );
  }
}

class ClassScheduleDate extends StatelessWidget {
  final String date;
  final String timeing;
  const ClassScheduleDate({
    super.key,
    required this.date, 
    required this.timeing
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.h,
      height: 66.v,
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
      child: Center(
        child: ListTile(
          leading: CustomImageView(
            imagePath: ImageConstant.calender,
            height: 31.adaptSize,
            width: 31.adaptSize,
            // margin: EdgeInsets.symmetric(vertical: 4.v),
          ),
          title: Text(
            '27th October',
            style: TextStyle(
              // color: const Color(0xFF3D6DF5),
              fontSize: 16.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          subtitle: Text(
            'Time: 10:00-10:30 PM',
            style: TextStyle(
              // color: const Color(0xCC3D6DF5),
              fontSize: 12.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          trailing: CustomImageView(
            imagePath: ImageConstant.clearIcon,
            height: 25.adaptSize,
            width: 25.adaptSize,
            // margin: const EdgeInsets.only(left: 10),
          ),
        ),
      ),
     
    );
  }
}
