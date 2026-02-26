import 'dart:developer';
import 'dart:io';

import 'package:coach_student/models/student_model.dart';
import 'package:coach_student/view/Auth/AuthProvider/AuthProvider.dart';
import 'package:flutter/material.dart';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_icon_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/utils.dart';

class StudentForm extends ConsumerStatefulWidget {
  int index;

  StudentForm({
    super.key,
    this.index = 0,
  });

  @override
  ConsumerState<StudentForm> createState() => _StudentFormConsumerState();
}

class _StudentFormConsumerState extends ConsumerState<StudentForm> {
  TextEditingController nameController = TextEditingController();

  TextEditingController maleFemaleController = TextEditingController();

  TextEditingController enterAgeController = TextEditingController();

  // TextEditingController phoneController = TextEditingController();
  String? selectedGender;

  @override
  void dispose() {
    nameController.dispose();
    maleFemaleController.dispose();
    enterAgeController.dispose();
    super.dispose();
  }

  File? _image;

  Future _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    Utils.cropImage( context,  pickedFile).then((value) {
      if(value != null) {
        setState(() {
          _image =  File(value.path);
        });
      }
    });

  }

  void someAction() {
    final authProvider = ref.read(authNotifier);

    StudentModel updatedStudentModel = StudentModel(
        name: nameController.text,
        gender: maleFemaleController.text,
        // phoneNumber: phoneController.text,
        age: int.parse(
            enterAgeController.text.isEmpty ? "0" : enterAgeController.text),
        image: _image);
    log("updated student mod == ${updatedStudentModel.toJson()}");

    authProvider.updateStudentModel(widget.index, updatedStudentModel);
  }

  void profilePiccker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 17.v),
        Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30.h),
                child: Text(
                  "Student Info",
                  style: theme.textTheme.headlineLarge,
                ),
              ),
              widget.index != 0
                  ? InkWell(
                      onTap: () {
                        if (widget.index > 0) {
                          ref
                              .read(authNotifier)
                              .removeStudentForm(widget.index);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFECECEC),
                            shape: OvalBorder(),
                          ),
                          child: Center(
                            child: CustomImageView(
                              imagePath: ImageConstant.deleteIconRed,
                            ),
                          ),
                        ),
                        // Stack(
                        //   children: [

                        //     Positioned.fill(

                        //         child: Center(child: CustomImageView(imagePath: ImageConstant.deleteIconRed,)))
                        //   ],
                        // ),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
        SizedBox(height: 4.v),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 30.h),
            child: Text(
              "Please provide Student Information.",
              style: theme.textTheme.bodyLarge,
            ),
          ),
        ),
        SizedBox(height: 34.v),
        InkWell(
          onTap: () {
            profilePiccker();
          },
          child: Container(
            height: 101.adaptSize,
            width: 101.adaptSize,
            decoration: AppDecoration.fillGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder50,
            ),
            child: _image != null
                ? CircleAvatar(
                    backgroundImage: FileImage(
                      _image!,
                      // height: 41.adaptSize,
                      // width: 41.adaptSize,
                      // fit: BoxFit.contain,
                    ),
                  )
                : CustomImageView(
                    imagePath: ImageConstant.imgMajesticonsPlus,
                    height: 41.adaptSize,
                    width: 41.adaptSize,
                    alignment: Alignment.center,
                  ),
          ),
        ),
        SizedBox(height: 15.v),
        GestureDetector(
          onTap: () {
            profilePiccker();
          },
          child: Text(
            "Upload Picture",
            style: CustomTextStyles.titleMediumPrimary18.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 32.v),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 33.h),
            child: Text(
              "Name",
              style: CustomTextStyles.titleMediumBlack900_3,
            ),
          ),
        ),
        SizedBox(height: 4.v),
        _buildName(context),
        // SizedBox(height: 18.v),
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Padding(
        //     padding: EdgeInsets.only(left: 33.h),
        //     child: Text(
        //       "Phone Number",
        //       style: CustomTextStyles.titleMediumBlack900_3,
        //     ),
        //   ),
        // ),
        // SizedBox(height: 4.v),
        // _buildPhone(context),

        // SizedBox(height: 18.v),
        SizedBox(height: 18.v),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 33.h),
            child: Text(
              "Age",
              style: CustomTextStyles.titleMediumBlack900_3,
            ),
          ),
        ),
        SizedBox(height: 4.v),
        _ageTextField(context),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 33.h),
            child: Text(
              "Gender",
              style: CustomTextStyles.titleMediumBlack900_3,
            ),
          ),
        ),
        // _buildEnterhisherAge(context),

        Padding(
          padding: EdgeInsets.only(left: 25.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              buildGenderRadio('Male', 'male'),
              const SizedBox(width: 20.0),
              buildGenderRadio('Female', 'female'),
              // Add more genders if needed
            ],
          ),
        ),
        SizedBox(height: 15.v),
        // SizedBox(height: 18.v),
        // // _buildMaleFemale1(context),
        // SizedBox(height: 39.v),
      ],
    );
  }

  /// Section Widget
  Widget _ageTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
        // onTap: (){},
        textInputType: TextInputType.number,
        controller: enterAgeController,
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        hintText: "Enter your age",
        validator: (value) => value!.isEmpty ? "Please Enter coach Type" : null,
      ),
    );
  }

  /// Section Widget
  Widget _buildTwentyFive(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      decoration: AppDecoration.fillPrimary1,
      child: Column(
        children: [
          SizedBox(height: 22.v),
          Padding(
            padding: EdgeInsets.only(right: 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(
                  height: 42.adaptSize,
                  width: 42.adaptSize,
                  padding: EdgeInsets.all(7.h),
                  child: CustomImageView(
                    imagePath: ImageConstant.imgGroup2270,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 11.v,
                    bottom: 10.v,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already user?",
                          style: theme.textTheme.bodyMedium,
                        ),
                        const TextSpan(
                          text: " ",
                        ),
                        TextSpan(
                          text: "Login",
                          style: CustomTextStyles.titleMediumPrimaryBold18,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 11.v),
        ],
      ),
    );
  }

  /// Section Widget
  Widget _buildName(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
        onChanged: (val) {
          someAction();
        },
        controller: nameController,
        hintText: "Enter his/her first name",
      ),
    );
  }

  /// Section Widget
  Widget _buildMaleFemale(BuildContext context) {
    return CustomTextFormField(
      onChanged: (val) {
        someAction();
      },
      width: 150.h,
      controller: maleFemaleController,
      hintText: "Male/Female",
    );
  }

  /// Section Widget
  Widget _buildEnterAge(BuildContext context) {
    return CustomTextFormField(
      onChanged: (val) {
        someAction();
      },
      width: 150.h,
      controller: enterAgeController,
      hintText: "Enter Age",
      textInputAction: TextInputAction.done,
    );
  }

  /// Section Widget
  Widget _buildMaleFemale1(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 3.h),
                child: Text(
                  "Gender",
                  style: CustomTextStyles.titleMediumBlack900_3,
                ),
              ),
              SizedBox(height: 4.v),
              Padding(
                padding: EdgeInsets.only(left: 25.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildGenderRadio('Male', 'male'),
                    const SizedBox(width: 20.0),
                    buildGenderRadio('Female', 'female'),
                    // Add more genders if needed
                  ],
                ),
              ),
              SizedBox(height: 15.v),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 3.h),
                  child: Text(
                    "Age",
                    style: CustomTextStyles.titleMediumBlack900_3,
                  ),
                ),
                SizedBox(height: 3.v),
                _buildEnterAge(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGenderRadio(String title, String value) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: selectedGender,
          onChanged: (String? value) {
            setState(() {
              selectedGender = value;
            });
            maleFemaleController.text = selectedGender ?? "";
            someAction();
          },
        ),
        Text(title),
      ],
    );
  }
}
