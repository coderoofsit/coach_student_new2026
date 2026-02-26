import 'dart:developer';
import 'package:coach_student/services/paypal_service.dart';
import 'package:coach_student/services/payment_deeplink_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:coach_student/view/student_view/settings_page/widgets/SelectStudentItem.dart';
import 'package:coach_student/view/student_view/settings_page/widgets/add_student.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_student/SharedPref/Shared_pref.dart';
import '../../../core/utils/utils.dart';
import '../../../provider/coach/TranscationHistoryProvider.dart';
import '../../../provider/student_provider/payment_provider.dart';
import '../../../provider/student_provider/settings_provider.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/dialogs.dart';
import 'about_us/about_us_screen.dart';
import 'account_info/account_info_student.dart';
import 'change_password_screen/change_password_screen.dart';
import 'contact_us_screen/contact_us_screen.dart';
import 'delete_account_screen/delete_account_one_screen.dart';
import 'faq_screen/faq_screen.dart';
import 'legal_policies_screen/legal_policies_screen.dart';
import 'my_profile_student/my_profile_student.dart';
import 'package:coach_student/core/app_export.dart';

import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class SettingsStudentPage extends ConsumerStatefulWidget {
  const SettingsStudentPage({Key? key}) : super(key: key);

  @override
  SettingsStudentPageState createState() => SettingsStudentPageState();
}

