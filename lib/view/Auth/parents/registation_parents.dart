import 'dart:developer';
import 'dart:io';

import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/provider/map_provider.dart';
import 'package:coach_student/view/Auth/AuthProvider/AuthProvider.dart';
import 'package:coach_student/widgets/terms_condition_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_icon_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class RegisterParents extends ConsumerStatefulWidget {
  final String password;
  final String email;
  final String userType;

  const RegisterParents(
      {required this.email,
      required this.password,
      required this.userType,
      Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<RegisterParents> createState() =>
      _RegisterParentsConsumerState();
}

class _RegisterParentsConsumerState extends ConsumerState<RegisterParents> {
  TextEditingController nameController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  TextEditingController textEditingController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  bool close = false;

  bool isChecked = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  File? _image;

  Future _getImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      
      if (pickedFile == null) {
        return; // User cancelled the picker
      }

      final croppedFile = await Utils.cropImage(context, pickedFile);
      
      if (croppedFile != null && mounted) {
        setState(() {
          _image = File(croppedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        Utils.showSnackbarErrror(context, 'Error picking image: ${e.toString()}');
      }
    }
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: () {
        profilePiccker();
        // Show a bottom sheet to choose the image source
        // showModalBottomSheet(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return SafeArea(
        //       child: Column(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           ListTile(
        //             leading: const Icon(Icons.photo_library),
        //             title: const Text('Choose from gallery'),
        //             onTap: () {
        //               Navigator.pop(context);
        //               _getImage(ImageSource.gallery);
        //             },
        //           ),
        //           ListTile(
        //             leading: const Icon(Icons.camera),
        //             title: const Text('Take a picture'),
        //             onTap: () {
        //               Navigator.pop(context);
        //               _getImage(ImageSource.camera);
        //             },
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // );
      },
      child: Container(
        height: 101.adaptSize,
        width: 101.adaptSize,
        // padding: EdgeInsets.all(30.h),
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
    );
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

  bool isPhoneNumberValid(String phoneNumber) {
    // Define a regular expression pattern for a valid phone number
    RegExp regExp = RegExp(r'^[0-9]{10,}$');

    // Check if the phone number matches the pattern
    return regExp.hasMatch(phoneNumber);
  }

  String? selectedGender;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    textEditingController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  final double _minValue = 0;
  final double _maxValue = 100;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    log("user Type : ${widget.userType}");

    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildThirtyFive(context),
                SizedBox(height: 17.v),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.h),
                    child: Text(
                      "Parent info",
                      style: theme.textTheme.headlineLarge,
                    ),
                  ),
                ),
                SizedBox(height: 4.v),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.h),
                    child: Text(
                      "Please provide parent information.",
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ),
                SizedBox(height: 34.v),
                _buildProfilePicture(),
                // Container(
                //   height: 101.adaptSize,
                //   width: 101.adaptSize,
                //   padding: EdgeInsets.all(30.h),
                //   decoration: AppDecoration.fillGray.copyWith(
                //     borderRadius: BorderRadiusStyle.roundedBorder50,
                //   ),
                //   child: CustomImageView(
                //     imagePath: ImageConstant.imgMajesticonsPlus,
                //     height: 41.adaptSize,
                //     width: 41.adaptSize,
                //     alignment: Alignment.center,
                //   ),
                // ),
                SizedBox(height: 15.v),
                GestureDetector(
                  onTap: () {
                    profilePiccker();
                  },
                  child: Text(
                    "Upload picture",
                    style: CustomTextStyles.bodyLargePrimary,
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
                SizedBox(height: 18.v),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 33.h),
                    child: Text(
                      "Phone Number",
                      style: CustomTextStyles.titleMediumBlack900_3,
                    ),
                  ),
                ),
                SizedBox(height: 4.v),
                _buildPhoneNumber(context),
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

                SizedBox(height: 18.v),
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
                SizedBox(height: 4.v),
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
                Padding(
                  padding: EdgeInsets.only(
                    left: 30.h,
                    right: 30.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          // activeColor: Colors.black,

                          checkColor: Colors.white,
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                              log("$isChecked ");
                            });
                          }),
                      Flexible(
                        child: RichText(
                          textAlign : TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "I have agree to $appName",
                                style: theme.textTheme.bodyMedium,
                              ),
                              const TextSpan(
                                text: " ",
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {

                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context){
                                        return const TermsAndCondition();
                                      })
                                    );
                                  },
                                text: "Terms & Conditions",
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                        ),
                      )
                      // Text(
                      //   "I have agree to $appName’ Terms and Conditions",
                      //   textAlign: TextAlign.center,
                      //   style: theme.textTheme.bodySmall,
                      // )
                    ],
                  ),
                ),
                SizedBox(height: 15.v),
                // SizedBox(height: 5.v),
                _buildContinue(context, ref),
              ],
            ),
          ),
        ),
      ),
      // bottomNavigationBar: _buildContinue(context),
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
          },
        ),
        Text(title),
      ],
    );
  }

  /// Section Widget
  Widget _buildThirtyFive(BuildContext context) {
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
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRoutes.loginScreen,
                                  arguments: {'userType': Utils.parentsType}
                              );
                            },
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
        controller: nameController,
        textCapitalization: TextCapitalization.words,
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        validator: (val) => val!.isEmpty ? "Please enter your name" : null,
        hintText: "Enter your full name",
      ),
    );
  }

  String? validateMobile(String? value) {
// Indian Mobile number are of 10 digit only
    // if (value == null) {
    //   return 'Please Enter valid number';
    // }
    if (value?.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else {
      return null;
    }
  }

  /// Section Widget
  Widget _buildPhoneNumber(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
        controller: phoneController,

        textInputType: const TextInputType.numberWithOptions(),
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        validator: validateMobile,
        //  isPhoneNumberValid(val!)? "Please Enetr valid number" : null,
        hintText: "Enter your phone number",
      ),
    );
  }

  /// Section Widget
  Widget _ageTextField(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
        // onTap: (){},
        textInputType: TextInputType.number,
        controller: ageController,
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        hintText: "Enter your age",
        validator: (value) => value!.isEmpty ? "Please Enter coach Type" : null,
      ),
    );
  }

  /// Section Widget
  Widget _buildContinue(BuildContext context, WidgetRef ref) {
    return ref.watch(authNotifier).isLoadingRegistation
        ? Utils.progressIndicator
        : CustomElevatedButton(
            text: "Continue",
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                log("value: $close");

                if (!isChecked) {
                  Utils.showSnackbarErrror(
                      context, 'Please accept terms and conditions');
                  return;
                }

                if (selectedGender == null) {
                  Utils.showSnackbarErrror(context, 'Please select gender');
                  return;
                }

                if (phoneController.text.isEmpty) {
                  Utils.showSnackbarErrror(
                      context, 'Phone controller can\'t empty');
                  return;
                }

                Map<String, dynamic>? latLang = await ref
                    .read(mapProvider)
                    .getLatLngFromAddress(textEditingController.text);

                ref.read(authNotifier).registrationStudent(
                      context,
                      name: nameController.text,
                      email: widget.email,
                      password: widget.password,
                      age: ageController.text,
                      gender: selectedGender!,
                      userType: widget.userType,
                      file: _image,
                      latitude: latLang?["lattitude"].toString() ?? "",
                      longitude: latLang?["longitude"].toString() ?? "",
                      radius: _minValue.toString(),
                      phoneNumber: phoneController.text,
                      address: textEditingController.text,
                    );
              }
            },
            margin: EdgeInsets.only(
              left: 30.h,
              right: 30.h,
              bottom: 40.v,
            ),
          );
  }
}
