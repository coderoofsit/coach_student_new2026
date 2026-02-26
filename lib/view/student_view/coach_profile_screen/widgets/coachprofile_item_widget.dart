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
            imagePath: ImageConstant.mapIcon,
            height: 31.adaptSize,
            width: 31.adaptSize,
            // margin: EdgeInsets.symmetric(vertical: 4.v),
          ),
          title: Text(
            'Melobourne park (Most Recent)',
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
              decorationColor:const Color(0xFF3D6DF5),
              height: 0,
            ),
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
            imagePath: ImageConstant.coinImage,
            height: 31.adaptSize,
            width: 31.adaptSize,
            margin: EdgeInsets.only(
              top: 2.v,
              bottom: 12.v,
            ),
          ),
          title: Text(
            '30 Tokens Per Hour',
            style: TextStyle(
              color: Colors.black.withOpacity(0.800000011920929),
              fontSize: 16.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          subtitle: Text(
            'Prices may vary depends on date',
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
  const ClassScheduleDate({
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
            imagePath: ImageConstant1.imgGroup2296,
            height: 31.adaptSize,
            width: 31.adaptSize,
            // margin: EdgeInsets.symmetric(vertical: 4.v),
          ),
          title: Text(
            '27th October',
            style: TextStyle(
              color: const Color(0xFF3D6DF5),
              fontSize: 16.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
          subtitle: Text(
            'A class has been scheduled',
            style: TextStyle(
              color: const Color(0xCC3D6DF5),
              fontSize: 12.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
          trailing: CustomImageView(
            imagePath: ImageConstant.forwardIcon,
            height: 25.adaptSize,
            width: 25.adaptSize,
            // margin: const EdgeInsets.only(left: 10),
          ),
        ),
      ),
      // child: Align(
      //   alignment: Alignment.center,
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       CustomImageView(
      //         imagePath: ImageConstant.imgGroup2297,
      //         height: 31.adaptSize,
      //         width: 31.adaptSize,
      //         margin: EdgeInsets.symmetric(vertical: 4.v),
      //       ),
      //       Padding(
      //         padding: EdgeInsets.only(left: 21.h),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      // Text(
      //   '27th October',
      //   style: TextStyle(
      //     color: const Color(0xFF3D6DF5),
      //     fontSize: 16.fSize,
      //     fontFamily: 'Nunito Sans',
      //     fontWeight: FontWeight.w700,
      //     height: 0,
      //   ),
      // ),
      //             SizedBox(height: 1.v),
      // Text(
      //   'A class has been scheduled',
      //   style: TextStyle(
      //     color: const Color(0xCC3D6DF5),
      //     fontSize: 12.fSize,
      //     fontFamily: 'Nunito Sans',
      //     fontWeight: FontWeight.w600,
      //     height: 0,
      //   ),
      // )
      //           ],
      //         ),
      //       ),
      //       const Spacer(),
      // CustomImageView(
      //   imagePath: ImageConstant.forwardIcon,
      //   height: 25.adaptSize,
      //   width: 25.adaptSize,
      //   margin: EdgeInsets.symmetric(vertical: 7.v),
      // ),
      //     ],
      //   ),
      // ),
    );
  }
}