class SettingsStudentPageState extends ConsumerState<SettingsStudentPage>
    with AutomaticKeepAliveClientMixin {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  // PayPal Service
  final PayPalService _payPalService = PayPalService();
  
  // Track if data has been loaded
  bool _hasLoadedData = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    
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
        ref.watch(studentSettingProvider).setStudent();
        ref.watch(studentSettingProvider).getAllStudentList();
      }
    });
  }

  Future<void> _handlePayPalSuccess(Uri uri) async {
    print("=== SettingsStudentPage: HandlePayPalSuccess called with URI: $uri ===");
    // Backend handles capture and fulfillment. Refresh UI.

    final amount = uri.queryParameters['amount'];

    if (amount != null) {
      print("=== SettingsStudentPage: Showing toast for amount: $amount ===");
      Utils.toast(message: "Payment successful: \$ $amount");
    } else {
      print("=== SettingsStudentPage: Showing toast without amount ===");
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    
    // Load data when widget is built (i.e., when tab is opened)
    _loadDataIfNeeded();
    
    final settingProvider = ref.watch(studentSettingProvider);

    mediaQueryData = MediaQuery.of(context);

    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 0.v),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.h,
              right: 20.h,
              bottom: 5.v,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                settingProvider.studentList == null
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Student's Information",
                          style: CustomTextStyles.titleLargeBlack900,
                        ),
                      ),
                settingProvider.studentList == null
                    ? const SizedBox()
                    : SizedBox(height: 15.v),

                // student section
                if (settingProvider.studentList == null)
                  const SizedBox()
                else
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            (settingProvider.studentList!.users.length + 1),
                        itemBuilder: (context, items) {
                          final itemLength =
                              settingProvider.studentList!.users.length;
                          if ((items == itemLength)) {
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return const AddStudentWidget();
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return const AddStudentWidget();
                                          }));
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey.shade100,
                                          radius: 30.adaptSize,
                                          child: CustomImageView(
                                            imagePath: ImageConstant
                                                    .imgFramePrimary50x50 ??
                                                "",
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8.v),
                                      Text(
                                        'Add student',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.fSize,
                                          fontFamily: 'Nunito Sans',
                                          fontWeight: FontWeight.w700,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            );
                          } else {
                            var user =
                                settingProvider.studentList?.users[items];
                            return SelectStudentItem(
                              isSelected:
                                  settingProvider.selectedStudentUser.id ==
                                      user?.id,
                              user: user!,
                              onTap: () {
                                settingProvider.setSelectedStudent(user);
                                print(
                                    "selected student == ${settingProvider.selectedStudentUser.id == user.id}");

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const MyProfileStudent(),
                                  ),
                                );
                              },
                            );
                          }
                        }),
                  ),

                settingProvider.studentList == null
                    ? const SizedBox()
                    : SizedBox(height: 24.v),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Payment settings",
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
                                      color: Colors.black, fontSize: 16.fSize),
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
                  child: _buildConnect(context),
                ),
                SizedBox(height: 19.v),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Settings",
                    style: CustomTextStyles.titleLargeBlack900,
                  ),
                ),
                settingProvider.studentList == null
                    ? const SizedBox()
                    : SizedBox(height: 13.v),
                settingProvider.studentList == null
                    ? const SizedBox()
                    : _buildIconoiruser(context, settingProvider),
                SizedBox(height: 15.v),
                _buildAccountInformation(context),
                // SizedBox(height: 15.v),
                // _buildVector(context),
                SizedBox(height: 15.v),
                _buildPassword(context),
                SizedBox(height: 15.v),
                _buildContactUs(context),
                SizedBox(height: 15.v),
                _buildAboutUS(context),
                SizedBox(height: 15.v),
                _buildLegalPolicies(context),
                SizedBox(height: 15.v),
                _buildFaq(context),
                SizedBox(height: 15.v),
                _buildAntdesigndeleteoutlined(context),
                SizedBox(height: 15.v),
                _buildLogout(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildConnect(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadiusStyle.roundedBorder5,
      ),
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
                  children: [
                    Text(
                      "Buy more tokens",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.fSize,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                        // height: 0.09,
                        // letterSpacing: -0.35,
                      ),
                    ),
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
                  'For adding funds to your account',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.6000000238418579),
                    fontSize: 12.fSize,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w600,
                    height: 0.12,
                    letterSpacing: -0.26,
                  ),
                )
              ],
            ),
          ),
          const Spacer(),
          CustomImageView(
            imagePath: ImageConstant.imgFrame,
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
    );
  }

  /// Section Widget
  Widget _buildIconoiruser(
      BuildContext context, StudentSettingProvider settingProvider) {
    return CustomTextFormField(
      readOnly: true,
      hintText:
          "${settingProvider.selectedStudentUser.name ?? SharedPreferencesManager.getStudentPorfile()?.name} information",
      onTap: () {
        log("Tap ");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MyProfileStudent(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(15.h, 12.v, 12.h, 13.v),
        child: Icon(
          Icons.settings_outlined,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildAccountInformation(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountInfoScreenStudent(),
          ),
        );
      },
      hintText: "Account information",
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(17.h, 14.v, 14.h, 15.v),
        child: Icon(
          Icons.account_circle_outlined,
          size: 21.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  // Widget _buildVector(BuildContext context) {
  //   return CustomTextFormField(
  //     readOnly: true,
  //     onTap: () {
  //       log("Tap ");
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const StarredAccountsStudentScreen(),
  //         ),
  //       );
  //     },
  //     hintText: "Starred Accounts",
  //     hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
  //     prefix: Container(
  //       margin: EdgeInsets.fromLTRB(17.h, 14.v, 13.h, 14.v),
  //       child: CustomImageView(
  //         imagePath: ImageConstant.imgVector,
  //         height: 20.v,
  //         width: 21.h,
  //       ),
  //     ),
  //     prefixConstraints: BoxConstraints(
  //       maxHeight: 50.v,
  //     ),
  //     contentPadding: EdgeInsets.only(
  //       top: 12.v,
  //       right: 30.h,
  //       bottom: 12.v,
  //     ),
  //     borderDecoration: TextFormFieldStyleHelper.fillGray,
  //     filled: true,
  //     fillColor: appTheme.gray5001,
  //   );
  // }

  /// Section Widget
  Widget _buildPassword(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChangePasswordStudentScreen(),
          ),
        );
      },
      hintText: "Change password",
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      textInputType: TextInputType.visiblePassword,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(18.h, 14.v, 13.h, 15.v),
        child: Icon(
          Icons.lock_outline,
          size: 21.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      obscureText: true,
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildAntdesigndeleteoutlined(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DeleteAccountStudentScreen(),
          ),
        );
      },
      hintText: "Delete account",
      hintStyle: theme.textTheme.titleMedium!.copyWith(
        color: appTheme.red900,
        fontSize: 18.fSize,
        fontWeight: FontWeight.w600,
      ),
      prefix: Container(
        margin: EdgeInsets.fromLTRB(17.h, 13.v, 12.h, 14.v),
        child: CustomImageView(
          imagePath: ImageConstant.imgAntdesigndeleteoutlined,
          color: appTheme.red900,
          height: 23.adaptSize,
          width: 23.adaptSize,
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  Widget _buildLogout(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "Logout",
      onTap: () async {
        final bool? isLogout = await Dialogs.logoutDialog(context);

        if (isLogout == true) {
          SharedPreferencesManager.clearStudentList();
          SharedPreferencesManager.clearPref();

          Navigator.popUntil(context, (route) => route.isFirst);

          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.selectCoachOrStudentOneScreen,
            (route) => false,
          );
        }
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
          margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
          child: Icon(
            Icons.logout,
            size: 25.adaptSize,
            color: Colors.grey[600],
          )),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  Widget _buildAboutUS(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "About us",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AboutUsStudentScreen(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.info_outline,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildContactUs(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "Contact Us",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ContactUsStudentScreen(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.phone_outlined,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildLegalPolicies(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "Legal & Policies",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LegalPoliciesScreen(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.gavel,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }

  /// Section Widget
  Widget _buildFaq(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      hintText: "FAQ",
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FaqScreen(),
          ),
        );
      },
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold18,
      prefix: Container(
        margin: EdgeInsets.fromLTRB(16.h, 13.v, 11.h, 12.v),
        child: Icon(
          Icons.help_outline,
          size: 25.adaptSize,
          color: Colors.grey[600],
        ),
      ),
      prefixConstraints: BoxConstraints(
        maxHeight: 50.v,
      ),
      contentPadding: EdgeInsets.only(
        top: 12.v,
        right: 30.h,
        bottom: 12.v,
      ),
      borderDecoration: TextFormFieldStyleHelper.fillGray,
      filled: true,
      fillColor: appTheme.gray5001,
    );
  }
}
