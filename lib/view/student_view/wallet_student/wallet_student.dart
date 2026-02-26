import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:coach_student/widgets/wallet_low_balance_page/wallet_low_balance_page.dart';

import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../../models/student_profile_model.dart';

import '../../../provider/coach/TranscationHistoryProvider.dart';
import '../../../provider/student_provider/payment_provider.dart';

import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:coach_student/services/paypal_service.dart';
import 'package:coach_student/services/payment_deeplink_handler.dart';
import 'wallet_one_page.dart';

// ignore_for_file: must_be_immutable
class WalletStudent extends ConsumerStatefulWidget {
  const WalletStudent({Key? key})
      : super(
          key: key,
        );

  @override
  WalletStudentConsumerState createState() => WalletStudentConsumerState();
}

class WalletStudentConsumerState extends ConsumerState<WalletStudent>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final TextEditingController _amountController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  late TabController tabviewController;

  final PayPalService _payPalService = PayPalService();
  
  // Track if data has been loaded
  bool _hasLoadedData = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    tabviewController = TabController(length: 2, vsync: this);
    
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
  }
  
  // Load data only when page becomes visible
  void _loadDataIfNeeded() {
    if (_hasLoadedData) return;
    _hasLoadedData = true;
    
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        ref.read(transcationHistoryProvider).getTranscationListCoach(context);
        ref.read(paymentsHistoryStudentProvider).getPaymentHistory();
      }
    });
  }

  Future<void> _handlePayPalSuccess(Uri uri) async {
    print("=== WalletStudent: HandlePayPalSuccess called with URI: $uri ===");
    
    // Backend handles capture and db update. We just refresh UI.
    final amount = uri.queryParameters['amount'];
    if (amount != null) {
      print("=== WalletStudent: Showing toast for amount: $amount ===");
      Utils.toast(message: "Payment successful: \$ $amount");
    } else {
      print("=== WalletStudent: Showing toast without amount ===");
      Utils.toast(message: "Payment successful");
    }

    if (mounted) {
      ref.read(paymentsHistoryStudentProvider).getPaymentHistory();
      ref.read(transcationHistoryProvider).getTranscationListCoach(context);
    }
  }

  @override
  void dispose() {
    tabviewController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Load data when widget is built (i.e., when tab is opened)
    _loadDataIfNeeded();
    
    mediaQueryData = MediaQuery.of(context);
    final studentToken = ref.watch(transcationHistoryProvider
        .select((value) => value.studentProfileModel));
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: ref.watch(transcationHistoryProvider
                .select((value) => value.isLoadingTranscation))
            ? Utils.progressIndicator
            : Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: 20.v),
                      Padding(
                        padding: EdgeInsets.only(left: 20.h),
                        child: Text(
                          "My Balance",
                          style: CustomTextStyles.titleLargeBlack900,
                        ),
                      ),
                      SizedBox(height: 12.v),
                      _MyTokenCard(
                        context,
                        token: studentToken.token,
                        credits: studentToken.credits,
                        studentToken: studentToken,
                      ),
                      SizedBox(height: 35.v),
                      Padding(
                        padding: EdgeInsets.only(left: 20.h),
                        child: Text(
                          "History",
                          style: CustomTextStyles.titleLargeBlack900,
                        ),
                      ),
                      // SizedBox(height: 13.v),
                      Container(
                        height: 30.v,
                        width: 190.h,
                        margin: EdgeInsets.only(left: 20.h),
                        child: TabBar(
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
                                  "Transactions",
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
                                  "Used Funds",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: _buildTabBarView(context)),
                ],
              ),
      ),
    );
  }

  /// Section Widget
  Widget _MyTokenCard(BuildContext context,
      {required int token,
      required int credits,
      required StudentProfileModel studentToken}) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.h),
        decoration: AppDecoration.outlineBlack900.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
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
                    decoration: AppDecoration.outlineGray.copyWith(
                      borderRadius: BorderRadiusStyle.customBorderBR10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "My Balance",
                            style: CustomTextStyles.titleSmallBlack900_1,
                          ),
                        ),
                        SizedBox(height: 7.v),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Tokens: $token",
                                    style: TextStyle(
                                      color: const Color(0xFF3D6DF5),
                                      fontSize: 16.fSize,
                                      fontFamily: 'Nunito Sans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 4.v),
                                  Text(
                                    "Credits: $credits",
                                    style: TextStyle(
                                      color: const Color(0xFF3D6DF5),
                                      fontSize: 16.fSize,
                                      fontFamily: 'Nunito Sans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.h),
                            GestureDetector(
                              onTap: () {
                                _showCoachWiseCreditsDialog(
                                    context, studentToken);
                              },
                              child: Container(
                                padding: EdgeInsets.all(4.h),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.info_outline,
                                  size: 18.adaptSize,
                                  color: const Color(0xFF3D6DF5),
                                ),
                              ),
                            ),
                          ],
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
                    text: "Buy more tokens",
                    onPressed: () {
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
                                    controller: _amountController,
                                    hintText: "Please enter an amount.",
                                    textInputType: TextInputType.number,
                                    validator: (val) => val!.isEmpty
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
                                  if (formKey.currentState!.validate()) {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                    String amount = _amountController.text;
                                    _amountController.clear();

                                    // Start PayPal Flow
                                    _startPayPalPayment(amount);
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    buttonStyle: CustomButtonStyles.fillPrimaryTL15,
                    buttonTextStyle:
                        CustomTextStyles.labelLargeRobotoOnErrorContainer,
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
    );
  }

  /// Section Widget
  void _showCoachWiseCreditsDialog(
      BuildContext context, StudentProfileModel studentProfile) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final creditBalance = studentProfile.creditBalance;
        final totalCredits = creditBalance.isNotEmpty
            ? creditBalance.fold<int>(
                0, (sum, entry) => sum + (entry.credit.toInt()))
            : studentProfile.credits;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Coach-wise Credits",
                      style: CustomTextStyles.titleLargeBlack900,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                SizedBox(height: 16.v),
                if (creditBalance.isEmpty || totalCredits == 0)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.v),
                    child: Center(
                      child: Text(
                        "No credits available",
                        style: CustomTextStyles.bodyMediumBlack900,
                      ),
                    ),
                  )
                else ...[
                  Text(
                    "Total Credits: $totalCredits",
                    style: TextStyle(
                      fontSize: 16.fSize,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF3D6DF5),
                    ),
                  ),
                  SizedBox(height: 16.v),
                  Container(
                    constraints: BoxConstraints(maxHeight: 300.v),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: creditBalance.length,
                      separatorBuilder: (context, index) =>
                          Divider(height: 1.v),
                      itemBuilder: (context, index) {
                        final entry = creditBalance[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.v),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Coach Image
                              if (entry.coachId.image != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20.h),
                                  child: Image.network(
                                    entry.coachId.image!.url,
                                    width: 40.adaptSize,
                                    height: 40.adaptSize,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 40.adaptSize,
                                        height: 40.adaptSize,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          size: 24.adaptSize,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              else
                                Container(
                                  width: 40.adaptSize,
                                  height: 40.adaptSize,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 24.adaptSize,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              SizedBox(width: 12.h),
                              // Coach Name and Credits
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.coachId.name.isNotEmpty &&
                                              entry.coachId.name !=
                                                  "Unknown Coach"
                                          ? entry.coachId.name
                                          : (entry.coachId.id.isNotEmpty
                                              ? "Coach (${entry.coachId.id.length > 8 ? entry.coachId.id.substring(0, 8) : entry.coachId.id}...)"
                                              : "Unknown Coach"),
                                      style: TextStyle(
                                        fontSize: 16.fSize,
                                        fontFamily: 'Nunito Sans',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 4.v),
                                    Text(
                                      "${entry.credit.toInt()} credits",
                                      style: TextStyle(
                                        fontSize: 14.fSize,
                                        fontFamily: 'Nunito Sans',
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF3D6DF5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
                SizedBox(height: 16.v),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: const Color(0xFF3D6DF5),
                        fontSize: 16.fSize,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBarView(BuildContext context) {
    return TabBarView(
      controller: tabviewController,
      children: const [
        WalletLowBalancePage(),
        WalletOnePage(),
      ],
    );
  }

  Future<void> _startPayPalPayment(String amount) async {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: Utils.progressIndicator),
    );

    final approvalUrl = await _payPalService.createBackendOrder(amount: amount);

    // Hide loading dialog before launching browser
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
}

// Helper for GlobalKey if needed, otherwise just use a new key


