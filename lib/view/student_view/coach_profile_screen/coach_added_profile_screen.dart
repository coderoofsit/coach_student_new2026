import 'package:coach_student/widgets/custom_app_bar_student.dart';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';

import 'package:flutter/material.dart';

import '../../../models/CoachChatModel.dart';
import '../../../models/CoachClassModel.dart';
import '../add_coach/qr_code_student.dart';
import '../student_chat/chats_page/chats_page.dart';

class CoachAddedProfileScreen extends StatelessWidget {
  CoachClassesModel coachData;
  CoachAddedProfileScreen({required this.coachData, Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      appBar: const CustomAppBarStudent(title: "Coach profile"),
      body: SafeArea(
        child: SizedBox(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 24.v),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CustomImageView(
                    imagePath: coachData.coach?.image?.url ?? "",
                    height: 101.adaptSize,
                    width: 101.adaptSize,
                    radius: BorderRadius.circular(
                      50.h,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 15.v),
                Text(
                  coachData.coach?.name ?? "",
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
                  coachData.typeOfClass ?? "",
                  style: CustomTextStyles.titleSmallBlack900_1,
                ),
                SizedBox(height: 23.v),
                _buildReferNow(context),
                SizedBox(height: 15.v),
                _buildPhoneNumber(context),
                SizedBox(height: 15.v),
                _buildReferNowColumn(context)
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: SizedBox(height: 70.v, child: _buildScheduleCoach(context, coachData)),
        ),
      ),

      // floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  /// Section Widget
  Widget _buildReferNow(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      decoration: ShapeDecoration(
        color: const Color(0xFFF5F8FE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 19.v,
          ),
          Text(
            'About ${coachData.coach?.name}',
            style: TextStyle(
              color: Colors.black.withOpacity(0.75),
              fontSize: 16.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w700,
              height: 0.08,
              letterSpacing: 0.32,
            ),
          ),
          SizedBox(
            height: 11.v,
          ),
          Text(
            " ${coachData.coach?.about}",
            style: TextStyle(
              color: Colors.black.withOpacity(0.75),
              fontSize: 14.fSize,
              fontFamily: 'Nunito Sans',
              fontWeight: FontWeight.w400,
              // height: 0.10,
              letterSpacing: 0.28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumber(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
      decoration: ShapeDecoration(
        color: const Color(0xFFF5F8FE),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10.v,
          ),
          Row(
            children: [
              CustomImageView(imagePath: ImageConstant1.imgPhphonelight),
              SizedBox(
                width: 10.v,
              ),
              Text(
                '+ 1 ${coachData.coach?.phoneNumber}',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.75),
                  fontSize: 16.fSize,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                  height: 0.08,
                  letterSpacing: 0.32,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.v,
          ),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildScheduleCoach(
      BuildContext context, CoachClassesModel coachData) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 19.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: CustomElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ChatsPageStudent(
                      user: CoachChatModel(
                        userId: coachData.coach?.id ?? "",
                        name: coachData.coach?.name ?? "",
                        imageUrl: coachData.coach?.image?.url ?? "",
                        isRead: false,
                        coachType: coachData.typeOfClass.toString(),
                      ),
                    ),
                  ),
                );
              },
              text: "Message",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReferNowColumn(BuildContext context) {
    return Container(
      width: 350.h,
      padding: EdgeInsets.symmetric(
        horizontal: 14.h,
        vertical: 15.v,
      ),
      decoration: AppDecoration.outlineBlack900.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 19.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.coinImage,
                  height: 46.adaptSize,
                  width: 46.adaptSize,
                  margin: EdgeInsets.only(
                    top: 1.v,
                    bottom: 13.v,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invite Friends & Earn 5 Coins ",
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 5.v),
                      SizedBox(
                        width: 230.fSize,
                        child: Text(
                          "If $appName has helped you - It will help your friends as well - So, why not share it?",
                          style: theme.textTheme.labelLarge,
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 13.v),
          CustomElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return QrScreenStudent(
                  passcode: coachData.coach?.passcode.toString() ?? "",
                  userIdCoach: coachData.coach?.id ?? "",
                );
              }));
            },
            height: 30.v,
            width: 96.h,
            text: "Refer now",
            margin: EdgeInsets.only(left: 61.h),
            buttonStyle: CustomButtonStyles.none,
            decoration: CustomButtonStyles.gradientOrangeToOrangeDecoration,
            buttonTextStyle: CustomTextStyles.labelLargeRobotoOnErrorContainer,
          ),
        ],
      ),
    );
  }
}
