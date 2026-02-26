import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/CoachChatModel.dart';
import 'package:coach_student/provider/student_provider/student_home_provider.dart';
import 'package:coach_student/view/student_view/coach_profile_screen/get_all_coaches_screen.dart';
import 'package:flutter/material.dart';
// Imports
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:coach_student/services/paypal_service.dart';
import 'package:coach_student/services/payment_deeplink_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../provider/coach/TranscationHistoryProvider.dart';
import '../../../provider/coach/coach_notification_provider.dart';
import '../../../provider/student_provider/payment_provider.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_search_view.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../add_coach/add_coach.dart';
import '../student_chat/chats_page/chats_page.dart';
import '../student_class/my_classes_page/widgets/myclasses_item_widget.dart';
import '../student_class/my_classes_tab_student/my_classes_tab_student.dart';

class HomeStudentScreen extends ConsumerStatefulWidget {
  const HomeStudentScreen({Key? key})
      : super(
          key: key,
        );

  @override
  HomeStudentScreenState createState() => HomeStudentScreenState();
}

class HomeStudentScreenState extends ConsumerState<HomeStudentScreen>
    with TickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late TabController tabviewController;

  // PayPal Service
  final PayPalService _payPalService = PayPalService();

  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 4, vsync: this);

    // Initialize deep link handler (singleton)
    PaymentDeepLinkHandler.instance.initialize(
      onPaymentSuccess: _handlePayPalSuccess,
      onPaymentCancel: () {
        if (mounted) Utils.toast(message: "Payment canceled");
      },
      onPaymentFailed: () {
        if (mounted) Utils.toast(message: "Payment failed");
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final studentHomeProvider = ref.watch(homeStudentNotifier);
      ref.read(notificationCoachProvider).getNotifcationCount(context);

      studentHomeProvider.getCoachClassesList(context);
      studentHomeProvider.getCoachesList(context);
    });
  }

  Future<void> _handlePayPalSuccess(Uri uri) async {
    print("=== HomeStudentScreen: HandlePayPalSuccess called with URI: $uri ===");
    
    // Backend handles capture and db update. We just refresh UI.
    final amount = uri.queryParameters['amount'];

    if (amount != null) {
      print("=== HomeStudentScreen: Showing toast for amount: $amount ===");
      Utils.toast(message: "Payment successful: \$ $amount");
    } else {
      print("=== HomeStudentScreen: Showing toast without amount ===");
      Utils.toast(message: "Payment successful");
    }

    if (mounted) {
      ref.read(paymentsHistoryStudentProvider).getPaymentHistory();
      ref.read(transcationHistoryProvider).getTranscationListCoach(context);
    }
  }

  Future<void> _startPayPalPayment(String amount) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: Utils.progressIndicator),
    );

    final approvalUrl = await _payPalService.createBackendOrder(amount: amount);

    // Hide loading dialog
    if (mounted && Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    if (approvalUrl != null) {
      await launchUrl(Uri.parse(approvalUrl),
          mode: LaunchMode.externalApplication);
    } else {
      Utils.toast(message: "Failed to create PayPal payment");
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final studentHomeProvider = ref.watch(homeStudentNotifier);
    // studentHomeProvider.getCoachesList(context);
    // studentHomeProvider.getCoachClassesList(context);
    return Scaffold(
      body: studentHomeProvider.isLoading
          ? Utils.progressIndicator
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  final studentHomeProvider = ref.read(homeStudentNotifier);
                  await Future.wait([
                    studentHomeProvider.getCoachClassesList(context),
                    studentHomeProvider.getCoachesList(context),
                    ref
                        .read(notificationCoachProvider)
                        .getNotifcationCount(context),
                  ]);
                },
                child: Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.symmetric(
                    horizontal: 19.h,
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // _SearchBar(context),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            studentHomeProvider.coachesList.isEmpty
                                ? Column(
                                    children: [
                                      SizedBox(height: 10.v),
                                      const Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'My coaches',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: 'Nunito Sans',
                                            fontWeight: FontWeight.w700,
                                            height: 0.07,
                                            letterSpacing: -0.44,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20.v),
                                      Container(
                                        width: double.infinity,
                                        height: 206.adaptSize,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFF8FAFF),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 1,
                                                color: Color(0xFFD8E2FD)),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CustomImageView(
                                                  imagePath:
                                                      ImageConstant.addPlusIcon,
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                AddCoachScreen()));
                                                  },
                                                ),
                                                Text(
                                                  "Add New Coach",
                                                  style: CustomTextStyles
                                                      .titleLargeBlack900Bold,
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  child: Divider(
                                                    color: Color(0xFFAFAFAF),
                                                  ),
                                                ),
                                                Text(
                                                  'Looks like you haven’t added any coach yet.\nClick + to get started.',
                                                  style: TextStyle(
                                                    color: Colors.black
                                                        .withOpacity(0.75),
                                                    fontSize: 14,
                                                    fontFamily: 'Nunito Sans',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),

                            studentHomeProvider.coachClassesList.isEmpty
                                ? const SizedBox()
                                : InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      print("this is working === ");
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const MyClassesTabStudent();
                                      }));
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20.v),
                                          Column(
                                            children: [
                                              const Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'Upcoming classes',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontFamily: 'Nunito Sans',
                                                    fontWeight: FontWeight.w700,
                                                    height: 0.07,
                                                    letterSpacing: -0.44,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: const Align(
                                                  alignment: Alignment.topRight,
                                                  child: Text(
                                                    'View all',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Nunito Sans',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0.07,
                                                      letterSpacing: -0.44,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10.v),
                                        ],
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 14.v),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: studentHomeProvider
                                            .coachClassesList.length <
                                        2
                                    ? studentHomeProvider
                                        .coachClassesList.length
                                    : 2,
                                itemBuilder: (context, item) {
                                  final CoachData = studentHomeProvider
                                      .coachClassesList[item];
                                  print("Date time == ${DateTime.now()}");
                                  return MyclassesItemWidget(
                                    coachData: CoachData,
                                  );
                                }),

                            studentHomeProvider.coachClassesList.isEmpty
                                ? Column(
                                    children: [
                                      SizedBox(height: 20.v),
                                      const Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'Upcoming classes',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Nunito Sans',
                                                fontWeight: FontWeight.w700,
                                                height: 0.07,
                                                letterSpacing: -0.44,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(height: 20.v),
                                      _buildNoUpcomingClasses(context, () {}),
                                    ],
                                  )
                                : const SizedBox(),

                            studentHomeProvider.coachesList.isEmpty
                                ? const SizedBox()
                                : SizedBox(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 20.v),
                                        Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return const GetAllCoaches();
                                                }));
                                              },
                                              child: const Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'My coaches',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 20,
                                                      fontFamily: 'Nunito Sans',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      height: 0.07,
                                                      letterSpacing: -0.44,
                                                    ),
                                                  ),
                                                  Text(
                                                    'View all',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily: 'Nunito Sans',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0.07,
                                                      letterSpacing: -0.44,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 19.v),
                                            ListView.builder(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: studentHomeProvider
                                                          .coachesList.length <
                                                      5
                                                  ? studentHomeProvider
                                                      .coachesList.length
                                                  : 5,
                                              itemBuilder: (context, index) {
                                                final coachData =
                                                    studentHomeProvider
                                                        .coachesList[index];
                                                return GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(
                                                    //     context,
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) =>
                                                    //             const CalenderStudent(),),);

                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            ChatsPageStudent(
                                                          user: CoachChatModel(
                                                            userId:
                                                                coachData.id ??
                                                                    "",
                                                            name: coachData
                                                                    .name ??
                                                                "",
                                                            imageUrl: coachData
                                                                    .image
                                                                    ?.url ??
                                                                "",
                                                            isRead: false,
                                                            coachType: coachData
                                                                .coachType
                                                                .toString(),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: _CoachesCard(
                                                    context,
                                                    profilePic:
                                                        coachData.image?.url ??
                                                            "",
                                                    typeCoach:
                                                        coachData.coachType ??
                                                            "",
                                                    nameCoach:
                                                        coachData.name ?? "",
                                                    changes: coachData
                                                        .chargePerHour
                                                        .toString(),
                                                  ),
                                                );
                                              },
                                            ),
                                            SizedBox(height: 10.v),
                                            CustomElevatedButton(
                                              text: "Add new coach",
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return AddCoachScreen();
                                                }));
                                              },
                                            ),
                                          ],
                                        ),
                                        const Gap(10),
                                      ],
                                    ),
                                  ),
                            Column(
                              children: [
                                // Align(
                                //   alignment: Alignment.centerLeft,
                                //   child: Text(
                                //     "Refper a Friend",
                                //     style:
                                //         CustomTextStyles.titleLargeBlack900Bold,
                                //   ),
                                // ),
                                SizedBox(height: 13.v),
                                // _buildReferNowColumn(context),
                                // SizedBox(height: 35.v),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Payments",
                                    style: CustomTextStyles.titleLargeBlack900,
                                  ),
                                ),
                                SizedBox(height: 10.v),
                                GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Payment'),
                                            content: Form(
                                              key: formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CustomTextFormField(
                                                    controller:
                                                        _amountController,
                                                    hintText:
                                                        "Please enter an amount.",
                                                    textInputType:
                                                        TextInputType.number,
                                                    validator: (val) => val!
                                                            .isEmpty
                                                        ? 'Please enter valid  amount .'
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
                                                    String amount =
                                                        _amountController.text;
                                                    _amountController.clear();

                                                    // Start PayPal Payment
                                                    _startPayPalPayment(amount);
                                                  }
                                                },
                                                // text: 'Submit',
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: _buildConnectRow(context)),
                              ],
                            ),
                            // const HomeStudentWidget()
                            // _buildTabview(context),
                            // _buildTabBarView(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  /// Section Widget
  Widget _SearchBar(BuildContext context) {
    return SizedBox(
      height: 50.v,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.h),
        child: CustomSearchView(
          controller: searchController,
          hintText: "Search for subject, coach...",
          borderDecoration: SearchViewStyleHelper.outlineBlack,
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildNoUpcomingClasses(BuildContext context, Function() onPressed) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const MyClassesTabStudent()));
      },
      child: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 19.h,
                vertical: 10.v,
              ),
              decoration: AppDecoration.outlinePrimary.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomImageView(
                    imagePath: ImageConstant.imgGroup2297,
                    height: 31.adaptSize,
                    width: 31.adaptSize,
                    margin: EdgeInsets.symmetric(vertical: 4.v),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 21.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "No upcoming classes",
                          style: CustomTextStyles.titleMediumBlack900_2,
                        ),
                        SizedBox(height: 1.v),
                        Text(
                          "Check the previous classes, If any !",
                          style: CustomTextStyles.labelLarge_1,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  CustomImageView(
                    imagePath: ImageConstant.forwardIcon,
                    height: 25.adaptSize,
                    width: 25.adaptSize,
                    margin: EdgeInsets.symmetric(vertical: 7.v),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildTabview(BuildContext context) {
    return SizedBox(
      height: 30.v,
      width: 369.h,
      child: TabBar(
        controller: tabviewController,
        isScrollable: true,
        labelColor: theme.colorScheme.primary,
        labelStyle: TextStyle(
          fontSize: 13.200000762939453.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: appTheme.black900.withOpacity(0.8),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.200000762939453.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        indicator: BoxDecoration(
          color: const Color(0x193D6DF5),
          borderRadius: BorderRadius.circular(
            15.h,
          ),
        ),
        tabs: [
          Container(
            // width: 96.80,
            // height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: ShapeDecoration(
              // color: const Color(0x193D6DF5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.10000000149011612),
                ),
              ),
            ),
            child: const Center(
              child: Text(
                "All Coaches",
              ),
            ),
          ),
          Container(
            // width: 96.80,
            // height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: ShapeDecoration(
              // color: const Color(0x193D6DF5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.10000000149011612),
                ),
              ),
            ),
            child: const Center(
              child: Text(
                "Sports",
              ),
            ),
          ),
          Container(
            // width: 96.80,
            // height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: ShapeDecoration(
              // color: const Color(0x193D6DF5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.10000000149011612),
                ),
              ),
            ),
            child: const Center(
              child: Text(
                "Education",
              ),
            ),
          ),
          Container(
            // width: 96.80,
            // height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: ShapeDecoration(
              // color: const Color(0x193D6DF5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
                side: BorderSide(
                  width: 1,
                  color: Colors.black.withOpacity(0.10000000149011612),
                ),
              ),
            ),
            child: const Center(
              child: Text(
                "Gymnastics",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _CoachesCard(
    BuildContext context, {
    required String profilePic,
    required String typeCoach,
    required String nameCoach,
    required String changes,
  }) {
    mediaQueryData = MediaQuery.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.outlineBlack.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
      child: SingleChildScrollView(
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
                  Row(
                    children: [
                      Text(
                        typeCoach,
                        style: theme.textTheme.labelLarge,
                      ),
                      // _buildHour(
                      //   context,
                      //   timeLabel: changes,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
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
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Section Widget
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

  /// Section Widget
  Widget _buildConnectRow(BuildContext context) {
    return Container(
      // width: 350.h,
      height: 63.v,
      padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.v),
      decoration: ShapeDecoration(
        color: Colors.white,
        shadows: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5.0,
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Center(
        child: Row(
          children: [
            CustomImageView(
              imagePath: ImageConstant.paypalLogo,
              height: 43.adaptSize,
              width: 43.adaptSize,
              radius: BorderRadius.circular(
                3.h,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 19.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Buy more tokens",
                        style: CustomTextStyles.titleMediumBlack900_2,
                      ),
                      // const Text(
                      //   "PayPal",
                      // ),
                      // CustomImageView(
                      //   imagePath: ImageConstant.imgStripeLogo21,
                      //   height: 17.v,
                      //   width: 42.h,
                      //   margin: EdgeInsets.only(
                      //     left: 5.h,
                      //     top: 2.v,
                      //     bottom: 2.v,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 3.v),
                  Text(
                    "For adding funds to your account",
                    style: CustomTextStyles.labelLarge_1,
                  ),
                ],
              ),
            ),
            const Spacer(),
            CustomImageView(
              imagePath: ImageConstant.imgArrowRight,
              height: 24.adaptSize,
              width: 24.adaptSize,
              margin: EdgeInsets.only(
                top: 9.v,
                right: 10.h,
                bottom: 10.v,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHour(
    BuildContext context, {
    required String timeLabel,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Text(
              "  $timeLabel",
              style: CustomTextStyles.labelLargeSecondaryContainer,
            ),
            Text(
              "/hour",
              style: CustomTextStyles.labelLargeBold_1,
            ),
          ],
        ),
        CustomImageView(
          imagePath: ImageConstant.coinImage,
          height: 14.adaptSize,
          width: 14.adaptSize,
          alignment: Alignment.topLeft,
          margin: EdgeInsets.only(left: 10.h),
        ),
      ],
    );
  }
}
