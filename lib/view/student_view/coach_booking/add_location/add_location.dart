import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/models/CoachProfileDetailsModel.dart';
import 'package:coach_student/view/student_view/coach_profile_screen/coach_profile_screen.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_drop_down.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/dialogs.dart';

// ignore_for_file: must_be_immutable
class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({Key? key}) : super(key: key);

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  String selctedItem = '';
  List<String> dropdownItemList = ["Item One", "Item Two", "Item Three"];

  TextEditingController nameController = TextEditingController();

  TextEditingController eightController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppBarStudent(title: '27th October'),
        body: Form(
          key: _formKey,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 29.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: 10.h),
                    child: Text(
                      'Please select time slot',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.fSize,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    )),
                SizedBox(height: 16.v),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: Container(
                    // width: 350.h,
                    height: 55.v,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.adaptSize),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                        padding: EdgeInsets.only(left: 10.h),
                        child: CustomDropDown(
                            hintText: "Select location",
                            items: dropdownItemList,
                            onChanged: (value) {
                              setState(() {
                                selctedItem = value;
                              });
                            })),
                  ),
                ),
                SizedBox(height: 22.v),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "or",
                    style: TextStyle(
                      color: const Color(0xFF828282),
                      fontSize: 16.fSize,
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w600,
                      height: 0.09,
                      letterSpacing: -0.35,
                    ),
                  ),
                ),
                SizedBox(height: 19.v),
                Padding(
                    padding: EdgeInsets.only(left: 10.h),
                    child: Text(
                      'Add new loaction',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.fSize,
                        fontFamily: 'Nunito Sans',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    )),
                SizedBox(height: 19.v),
                Padding(
                    padding: EdgeInsets.only(left: 13.h),
                    child: Text("Location Name",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_3)),
                SizedBox(height: 4.v),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    child: CustomTextFormField(
                        controller: nameController,
                        hintText: "Type the name here",
                        alignment: Alignment.center)),
                SizedBox(height: 20.v),
                Padding(
                    padding: EdgeInsets.only(left: 13.h),
                    child: Text("Google maps link",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_3)),
                SizedBox(height: 3.v),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.h),
                    child: CustomTextFormField(
                        controller: eightController,
                        hintText: "Add G-maps link here",
                        textInputAction: TextInputAction.done,
                        alignment: Alignment.center)),
                SizedBox(height: 5.v)
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildDone(context));
  }

  /// Section Widget
  Widget _buildDone(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () async {
        bool? isDone = await Dialogs.showSuccessDialog(context,
            title: '27th October, 2023',
            subtitle: 'Scheduled class successfully for above date');
        if (isDone != null && isDone) {
          Navigator.push(
            context, MaterialPageRoute(builder: (context)=>  CoachProfileScreen(coachProfileDetailsModel: CoachProfileDetailsModel(),) )
          );
        }
      },
      text: "Done",
      margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 40.v),
      buttonStyle: selctedItem.isEmpty
          ? CustomButtonStyles.fillGray
          : CustomButtonStyles.fillPrimaryTL15,
      buttonTextStyle: TextStyle(
        color: selctedItem.isEmpty ? const Color(0xFF4F4F4F) : Colors.white,
        fontSize: 16.fSize,
        fontFamily: 'Nunito Sans',
        fontWeight: FontWeight.w600,
        height: 0,
      ),
    );
  }

  /// Navigates back to the previous screen.
  onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
