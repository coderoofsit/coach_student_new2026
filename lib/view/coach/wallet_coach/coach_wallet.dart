import 'dart:developer';

import 'package:coach_student/core/app_export.dart';

import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_outlined_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../../provider/coach/TranscationHistoryProvider.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/wallet_low_balance_page/widgets/walletlowbalance_item_widget.dart';
import 'widgets/low_student_widget.dart';

// ignore_for_file: must_be_immutable
class CoachWallet extends ConsumerStatefulWidget {
  const CoachWallet({Key? key})
      : super(
          key: key,
        );

  @override
  CoachWalletConsumerState createState() => CoachWalletConsumerState();
}

class CoachWalletConsumerState extends ConsumerState<CoachWallet>
    with TickerProviderStateMixin {
  final TextEditingController _amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late TabController tabviewController;

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      ref.read(transcationHistoryProvider).getTranscationListCoach(context);
      ref.read(transcationHistoryProvider).getLowBalance(context);

    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final coachToken = ref.watch(transcationHistoryProvider
        .select((value) => value.coachProfileDetailsModel));
    final transtData = ref.watch(transcationHistoryProvider
        .select((value) => value.transcationHistoryCoach));

    final selectIndex = ref.watch(transcationHistoryProvider
        .select((value) => value.selectedIndex));

    final lowStudentData = ref.watch(transcationHistoryProvider.select((value)
    => value.lowBalanceStudent));

    return SafeArea(
      child: Scaffold(
        body: ref.watch(transcationHistoryProvider
                .select((value) => value.isLoadingTranscation))
            ? Utils.progressIndicator
            : Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 19.v),
                  SizedBox(
                    // flex: 1,
                    height: 170.v,
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusStyle.roundedBorder5,
                            // border: Border.all(width: 0.5.h, ),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                              ),
                            ]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 13.v),
                              child: Column(
                                children: [
                                  Container(
                                    width: 172.h,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 19.h,
                                      vertical: 14.v,
                                    ),
                                    // decoration: AppDecoration.outlineGray.copyWith(
                                    //   borderRadius: BorderRadiusStyle.customBorderBR10,
                                    // ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Your token balance",
                                            style: CustomTextStyles
                                                .titleSmallBlack900_1,
                                          ),
                                        ),
                                        SizedBox(height: 7.v),
                                        CustomOutlinedButton(
                                          height: 28.v,
                                          width: 73.h,
                                          text: "${coachToken.token ?? 0}",
                                          buttonTextStyle: TextStyle(
                                            color: const Color(0xFF3D6DF5),
                                            fontSize: 16.90.fSize,
                                            fontFamily: 'Nunito Sans',
                                            fontWeight: FontWeight.w800,
                                            height: 0.09,
                                          ),
                                          rightIcon: Container(
                                            margin: EdgeInsets.only(left: 6.h),
                                            child: CustomImageView(
                                              imagePath:
                                                  ImageConstant.coinImage,
                                              height: 19.v,
                                              width: 20.h,
                                            ),
                                          ),
                                          buttonStyle:
                                              CustomButtonStyles.outlinePrimary,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 13.v),
                                  Text(
                                    "Note: 1 Token = 1 dollar",
                                    style: CustomTextStyles.bodySmallBlack900,
                                  ),
                                  SizedBox(height: 6.v),
                                  CustomElevatedButton(
                                    height: 30.v,
                                    width: 138.h,
                                    text: "Withdraw tokens",
                                    buttonStyle:
                                        CustomButtonStyles.fillPrimaryTL15,
                                    buttonTextStyle: CustomTextStyles
                                        .labelLargeRobotoOnErrorContainer,
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Withdraw token'),
                                            content: Form(
                                              key: formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CustomTextFormField(
                                                    controller:
                                                        _amountController,
                                                    hintText:
                                                        "Please enter an Token.",
                                                    textInputType:
                                                        TextInputType.number,
                                                    validator: (val) => val!
                                                            .isEmpty
                                                        ? 'Please enter valid  Token .'
                                                        : null,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              SizedBox(
                                                width: 80.h,
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.fSize),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 30.h,
                                              ),
                                              CustomElevatedButton(
                                                // height: 30.v,
                                                width: 80.h,
                                                text: "Submit",
                                                onPressed: () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog

                                                    ref.read(transcationHistoryProvider)
                                                        .withdrawMoney(
                                                          context,
                                                          amount: int.parse(
                                                              _amountController
                                                                  .text),
                                                        );
                                                  }
                                                },
                                                // text: 'Submit',
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            CustomImageView(
                              imagePath: ImageConstant.img1158241721034536,
                              height: 152.v,
                              width: 145.h,
                              margin: EdgeInsets.only(
                                left: 20.h,
                                top: 6.v,
                                bottom: 6.v,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 19.v),
                  Container(
                    height: 30.v,
                    width: 300.h,
                    margin: EdgeInsets.only(left: 20.h),
                    child: TabBar(
                      onTap: (val){
                        log("ios $val");
                        ref.read(transcationHistoryProvider).changeIndex(val);
                      },
                      controller: tabviewController,
                      labelPadding:
                      const EdgeInsets.symmetric(horizontal: 2),
                      labelColor: appTheme.black900.withOpacity(0.8),
                      labelStyle: TextStyle(
                        fontSize: 13.200000762939453.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelColor: theme.colorScheme.primary,
                      unselectedLabelStyle: TextStyle(
                        fontSize: 13.200000762939453.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                      indicatorPadding: EdgeInsets.all(
                        0.5.h,
                      ),
                      indicator: BoxDecoration(
                        color: const Color(0x193D6DF5),
                        borderRadius: BorderRadius.circular(
                          15.h,
                        ),
                      ),
                      tabs: [
                        Container(

                          padding:
                          const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: ShapeDecoration(
                            // color: const Color(0x193D6DF5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                              side: BorderSide(
                                width: 1,
                                color: Colors.black
                                    .withOpacity(0.10000000149011612),
                              ),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Transaction history",
                            ),
                          ),
                        ),

                        Container(
                          // width: 96.80,
                          // height: 30,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: ShapeDecoration(
                            // color: const Color(0x193D6DF5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22),
                              side: BorderSide(
                                width: 1,
                                color: Colors.black
                                    .withOpacity(0.10000000149011612),
                              ),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              "Owed",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 20.h),
                  //   child: Row(
                  //     children: [
                  //       Container(
                  //         decoration: ShapeDecoration(
                  //           // color: const Color(0x193D6DF5),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(22),
                  //             side: BorderSide(
                  //               width: 1,
                  //               color: Colors.black
                  //                   .withOpacity(0.10000000149011612),
                  //             ),
                  //           ),
                  //         ),
                  //         child: Text(
                  //           "Transaction history",
                  //           style: CustomTextStyles.titleLargeBlack900,
                  //         ),
                  //       ),
                  //       Container(
                  //         decoration: ShapeDecoration(
                  //           // color: const Color(0x193D6DF5),
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(22),
                  //             side: BorderSide(
                  //               width: 1,
                  //               color: Colors.black
                  //                   .withOpacity(0.10000000149011612),
                  //             ),
                  //           ),
                  //         ),
                  //         child: Text(
                  //
                  //           "Owed",
                  //           style: CustomTextStyles.titleLargeBlack900,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 19.v),
                  if(selectIndex == 0)...[
                    if (transtData.transaction.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 170.v,
                        ),
                        child: Center(
                          child: Text(
                            "no transaction history at this time",
                            style: CustomTextStyles.titleLargeBold,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          child: ListView.separated(
                            // physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (
                                context,
                                index,
                                ) {
                              return SizedBox(
                                height: 12.v,
                              );
                            },
                            itemCount: transtData.transaction.length,
                            itemBuilder: (context, index) {
                              final data = transtData.transaction[index];
                              // Show all transactions: increase type OR withdrawals (decrease with status)
                              if (data.type == "increase" || 
                                  (data.type == "decrease" && (data.status == "pending" || data.status == "success"))) {
                                return WalletlowbalanceItemWidget(
                                    trnstactionData: data);
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ),
                      ),
                  ],
                  if(selectIndex == 1)...[
                    if (lowStudentData.student == null || (lowStudentData.student?.isEmpty ?? true))
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 170.v,
                        ),
                        child: Center(
                          child: Text(
                            "no students who owe at this time",
                            style: CustomTextStyles.titleLargeBold,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          child: ListView.separated(
                            // physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (
                                context,
                                index,
                                ) {
                              return SizedBox(
                                height: 12.v,
                              );
                            },
                            itemCount: lowStudentData.student?.length ?? 0,
                            itemBuilder: (context, index) {
                              final studentList = lowStudentData.student;
                              if (studentList == null || index >= studentList.length) {
                                return const SizedBox.shrink();
                              }
                              final data = studentList[index];
                              // Check if data itself is not null and has required student/classScheduled data
                              if (data.student == null || data.classScheduled == null) {
                                return const SizedBox.shrink();
                              }
                              return LowStudentWidget(
                                    studentData: data,);
                            },
                          ),
                        ),
                      ),
                  ]

                ],
              ),
        // resizeToAvoidBottomInset: false,
        // body: Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     SizedBox(
        //       height: 10.v,
        //     ),
        //     // _MyTokenCard(context),
        //     Align(
        //       alignment: Alignment.center,
        //       child: Container(
        //         margin: EdgeInsets.symmetric(horizontal: 20.h),
        //         decoration: BoxDecoration(
        //             borderRadius: BorderRadiusStyle.roundedBorder5,
        //             // border: Border.all(width: 0.5.h, ),
        //             color: Colors.white,
        //             boxShadow: const [
        //               BoxShadow(
        //                 color: Colors.grey,
        //                 blurRadius: 5.0,
        //               ),
        //             ]),
        //         child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           mainAxisSize: MainAxisSize.max,
        //           children: [
        //             Padding(
        //               padding: EdgeInsets.only(bottom: 13.v),
        //               child: Column(
        //                 children: [
        //                   Container(
        //                     width: 172.h,
        //                     padding: EdgeInsets.symmetric(
        //                       horizontal: 19.h,
        //                       vertical: 14.v,
        //                     ),
        //                     // decoration: AppDecoration.outlineGray.copyWith(
        //                     //   borderRadius: BorderRadiusStyle.customBorderBR10,
        //                     // ),
        //                     child: Column(
        //                       mainAxisSize: MainAxisSize.min,
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: [
        //                         Align(
        //                           alignment: Alignment.center,
        //                           child: Text(
        //                             "Your Token Balance",
        //                             style:
        //                                 CustomTextStyles.titleSmallBlack900_1,
        //                           ),
        //                         ),
        //                         SizedBox(height: 7.v),
        //                         CustomOutlinedButton(
        //                           height: 28.v,
        //                           width: 73.h,
        //                           text: "${coachToken.token ?? 0}",
        //                           buttonTextStyle: TextStyle(
        //                             color: const Color(0xFF3D6DF5),
        //                             fontSize: 16.90.fSize,
        //                             fontFamily: 'Nunito Sans',
        //                             fontWeight: FontWeight.w800,
        //                             height: 0.09,
        //                           ),
        //                           rightIcon: Container(
        //                             margin: EdgeInsets.only(left: 6.h),
        //                             child: CustomImageView(
        //                               imagePath: ImageConstant.coinImage,
        //                               height: 19.v,
        //                               width: 20.h,
        //                             ),
        //                           ),
        //                           buttonStyle:
        //                               CustomButtonStyles.outlinePrimary,
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                   SizedBox(height: 13.v),
        //                   Text(
        //                     "Note: 1 Token = 1 dollar",
        //                     style: CustomTextStyles.bodySmallBlack900,
        //                   ),
        //                   SizedBox(height: 6.v),
        //                   CustomElevatedButton(
        //                     height: 30.v,
        //                     width: 138.h,
        //                     text: "Withdraw Tokens",
        //                     buttonStyle: CustomButtonStyles.fillPrimaryTL15,
        //                     buttonTextStyle: CustomTextStyles
        //                         .labelLargeRobotoOnErrorContainer,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             CustomImageView(
        //               imagePath: ImageConstant.img1158241721034536,
        //               height: 152.v,
        //               width: 145.h,
        //               margin: EdgeInsets.only(
        //                 left: 20.h,
        //                 top: 6.v,
        //                 bottom: 6.v,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 10.v,
        //     ),
        //     const Expanded(child: WalletLowBalancePage()),
        //   ],
        // ),
        // body: Container(
        //   width: double.maxFinite,
        //   decoration: AppDecoration.fillOnErrorContainer,
        //   child: Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         mainAxisAlignment: MainAxisAlignment.end,
        //         children: [
        //           // SizedBox(height: 20.v),
        //           // Padding(
        //           //   padding: EdgeInsets.only(left: 20.h),
        //           //   child: Text(
        //           //     "My Tokens",
        //           //     style: CustomTextStyles.titleLargeBlack900,
        //           //   ),
        //           // ),
        //           // SizedBox(height: 12.v),
        //           // _MyTokenCard(context),
        //           // SizedBox(height: 35.v),
        //           Padding(
        //             padding: EdgeInsets.only(left: 20.h),
        //             child: Text(
        //               "History",
        //               style: CustomTextStyles.titleLargeBlack900,
        //             ),
        //           ),
        //           // SizedBox(height: 13.v),
        //           Container(
        //             height: 30.v,
        //             width: 190.h,
        //             margin: EdgeInsets.only(left: 20.h),
        //             // child: TabBar(
        //             //   controller: tabviewController,
        //             //   labelPadding: const EdgeInsets.symmetric(horizontal: 2),
        //             //   labelColor: appTheme.black900.withOpacity(0.8),
        //             //   labelStyle: TextStyle(
        //             //     fontSize: 13.200000762939453.fSize,
        //             //     fontFamily: 'Roboto',
        //             //     fontWeight: FontWeight.w500,
        //             //   ),
        //             //   unselectedLabelColor: theme.colorScheme.primary,
        //             //   unselectedLabelStyle: TextStyle(
        //             //     fontSize: 13.200000762939453.fSize,
        //             //     fontFamily: 'Roboto',
        //             //     fontWeight: FontWeight.w500,
        //             //   ),
        //             //   indicatorPadding: EdgeInsets.all(
        //             //     0.5.h,
        //             //   ),
        //             //   indicator: BoxDecoration(
        //             //     color: const Color(0x193D6DF5),
        //             //     borderRadius: BorderRadius.circular(
        //             //       15.h,
        //             //     ),
        //             //   ),
        //             //   tabs: [
        //             //     // Container(
        //             //     //   // width: 96.80,
        //             //     //   // height: 30,
        //             //     //   padding: const EdgeInsets.symmetric(horizontal: 5.0),
        //             //     //   decoration: ShapeDecoration(
        //             //     //     // color: const Color(0x193D6DF5),
        //             //     //     shape: RoundedRectangleBorder(
        //             //     //       borderRadius: BorderRadius.circular(22),
        //             //     //       side: BorderSide(
        //             //     //         width: 1,
        //             //     //         color: Colors.black
        //             //     //             .withOpacity(0.10000000149011612),
        //             //     //       ),
        //             //     //     ),
        //             //     //   ),
        //             //     //   child: const Center(
        //             //     //     child: Text(
        //             //     //       "Tokens",
        //             //     //     ),
        //             //     //   ),
        //             //     // ),
        //             //     // const Tab(
        //             //     //   child: Text(
        //             //     //     "Tokens",
        //             //     //   ),
        //             //     // ),
        //             //     // Tab(
        //             //     //   child: Text(
        //             //     //     "Transactions",
        //             //     //   ),
        //             //     // ),

        //             //     Container(
        //             //       // width: 96.80,
        //             //       // height: 30,
        //             //       padding: const EdgeInsets.symmetric(horizontal: 5.0),
        //             //       decoration: ShapeDecoration(
        //             //         // color: const Color(0x193D6DF5),
        //             //         shape: RoundedRectangleBorder(
        //             //           borderRadius: BorderRadius.circular(22),
        //             //           side: BorderSide(
        //             //             width: 1,
        //             //             color: Colors.black
        //             //                 .withOpacity(0.10000000149011612),
        //             //           ),
        //             //         ),
        //             //       ),
        //             //       child: const Center(
        //             //         child: Text(
        //             //           "Transactions",
        //             //         ),
        //             //       ),
        //             //     ),
        //             //   ],
        //             // ),
        //           ),
        //           const Expanded(child: WalletLowBalancePage()),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  /// Section Widget
  // Widget _MyTokenCard(BuildContext context) {
  //   final coachToken = ref.watch(transcationHistoryProvider
  //       .select((value) => value.coachProfileDetailsModel));

  //   return Align(
  //     alignment: Alignment.center,
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 20.h),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadiusStyle.roundedBorder5,
  //           // border: Border.all(width: 0.5.h, ),
  //           color: Colors.white,
  //           boxShadow: const [
  //             BoxShadow(
  //               color: Colors.grey,
  //               blurRadius: 5.0,
  //             ),
  //           ]),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           Padding(
  //             padding: EdgeInsets.only(bottom: 13.v),
  //             child: Column(
  //               children: [
  //                 Container(
  //                   width: 172.h,
  //                   padding: EdgeInsets.symmetric(
  //                     horizontal: 19.h,
  //                     vertical: 14.v,
  //                   ),
  //                   // decoration: AppDecoration.outlineGray.copyWith(
  //                   //   borderRadius: BorderRadiusStyle.customBorderBR10,
  //                   // ),
  //                   child: Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Align(
  //                         alignment: Alignment.center,
  //                         child: Text(
  //                           "Your Token Balance",
  //                           style: CustomTextStyles.titleSmallBlack900_1,
  //                         ),
  //                       ),
  //                       SizedBox(height: 7.v),
  //                       CustomOutlinedButton(
  //                         height: 28.v,
  //                         width: 73.h,
  //                         text: "${coachToken.token ?? 0}",
  //                         buttonTextStyle: TextStyle(
  //                           color: const Color(0xFF3D6DF5),
  //                           fontSize: 16.90.fSize,
  //                           fontFamily: 'Nunito Sans',
  //                           fontWeight: FontWeight.w800,
  //                           height: 0.09,
  //                         ),
  //                         rightIcon: Container(
  //                           margin: EdgeInsets.only(left: 6.h),
  //                           child: CustomImageView(
  //                             imagePath: ImageConstant.coinImage,
  //                             height: 19.v,
  //                             width: 20.h,
  //                           ),
  //                         ),
  //                         buttonStyle: CustomButtonStyles.outlinePrimary,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(height: 13.v),
  //                 Text(
  //                   "Note: 1 Token = 1 dollar",
  //                   style: CustomTextStyles.bodySmallBlack900,
  //                 ),
  //                 SizedBox(height: 6.v),
  //                 CustomElevatedButton(
  //                   height: 30.v,
  //                   width: 138.h,
  //                   text: "Withdraw Tokens",
  //                   buttonStyle: CustomButtonStyles.fillPrimaryTL15,
  //                   buttonTextStyle:
  //                       CustomTextStyles.labelLargeRobotoOnErrorContainer,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           CustomImageView(
  //             imagePath: ImageConstant.img1158241721034536,
  //             height: 152.v,
  //             width: 145.h,
  //             margin: EdgeInsets.only(
  //               left: 20.h,
  //               top: 6.v,
  //               bottom: 6.v,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  /// Section Widget
  // Widget _buildTabBarView(BuildContext context) {
  //   return SizedBox(
  //     height: 253.v,
  //     child: TabBarView(
  //       controller: tabviewController,
  //       children: const [
  //         WalletLowBalancePage(),
  //         // TranscationPageCoach(),
  //       ],
  //     ),
  //   );
  // }
}
