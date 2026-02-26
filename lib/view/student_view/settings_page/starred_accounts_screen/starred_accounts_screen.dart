import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StarredAccountsStudentScreen extends StatelessWidget {
  const StarredAccountsStudentScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: 'Starred accounts',
      ),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(
          horizontal: 20.h,
          vertical: 14.v,
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 5.h),
                child: Text(
                  "Starred Accounts",
                  style: theme.textTheme.headlineSmall,
                ),
              ),
            ),
            SizedBox(height: 20.v),
            _CoachesCard(
              context,
              profilePic:
                  'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              typeCoach: 'Physics Tutor',
              nameCoach: 'Harvey Spector',
              changes: '20',
            ),
            SizedBox(height: 20.v),
            _CoachesCard(
              context,
              profilePic:
                  'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              typeCoach: 'Physics Tutor',
              nameCoach: 'Harvey Spector',
              changes: '20',
            ),
            SizedBox(height: 20.v),
            _CoachesCard(
              context,
              profilePic:
                  'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
              typeCoach: 'Physics Tutor',
              nameCoach: 'Harvey Spector',
              changes: '20',
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _CoachesCard(
    BuildContext context, {
    required String profilePic,
    required String typeCoach,
    required String nameCoach,
    required String changes,
  }) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomImageView(
            imagePath: profilePic,
            height: 45.adaptSize,
            width: 45.adaptSize,
            fit: BoxFit.cover,
            radius: BorderRadius.circular(
              22.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 13.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nameCoach,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.800000011920929),
                    fontSize: 16.fSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                SizedBox(height: 3.v),
                Text(
                  typeCoach,
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              // left: 6.h,
              top: 26.v,
            ),
            child: _buildHour(
              context,
              hourText: changes,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgLayer3Black900,
            height: 20.adaptSize,
            width: 20.adaptSize,
            margin: EdgeInsets.only(
              left: 22.h,
              top: 12.v,
              bottom: 13.v,
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgArrowRight,
            height: 24.adaptSize,
            width: 24.adaptSize,
            margin: EdgeInsets.only(
              left: 15.h,
              top: 10.v,
              bottom: 11.v,
            ),
          ),
        ],
      ),
    );
  }

  /// Common widget
  Widget _buildHour(
    BuildContext context, {
    required String hourText,
  }) {
    return SizedBox(
      // height: 17.v,
      // width: 75.h,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 2.0,
          ),
          const Gap(2),
          Text(
            hourText,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 12,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(5),
          CustomImageView(
            imagePath: ImageConstant.coinImage,
            height: 14.adaptSize,
            width: 14.adaptSize,
            alignment: Alignment.topLeft,
          ),
          Text(
            '/hour',
            style: TextStyle(
              color: Colors.black.withOpacity(0.6000000238418579),
              fontSize: 12,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }
}
