import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';

import '../../client_profile_screen/client_profile_screen.dart';

// ignore_for_file: must_be_immutable
class ChatClassTabCoach extends StatefulWidget {
  const ChatClassTabCoach({Key? key})
      : super(
          key: key,
        );

  @override
  ChatClassTabCoachState createState() => ChatClassTabCoachState();
}

class ChatClassTabCoachState extends State<ChatClassTabCoach>
    with AutomaticKeepAliveClientMixin<ChatClassTabCoach> {
  TextEditingController typehereController = TextEditingController();

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          decoration: AppDecoration.fillOnErrorContainer,
          child: Column(
            children: [
              SizedBox(height: 20.v),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: _buildClassInfoCard(context,
                          clientName: "Meet Harvey Spector",
                          clientAge: "Male - 22 years",
                          thurdDec: "Thu, 23rd Dec",
                          time: "10:00-10:30 PM",
                          melbourneCricPark: "Melbourne Cric park",
                          tokenQ: "15 Tokens for this class"),
                    ),
                    SizedBox(height: 20.v),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                          MaterialPageRoute(builder: (context)=> const ClientProfileScreen(),));
                        },
                        child: _buildClassInfoCard(
                          context,
                          clientName: "Meet Harvey Spector",
                          clientAge: "Male - 22 years",
                          thurdDec: "Thu, 23rd Dec",
                          time: "10:00-10:30 PM",
                          melbourneCricPark: "Melbourne Cric park",
                          tokenQ: "15 Tokens for this class",
                        ),
                      ),
                    ),
                    // const Spacer(),
                    // _buildTextField(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  // Widget _buildTextField(BuildContext context) {
  //   return Container(
  //     width: double.maxFinite,
  //     padding: EdgeInsets.symmetric(vertical: 14.v),
  //     decoration: AppDecoration.outlineDeepPurple,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CustomImageView(
  //           imagePath: ImageConstant.imgCapa1Black900,
  //           height: 20.adaptSize,
  //           width: 20.adaptSize,
  //           margin: EdgeInsets.only(
  //             top: 8.v,
  //             bottom: 31.v,
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(bottom: 24.v),
  //           child: CustomTextFormField(
  //             width: 270.h,
  //             // onTapOutside: (val) =>                     FocusManager.instance.primaryFocus?.unfocus(),
  //             controller: typehereController,
  //             hintText: "Type here...",
  //             hintStyle: CustomTextStyles.titleSmallBlack900_4,
  //             textInputAction: TextInputAction.done,
  //             contentPadding: EdgeInsets.symmetric(
  //               horizontal: 15.h,
  //               vertical: 7.v,
  //             ),
  //             borderDecoration: TextFormFieldStyleHelper.outlineBlackTL5,
  //           ),
  //         ),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgSvgroot,
  //           height: 22.adaptSize,
  //           width: 22.adaptSize,
  //           margin: EdgeInsets.only(
  //             top: 7.v,
  //             bottom: 30.v,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// Section Widget
  // Widget _buildSixtyOne(BuildContext context) {
  //   return Container(
  //     width: double.maxFinite,
  //     padding: EdgeInsets.symmetric(vertical: 14.v),
  //     decoration: AppDecoration.outlineDeepPurple,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         CustomImageView(
  //           imagePath: ImageConstant.imgCapa1Black900,
  //           height: 20.adaptSize,
  //           width: 20.adaptSize,
  //           margin: EdgeInsets.only(
  //             top: 8.v,
  //             bottom: 31.v,
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(bottom: 24.v),
  //           child: CustomTextFormField(
  //             width: 270.h,
  //             controller: typehereController,
  //             hintText: "Type here...",
  //             // hintStyle: CustomTextStyles.titleSmallBlack900_4,
  //             textInputAction: TextInputAction.done,
  //             contentPadding: EdgeInsets.symmetric(
  //               horizontal: 15.h,
  //               vertical: 7.v,
  //             ),
  //             // borderDecoration: TextFormFieldStyleHelper.outlineBlackTL5,
  //           ),
  //         ),
  //         CustomImageView(
  //           imagePath: ImageConstant.imgSvgroot,
  //           height: 22.adaptSize,
  //           width: 22.adaptSize,
  //           margin: EdgeInsets.only(
  //             top: 7.v,
  //             bottom: 30.v,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// Common widget
  Widget _buildClassInfoCard(BuildContext context,
      {required String clientName,
      required String clientAge,
      required String thurdDec,
      required String time,
      required String melbourneCricPark,
      required String tokenQ}) {
    return Container(
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
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgGroup1272,
                  height: 40.adaptSize,
                  width: 40.adaptSize,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clientName,
                        style: theme.textTheme.titleMedium!.copyWith(
                          color: appTheme.black900.withOpacity(0.8),
                        ),
                      ),
                      SizedBox(height: 1.v),
                      Text(
                        clientAge,
                        style: theme.textTheme.labelLarge!.copyWith(
                          color: appTheme.black900.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CustomImageView(
                  imagePath: ImageConstant.imgFrame,
                  height: 24.adaptSize,
                  width: 24.adaptSize,
                  margin: EdgeInsets.only(
                    top: 8.v,
                    right: 9.h,
                    bottom: 8.v,
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
                Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    thurdDec,
                    style: theme.textTheme.titleSmall!.copyWith(
                      color: appTheme.gray80001,
                    ),
                  ),
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
                Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    melbourneCricPark,
                    style: theme.textTheme.titleSmall!.copyWith(
                      decoration: TextDecoration.underline,
                      color: appTheme.gray80001,
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
          SizedBox(height: 17.v),
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
          ),
          SizedBox(height: 17.v),
        ],
      ),
    );
  }
}
