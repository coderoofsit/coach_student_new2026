// import 'package:coach_student/core/app_export.dart';
// import 'package:coach_student/view/student_view/add_coach/add_coach.dart';
// import 'package:coach_student/view/student_view/coach_booking/calander_student.dart';
// import 'package:coach_student/view/student_view/student_chat/student_chat_list.dart';
// import 'package:coach_student/widgets/custom_elevated_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gap/gap.dart';
//
// import '../../../../provider/student_provider/student_home_provider.dart';
// import '../../student_chat/chats_page/chats_page.dart';
// import '../../student_chat/chats_tab_student_screen/chats_tab_student_screen.dart';
//
// // ignore_for_file: must_be_immutable
// class HomeStudentWidget extends ConsumerStatefulWidget {
//   const HomeStudentWidget({Key? key})
//       : super(
//           key: key,
//         );
//
//   @override
//   HomeStudentWidgetState createState() => HomeStudentWidgetState();
// }
//
// class HomeStudentWidgetState extends ConsumerState<HomeStudentWidget>
//     with AutomaticKeepAliveClientMixin<HomeStudentWidget> {
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       final studentHomeProvider = ref.watch(homeStudentNotifier);
//       studentHomeProvider.getCoachesList(context);
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     mediaQueryData = MediaQuery.of(context);
//     final homeStudentData = ref.watch(homeStudentNotifier);
//     return  SizedBox(
//
//         child: Column(
//           children: [
//             SizedBox(height: 20.v),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.h),
//               child: Column(
//                 children: [
//                   SizedBox(height: 5.v),
//                   const Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       'My coaches',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 20,
//                         fontFamily: 'Nunito Sans',
//                         fontWeight: FontWeight.w700,
//                         height: 0.07,
//                         letterSpacing: -0.44,
//                       ),
//
//                     ),
//                   ),
//                   SizedBox(height: 12.v),
//                   ListView.builder(
//                      physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: homeStudentData.coachesList.length,
//                       itemBuilder: (context,index) {
//                         final coachData = homeStudentData.coachesList[index];
//                       return GestureDetector(
//                         onTap: () {
//                           // Navigator.push(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (context) =>
//                           //             const CalenderStudent(),),);
//
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (_) =>  ChatsPageStudent(user: CoachUser(uId: coachData.id, name: coachData.coachName, profilePic: "https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?q=80&w=1085&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D", activate: '',),)));
//                         },
//                         child: _CoachesCard(
//                           context,
//                           profilePic: 'https://images.unsplash.com/photo-1529665253569-6d01c0eaf7b6?q=80&w=1085&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
//                           typeCoach: coachData.coachType,
//                           nameCoach: coachData.coachName,
//                           changes: coachData.token,
//                         ),
//                       );
//                     },
//                   ),
//                   SizedBox(height: 10.v),
//                   CustomElevatedButton(text: "Add New Coach",onPressed: (){
//                     Navigator.of(context).push(MaterialPageRoute(builder: (context){
//                       return AddCoachScreen();
//                     }));
//                   },),
//
//                   SizedBox(height: 35.v),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Refer a Friend",
//                       style: CustomTextStyles.titleLargeBlack900Bold,
//                     ),
//                   ),
//                   SizedBox(height: 13.v),
//                   _buildReferNowColumn(context),
//                   SizedBox(height: 35.v),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       "Payments",
//                       style: CustomTextStyles.titleLargeBlack900,
//                     ),
//                   ),
//                   SizedBox(height: 10.v),
//                   _buildConnectRow(context),
//                 ],
//               ),
//             ),
//             const Gap(20),
//           ],
//         ),
//       );
//   }
//
//   /// Section Widget
//
//   /// Section Widget
//   Widget _CoachesCard(
//     BuildContext context, {
//     required String profilePic,
//     required String typeCoach,
//     required String nameCoach,
//     required String changes,
//   }) {
//     mediaQueryData = MediaQuery.of(context);
//     return Container(
//       padding: EdgeInsets.all(10.h),
//       decoration: AppDecoration.outlineBlack.copyWith(
//         borderRadius: BorderRadiusStyle.roundedBorder5,
//       ),
//       child: SingleChildScrollView(
//         child: Row(
//           // mainAxisAlignment: MainAxisAlignment.start,
//
//           children: [
//             CustomImageView(
//               imagePath: profilePic,
//               height: 45.adaptSize,
//               width: 45.adaptSize,
//               fit: BoxFit.cover,
//               radius: BorderRadius.circular(
//                 22.h,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 13.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     nameCoach,
//                     style: TextStyle(
//                       color: Colors.black.withOpacity(0.800000011920929),
//                       fontSize: 16.fSize,
//                       fontFamily: 'Nunito Sans',
//                       fontWeight: FontWeight.w700,
//                       height: 0,
//                     ),
//                   ),
//                   SizedBox(height: 3.v),
//                   Text(
//                     typeCoach,
//                     style: theme.textTheme.labelLarge,
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(
//                 // left: 6.h,
//                 top: 26.v,
//               ),
//               child: _buildHour(
//                 context,
//                 hourText: changes,
//               ),
//             ),
//             CustomImageView(
//               imagePath: ImageConstant.imgLayer3Black900,
//               height: 20.adaptSize,
//               width: 20.adaptSize,
//               margin: EdgeInsets.only(
//                 left: 16.h,
//                 top: 12.v,
//                 bottom: 13.v,
//               ),
//             ),
//             CustomImageView(
//               imagePath: ImageConstant.imgArrowRight,
//               height: 24.adaptSize,
//               width: 24.adaptSize,
//               margin: EdgeInsets.only(
//                 left: 15.h,
//                 top: 10.v,
//                 bottom: 11.v,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Section Widget
//   Widget _buildReferNowColumn(BuildContext context) {
//     return Container(
//       width: 350.h,
//       padding: EdgeInsets.symmetric(
//         horizontal: 14.h,
//         vertical: 15.v,
//       ),
//       decoration: AppDecoration.outlineBlack900.copyWith(
//         borderRadius: BorderRadiusStyle.roundedBorder5,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(right: 19.h),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 CustomImageView(
//                   imagePath: ImageConstant.coinImage,
//                   height: 46.adaptSize,
//                   width: 46.adaptSize,
//                   margin: EdgeInsets.only(
//                     top: 1.v,
//                     bottom: 13.v,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 15.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Invite Friends & Earn 5 Coins ",
//                         style: theme.textTheme.titleMedium?.copyWith(
//                             fontWeight: FontWeight.bold, color: Colors.black),
//                       ),
//                       SizedBox(height: 5.v),
//                       SizedBox(
//                         width: 230.fSize,
//                         child: Text(
//                           "If CoachUs has helped you - It will help your friends as well - So, why not share it?",
//                           style: theme.textTheme.labelLarge,
//                           overflow: TextOverflow.fade,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 13.v),
//           CustomElevatedButton(
//             height: 30.v,
//             width: 96.h,
//             text: "Refer now",
//             margin: EdgeInsets.only(left: 61.h),
//             buttonStyle: CustomButtonStyles.none,
//             decoration: CustomButtonStyles.gradientOrangeToOrangeDecoration,
//             buttonTextStyle: CustomTextStyles.labelLargeRobotoOnErrorContainer,
//           ),
//         ],
//       ),
//     );
//   }
//
//   /// Section Widget
//   Widget _buildConnectRow(BuildContext context) {
//     return Container(
//       // width: 350.h,
//       height: 63.v,
//       padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
//       decoration: ShapeDecoration(
//         color: Colors.white,
//         shadows: const [
//           BoxShadow(
//             color: Colors.grey,
//             blurRadius: 5.0,
//           ),
//         ],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//       ),
//       child: Center(
//         child: Row(
//           children: [
//             CustomImageView(
//               imagePath: ImageConstant.imgRectangle579,
//               height: 43.adaptSize,
//               width: 43.adaptSize,
//               radius: BorderRadius.circular(
//                 3.h,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 19.h),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         "Connect ",
//                         style: CustomTextStyles.titleMediumBlack900_2,
//                       ),
//                       CustomImageView(
//                         imagePath: ImageConstant.imgStripeLogo21,
//                         height: 17.v,
//                         width: 42.h,
//                         margin: EdgeInsets.only(
//                           left: 5.h,
//                           top: 2.v,
//                           bottom: 2.v,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 3.v),
//                   Text(
//                     "For adding coins in your account",
//                     style: CustomTextStyles.labelLarge_1,
//                   ),
//                 ],
//               ),
//             ),
//             const Spacer(),
//             CustomImageView(
//               imagePath: ImageConstant.imgArrowRight,
//               height: 24.adaptSize,
//               width: 24.adaptSize,
//               margin: EdgeInsets.only(
//                 top: 9.v,
//                 right: 10.h,
//                 bottom: 10.v,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Common widget
//   Widget _buildHour(
//     BuildContext context, {
//     required String hourText,
//   }) {
//     return SizedBox(
//       // height: 17.v,
//       // width: 75.h,
//       child: Row(
//         children: [
//           const CircleAvatar(
//             radius: 2.0,
//           ),
//           const Gap(2),
//           Text(
//             hourText,
//             style: const TextStyle(
//               color: Color(0xFF666666),
//               fontSize: 12,
//               fontFamily: 'Nunito Sans',
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//           const Gap(5),
//           CustomImageView(
//             imagePath: ImageConstant.coinImage,
//             height: 14.adaptSize,
//             width: 14.adaptSize,
//             alignment: Alignment.topLeft,
//           ),
//           Text(
//             '/hour',
//             style: TextStyle(
//               color: Colors.black.withOpacity(0.6000000238418579),
//               fontSize: 12,
//               fontFamily: 'Nunito Sans',
//               fontWeight: FontWeight.w700,
//               height: 0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
