

import 'dart:developer';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/services/api/api.dart';
import 'package:coach_student/view/student_view/add_coach/qr_code_scanner.dart';
import 'package:coach_student/widgets/custom_outlined_button.dart';
import 'package:flutter/material.dart';

import '../../../models/CoachProfileDetailsModel.dart';
import '../../../widgets/custom_app_bar_student.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../coach_profile_screen/coach_profile_screen.dart';

class AddCoachScreen extends StatefulWidget {

  AddCoachScreen({super.key});

  @override
  State<AddCoachScreen> createState() => _AddCoachScreenState();
}

class _AddCoachScreenState extends State<AddCoachScreen> {
  TextEditingController passcodeController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> getCoach(BuildContext context,String code) async {
    String finalUrl = "/coach?passcode=$code";
    setState(() {
      isLoading = true;
    });
    final result = await DioApi.get(path: finalUrl);





    if (result.response?.data != null) {

      print("coach passcode ${result.response?.data}");
      setState(() {
        isLoading = false;
      });

      CoachProfileDetailsModel coachProfile = CoachProfileDetailsModel.fromJson(result.response?.data["coaches"][0]);
      // Utils.toast(message: '${result.response?.data["message"]}');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return  CoachProfileScreen(coachProfileDetailsModel: coachProfile,);
      }));
    } else {
      setState(() {
        isLoading = false;
      });
      result.handleError(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarStudent(title: 'Add Coach'),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 18.v),
            Form(
              key: formKey,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 33.h),
                  child: Text(
                    "Enter a passcode of coach",
                    style: CustomTextStyles.titleMediumBlack900_3,
                  ),
                ),
              ),
            ),
            SizedBox(height: 14.v),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: CustomTextFormField(
                // onTap: (){},
                textInputType: TextInputType.number,
                controller: passcodeController,
                onTapOutside: (val) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                hintText: "Type the passcode here",
                validator: (value) =>
                passcodeController.text.isEmpty ? "Please Enter coach Type" : null,
              ),
            ),
            SizedBox(height: 20.v),
            const Text(
              'or',
              style: TextStyle(
                color: Color(0xFF828282),
                fontSize: 16,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w600,
                height: 0.09,
                letterSpacing: -0.35,
              ),
            ),
            SizedBox(height: 20.v),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomOutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const QrCodeScanner(),
                    ),
                  );
                },
                text: "Scan QR code",
                buttonTextStyle: const TextStyle(
                  color: Color(0xFF3D6DF5),
                  fontSize: 16,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
            ),
            const Spacer(),
           isLoading ? Utils.progressIndicator : CustomElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  log("isLoading == ${isLoading.toString()}");
                  getCoach(context,passcodeController.text);
                }
              },
              text: "Next",
              margin: EdgeInsets.only(
                left: 30.h,
                right: 28.h,
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
