import 'package:coach_student/provider/student_provider/student_home_provider.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../../main.dart';
import '../../../models/CoachProfileDetailsModel.dart';
import '../../../services/api/api.dart';

class CoachProfileScreen extends ConsumerStatefulWidget {
  CoachProfileDetailsModel coachProfileDetailsModel;

  CoachProfileScreen({super.key, required this.coachProfileDetailsModel});

  @override
  ConsumerState<CoachProfileScreen> createState() => _CoachProfileScreenState();
}

class _CoachProfileScreenState extends ConsumerState<CoachProfileScreen> {


  bool isLoading = false;


  Future<void> addCoach(BuildContext context, String code) async {

    setState(() {
      isLoading = true;
    });

    String finalUrl = (widget.coachProfileDetailsModel.referralCode != null &&
            widget.coachProfileDetailsModel.referralCode!.isNotEmpty)
        ? "/student/add-coach?passcode=$code&refrelcode=${widget.coachProfileDetailsModel.referralCode}"
        : "/student/add-coach?passcode=$code";
    final result = await DioApi.get(path: finalUrl);

    if (result.response?.data != null) {


      // print("coach passcode ${result.response?.data}");

      // Navigator.of(context).popUntil((route) =>
      //     route.settings.name == AppRoutes.studentBottomNavBarScreen);
      navigatorKey.currentState?.popUntil((route) => route.settings.name == AppRoutes.studentBottomNavBarScreen);
      ref.read(homeStudentNotifier).getCoachesList(context);
      ref.read(homeStudentNotifier).getCoachClassesList(context);
      Utils.toast(message: '${result.response?.data["message"]}');
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      result.handleError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        appBar: const CustomAppBarStudent(
          title: "Coach Profile",
        ),
        body: SizedBox(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 24.v),
            child: Column(
              children: [
                CustomImageView(
                  imagePath: widget.coachProfileDetailsModel.image?.url,
                  height: 101.adaptSize,
                  width: 101.adaptSize,
                  radius: BorderRadius.circular(
                    50.h,
                  ),
                ),
                SizedBox(height: 15.v),
                Text(
                  "${widget.coachProfileDetailsModel.name}",
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
                  "${widget.coachProfileDetailsModel.coachType} coach",
                  style: CustomTextStyles.titleSmallBlack900_1,
                ),
                SizedBox(height: 23.v),
                _buildReferNow(context),
                SizedBox(height: 15.v),
                _buildPhoneNumber(context),
                SizedBox(height: 37.v),
              ],
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: SizedBox(height: 70.v, child: _buildScheduleCoach(context)),
          ),
        ),
        // floatingActionButton: _buildFloatingActionButton(context),
      ),
    );
  }

  /// Section Widget
  Widget _buildReferNow(BuildContext context) {
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
            height: 19.v,
          ),
          Text(
            'About ${widget.coachProfileDetailsModel.name}',
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
            '${widget.coachProfileDetailsModel.about}',
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
                '+ 1 ${widget.coachProfileDetailsModel.phoneNumber}',
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
  Widget _buildScheduleCoach(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 19.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: isLoading ? Utils.progressIndicator : CustomElevatedButton(
              onPressed: () {
                addCoach(context, widget.coachProfileDetailsModel.passcode.toString());
              },
              text: "Add Coach",
              // leftIcon: Container(
              //   margin: EdgeInsets.only(right: 10.h),
              //   child: CustomImageView(
              //     imagePath: ImageConstant.imgSvg8,
              //     height: 19.adaptSize,
              //     width: 19.adaptSize,
              //   ),
              // ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 10.h),
          //   child: CustomIconButton(
          //     height: 50.adaptSize,
          //     width: 50.adaptSize,
          //     padding: EdgeInsets.all(15.h),
          //     child: CustomImageView(
          //       imagePath: ImageConstant.imgCapa1Primary,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
