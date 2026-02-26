import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';


class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: "Harvey Spector",
      ),
      body: SizedBox(
        width: mediaQueryData.size.width,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 24.v),
          child: Column(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgEllipse36101x101,
                height: 101.adaptSize,
                width: 101.adaptSize,
                radius: BorderRadius.circular(
                  50.h,
                ),
              ),
              SizedBox(height: 15.v),
              Text(
                'Harvey Spector',
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
                "Male - 22 years ",
                style: CustomTextStyles.titleSmallBlack900_1,
              ),
              SizedBox(height: 23.v),
              // _buildCoachProfile(context),
              // const ClassScheduleDate(),
              // SizedBox(height: 23.v),
              // // const SlotsAvaliable(),
              // // SizedBox(height: 20.v),
              // const TokenPerHour(),
              // SizedBox(height: 20.v),
              // const MapAdress(),
              // SizedBox(height: 20.v),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          SizedBox(height: 70.v, child: _buildScheduleCoach(context)),
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
