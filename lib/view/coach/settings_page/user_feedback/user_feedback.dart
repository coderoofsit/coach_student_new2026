import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/view/coach/settings_page/setting_provider/setting_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/utils.dart';
import '../../../../widgets/custom_app_bar_student.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_text_form_field.dart';

class UserFeedbackScreen extends ConsumerWidget {
  UserFeedbackScreen({super.key});

  TextEditingController titleController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
        settingCoachProvider.select((value) => value.userFeedbackLoading));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        // final
        appBar: const CustomAppBarStudent(title: 'User feedback'),
      body: Form(
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
                    "Title",
                    style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                  ),
                ),
              ),
              SizedBox(height: 4.v),
              CustomTextFormField(
                controller: titleController,
                hintText: "Title ",
                validator: (val){
                  if(val!.isEmpty){
                    return "Message cannot be empty";
                  }else{
                    return null;
                  }
                },
              ),
              SizedBox(height: 18.v),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 7.h),
                  child: Text(
                    "Message",
                    style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                  ),
                ),
              ),
              SizedBox(height: 4.v),
               CustomTextFormField(
                 controller: msgController,
                hintText: "Message ",
                maxLines: 5,

                validator: (val){
                  if(val!.isEmpty){
                    return "Message cannot be empty";
                  }else{
                    return null;
                  }
                },
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
              const Spacer(),
              SafeArea(
                child: isLoading ? Utils.progressIndicator : CustomElevatedButton(
                  onPressed: (){
                    if( _formKey.currentState!.validate()){
                      ref.read(settingCoachProvider).userFeedback(context, title: titleController.text, message: msgController.text);
                    }
                  },
                  text: "Send",
                ),
              ),
              SizedBox(height: 10.v),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
