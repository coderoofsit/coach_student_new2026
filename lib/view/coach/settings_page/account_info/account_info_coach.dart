import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/provider/coach/coach_profile_provider.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';

import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountInfoScreenCoach extends ConsumerStatefulWidget {
  const AccountInfoScreenCoach({super.key});

  @override
  AccountInfoScreenCoachState createState() => AccountInfoScreenCoachState();
}

class AccountInfoScreenCoachState
    extends ConsumerState<AccountInfoScreenCoach> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // StudentProfileModel? studentProfile;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   studentProfile = SharedPreferencesManager.getStudentPorfile();

  // }

  @override
  Widget build(
    BuildContext context,
  ) {
    mediaQueryData = MediaQuery.of(context);

    final coachProfile =
        ref.watch(coachProfileProvider).coachProfileDetailsModel;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        // final
        appBar: const CustomAppBarStudent(title: 'Account Info'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.all(28.h),
            child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    "Your Name",
                    style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                  ),
                ),
              ),
              SizedBox(height: 4.v),
              CustomTextFormField(
                hintText: coachProfile.name,
                hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
                readOnly: true,
              ),
              SizedBox(height: 18.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    "Email Address",
                    style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                  ),
                ),
              ),
              SizedBox(height: 4.v),
              CustomTextFormField(
                readOnly: true,
                hintText: coachProfile.email,
                hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 18.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    "Phone Number",
                    style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                  ),
                ),
              ),
              SizedBox(height: 4.v),
              CustomTextFormField(
                readOnly: true,
                hintText: coachProfile.phoneNumber != null && coachProfile.phoneNumber != 0
                    ? coachProfile.phoneNumber.toString()
                    : "Not available",
                hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.phone,
              ),
              // const Spacer(),
              SizedBox(height: 33.v),
              // SizedBox(height: 18.v),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Padding(
              //     padding: EdgeInsets.only(left: 7.h),
              //     child: Text(
              //       "Email Address",
              //       style: CustomTextStyles.titleMediumBlack900SemiBold_2,
              //     ),
              //   ),
              // ),
              // SizedBox(height: 4.v),
              // CustomTextFormField(
              //   readOnly: true,
              //   hintText: coachProfile.email,
              //   hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
              //   textInputAction: TextInputAction.done,
              //   textInputType: TextInputType.emailAddress,
              // ),
              // // const Spacer(),
              // SizedBox(height: 33.v),

              // const CustomElevatedButton(
              //   text: "Save Changes",
              // ),
            ],
          ),
        ),
        ),
      ),
      ),
    );
  }
}
