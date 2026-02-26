import 'dart:developer';
import 'dart:io';

import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/view/Auth/AuthProvider/AuthProvider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_icon_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/terms_condition_page.dart';

class RegisterCoach extends ConsumerStatefulWidget {
  final String password;
  final String email;
  final String userType;

  const RegisterCoach(
      {required this.email,
      required this.password,
      required this.userType,
      Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<RegisterCoach> createState() => _RegisterCoachConsumerState();
}

class _RegisterCoachConsumerState extends ConsumerState<RegisterCoach> {
  TextEditingController nameController = TextEditingController();

  TextEditingController professionController = TextEditingController();

  // TextEditingController textEditingController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController tokenController = TextEditingController();

  TextEditingController aboutController = TextEditingController();

  bool close = false;

  bool isChecked = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  // bool isPhoneNumberValid(String phoneNumber) {
  //   // Define a regular expression pattern for a valid phone number
  //   RegExp regExp = RegExp(r'^[0-9]{10,}$');

  //   // Check if the phone number matches the pattern
  //   return regExp.hasMatch(phoneNumber);
  // }

  String? selectedGender;

  @override
  void dispose() {
    nameController.dispose();
    professionController.dispose();
    phoneController.dispose();
    tokenController.dispose();
    aboutController.dispose();
    // enterhisherAgeController.dispose();
    super.dispose();
  }

  // final double _minValue = 0;
  // final double _maxValue = 100;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    log("user Type : ${widget.userType}");

    return Scaffold(
      body: GestureDetector(
        onTap: (){
          
        },
        child: SafeArea(
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
                        "Coach Info",
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
                        "Please provide coach information.",
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
                        "Phone number",
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
                        "Coach type",
                        style: CustomTextStyles.titleMediumBlack900_3,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.v),
                  _coachType(context),
                  SizedBox(height: 18.v),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: 33.h),
                  //     child: Text(
                  //       "Token",
                  //       style: CustomTextStyles.titleMediumBlack900_3,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 4.v),
                  // _buildTokenPerHours(context),
                  // SizedBox(height: 18.v),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 33.h),
                      child: Text(
                        "About coach",
                        style: CustomTextStyles.titleMediumBlack900_3,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.v),
                  _buildCoachAbout(context),
                  SizedBox(height: 18.v),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: 33.h),
                  //     child: Text(
                  //       "Mailing Address",
                  //       style: CustomTextStyles.titleMediumBlack900_3,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 4.v),
                  // // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 30.h),
                  //   child: SelectAddress(
                  //     textEditingController: textEditingController,
                  //     hintText: "Enter his/her Mailing Address",
                  //     validator: (value) => value!.isEmpty
                  //         ? "Please Enter coach Mailing Address"
                  //         : null,
                  //   ),
                  // ),

                  // SizedBox(height: 18.v),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 10.h),
                  //   child: Column(
                  //     children: [
                  //       Slider(
                  //         value: _minValue,
                  //         min: 0.0,
                  //         inactiveColor: Colors.black54,
                  //         max: _maxValue,
                  //         onChanged: (double value) {
                  //           setState(() {
                  //             _minValue = value;
                  //           });
                  //         },
                  //       ),
                  //       Align(
                  //         alignment: Alignment.centerLeft,
                  //         child: Padding(
                  //           padding: EdgeInsets.only(left: 24.h),
                  //           child: Text(
                  //             "Radius in miles",
                  //             style: CustomTextStyles.titleMediumBlack900_3,
                  //           ),
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 20),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //           children: [
                  //             Text(
                  //               "${_minValue.round()}",
                  //               style: CustomTextStyles.titleMediumBlack900_3,
                  //             ),
                  //             Text(
                  //               "${_maxValue.round()}",
                  //               style: CustomTextStyles.titleMediumBlack900_3,
                  //             )
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
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
                                  arguments: {'userType': Utils.coachType});
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
        hintText: "Enter his/her first name",
      ),
    );
  }

  String? validateMobile(String? value) {
// Indian Mobile number are of 10 digit only
    // if (value == null) {
    //   return 'Please Enter valid number';
    // }
    if (value == null) {
      return 'Phone number can\'t empty';
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
  Widget _buildTokenPerHours(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
        controller: tokenController,
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        validator: (val) =>
            val!.isEmpty ? "Please Enter token per hours charges" : null,
        hintText: "Enter token per hours charges",
        textInputType: TextInputType.number,
      ),
    );
  }

  /// Section Widget
  Widget _coachType(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
        // onTap: (){},
        controller: professionController,
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
        hintText: "Ex: physics lecturer or crickter",
        validator: (value) => value!.isEmpty ? "Please Enter coach Type" : null,
      ),
    );
  }

  /// Section Widget
  Widget _buildEnterhisherAge(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
        // controller: enterhisherAgeController,
        validator: (val) => val!.isEmpty ? "Please enter gender" : null,
        hintText: "Enter his/her Age",
        textInputAction: TextInputAction.done,
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
      ),
    );
  }

  Widget _buildCoachAbout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.h),
      child: CustomTextFormField(
        controller: aboutController,
        validator: (val) => val!.isEmpty ? "Please enter about" : null,
        hintText: "About",
        maxLines: 2,
        textInputAction: TextInputAction.done,
        onTapOutside: (val) => FocusManager.instance.primaryFocus?.unfocus(),
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

                // if (textEditingController.text.isEmpty) {
                //   Utils.showSnackbarErrror(
                //       context, 'Please select address');
                //   return;
                // }

                // if (tokenController.text.isEmpty) {
                //   Utils.showSnackbarErrror(context, 'Token can\'t be empty');
                //   return;
                // }
                if (phoneController.text.isEmpty) {
                  Utils.showSnackbarErrror(
                      context, 'Phone number can\'t empty');
                  return;
                }

                // if (_minValue == 0.00) {
                //   Utils.showSnackbarErrror(context, 'Radius can\'t be 0');
                //   return;
                // }
                if (aboutController.text.isEmpty) {
                  Utils.showSnackbarErrror(context, 'Please enter about');
                  return;
                }

                // Map<String, dynamic>? latLang = await ref
                //     .read(mapProvider)
                //     .getLatLngFromAddress(textEditingController.text);

                ref.read(authNotifier).registerCoach(
                      context,
                      name: nameController.text,
                      email: widget.email,
                      password: widget.password,
                      coachType: professionController.text,
                      gender: selectedGender!,
                      userType: widget.userType,
                      file: _image,
                      // latitude: "0",
                      // longitude: "0",
                      // radius: "0",
                      about: aboutController.text,
                      chargesPerHours: "0",
                      phoneNumber: phoneController.text,
                      // address: textEditingController.text,
                    );
              }

              // if (_formKey.currentState!.validate()) {
              //   log("vale : $close");
              //   if (isChecked) {
              //     // if (close) {
              //     if (_image != null) {
              //       if (selectedGender != null) {
              //         ref.read(authNotifier).registerCoach(context,
              //             name: nameController.text,
              //             email: widget.email,
              //             password: widget.password,
              //             coachType: professionController.text,
              //             gender: selectedGender ?? "",
              //             userType: widget.userType,
              //             file: _image!);
              //       } else {
              //         Utils.showSnackbarErrror(context, "Please select Gender");
              //       }
              //     } else {
              //       Utils.showSnackbarErrror(
              //           context, "Please pick profile image");
              //     }
              //   }else{
              //        Utils.showSnackbarErrror(
              //         context,'Please accept terms and conditions');
              //   }
              //   // } else {
              //   //   Utils.showSnackbarErrror(
              //   //       context, "Please agree Terms & Conditions");
              //   // }
              // }
            },
            margin: EdgeInsets.only(
              left: 30.h,
              right: 30.h,
              bottom: 40.v,
            ),
          );
  }
}
