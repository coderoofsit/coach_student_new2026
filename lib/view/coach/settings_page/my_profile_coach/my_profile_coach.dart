import 'dart:io';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/CoachProfileDetailsModel.dart';
import 'package:coach_student/provider/coach/coach_profile_provider.dart';
import 'package:coach_student/view/coach/settings_page/setting_provider/setting_provider.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../CoachClassSchedule/new_class.dart';

class MyProfileCoach extends ConsumerStatefulWidget {
  const MyProfileCoach({Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<MyProfileCoach> createState() => _MyProfileCoachConsumerState();
}

class _MyProfileCoachConsumerState extends ConsumerState<MyProfileCoach> {
  TextEditingController nameController = TextEditingController();

  TextEditingController maleController = TextEditingController();

  TextEditingController coachTypeController = TextEditingController();
  TextEditingController coachTokenPerOurController = TextEditingController();
  TextEditingController coachAboutUsController = TextEditingController();
  File? _image;

  TimeZoneWithLocal? selectedTimeZone;
  // Initial selected value
  final List<TimeZoneWithLocal> timeZone = [
    TimeZoneWithLocal(local: "est", timeZone: 'America/New_York'),
    TimeZoneWithLocal(local: "pst", timeZone: 'America/Los_Angeles'),
    TimeZoneWithLocal(local: "cst", timeZone: 'America/Chicago'),
    TimeZoneWithLocal(local: "mst", timeZone: 'America/Denver'),
  ];



  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Some provider code that gets/sets some state
      init();
    });
  }

  Future _getImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      
      if (pickedFile == null) {
        // User cancelled the picker
        return;
      }

      if (!mounted) return;

      final croppedFile = await Utils.cropImage(context, pickedFile);
      
      if (croppedFile != null && mounted) {
        setState(() {
          _image = File(croppedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        Utils.toast(message: "Failed to pick image. Please try again.");
        logger.e("Error picking image: $e");
      }
    }
  }

  void profilePicker() {
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

  CoachProfileDetailsModel coachProfileDetailsModel =
      CoachProfileDetailsModel();

  void init() {
    ref.read(coachProfileProvider).getCoachProfile();
    coachProfileDetailsModel = ref.watch(
        coachProfileProvider.select((value) => value.coachProfileDetailsModel));
    nameController.text = coachProfileDetailsModel.name ?? "";
    maleController.text = coachProfileDetailsModel.gender ?? "";
    coachTypeController.text = coachProfileDetailsModel.coachType ?? "";
    coachTokenPerOurController.text =
        coachProfileDetailsModel.chargePerHour.toString();
    coachAboutUsController.text = coachProfileDetailsModel.about ?? "";
  }

  @override
  void dispose() {
    nameController.dispose();
    maleController.dispose();
    coachTypeController.dispose();
    coachAboutUsController.dispose();
    coachTokenPerOurController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    logger.d("id ${coachProfileDetailsModel.id}");
    // mediaQueryData = MediaQuery.of(context);
    // CoachProfileDetailsModel coachProfileDetailsModel = ref.watch(
    //     coachProfileProvider.select((value) => value.coachProfileDetailsModel));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: CustomAppBarStudent(title: coachProfileDetailsModel.name ?? ""),
      body: ref.watch(coachProfileProvider).isLoadingProfile
          ? Utils.progressIndicator
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 28.h,
                vertical: 29.v,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      profilePicker();
                    },
                    child: CircleAvatar(
                      radius: 60.adaptSize,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : NetworkImage(coachProfileDetailsModel.image?.url ??
                                  "https://github.com/coderoofsit/images/assets/141501346/9c7ede81-3218-441b-879c-682446e8b1df")
                              as ImageProvider,
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     profilePicker();
                  //   },
                  //   child: CustomImageView(
                  //     imagePath: _image?.path ?? coachProfileDetailsModel.image?.url,
                  //     height: 100.adaptSize,
                  //     width: 100.adaptSize,
                  //     fit: BoxFit.cover,
                  //     radius: BorderRadius.circular(
                  //       50.h,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 12.v),
                  GestureDetector(
                    onTap: () {
                      profilePicker();
                    },
                    child: Text(
                      "Edit Picture",
                      style: CustomTextStyles.titleMediumPrimarySemiBold_1
                          .copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 47.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.h),
                      child: Text(
                        "Name",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.v),
                  CustomTextFormField(
                    textCapitalization: TextCapitalization.words,
                    controller: nameController,
                    // ..text = coachProfileDetailsModel.name ?? "",
                    // hintText: "${coachProfileDetailsModel.name}",
                    hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
                  ),
                  SizedBox(height: 18.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.h),
                      child: Text(
                        "Gender",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.v),
                  CustomTextFormField(
                    controller: maleController
                      ..text = coachProfileDetailsModel.gender ?? "",
                    readOnly: true,
                    onTap: () {
                      Utils.toast(message: "This field can't be change");
                    },
                    // hintText: "${coachProfileDetailsModel.gender}",
                    hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
                  ),
                  SizedBox(height: 19.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.h),
                      child: Text(
                        "Coach type",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.v),
                  CustomTextFormField(
                    controller: coachTypeController
                      ..text = coachProfileDetailsModel.coachType ?? "",
                    readOnly: true,
                    onTap: () {
                      Utils.toast(message: "this field can't be change");
                    },
                    // hintText: "${coachProfileDetailsModel.coachType}",
                    hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
                    textInputAction: TextInputAction.done,
                  ),
                  // SizedBox(height: 19.v),
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: 7.h),
                  //     child: Text(
                  //       "Token charge per hour",
                  //       style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 3.v),
                  // CustomTextFormField(
                  //   controller: coachTokenPerOurController,
                  //   // ..text = coachProfileDetailsModel.token.toString(),
                  //   textInputType: TextInputType.number,
                  //   // hintText: "${coachProfileDetailsModel.chargePerHour}",
                  //   hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
                  //   textInputAction: TextInputAction.done,
                  // ),
                  SizedBox(height: 19.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.h),
                      child: Text(
                        "Time zone",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.v),

                  SizedBox(
                    width: 350,
                    height: 90,
                    child: DropdownButtonFormField<TimeZoneWithLocal>(
                      validator: (value) =>
                          value != null ? null : "This field is required",
                      value: selectedTimeZone,
                      items: timeZone
                          .map((zone) => DropdownMenuItem<TimeZoneWithLocal>(
                                value: zone,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 24.h),
                                  child: Text(
                                    zone.timeZone.toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (newZone) {
                        setState(() {
                          selectedTimeZone = newZone!;
                        });
                      },
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(
                            color: appTheme.red900,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(
                            color: appTheme.black900.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(
                            color: appTheme.black900.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.h),
                          borderSide: BorderSide(
                            color: appTheme.black900.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                      ),
                      hint: Text(coachProfileDetailsModel.timeZone ??
                          'Select Time Zone'),
                      icon: const Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.h),
                      child: Text(
                        "About us",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                      ),
                    ),
                  ),
                  SizedBox(height: 3.v),
                  CustomTextFormField(
                    controller: coachAboutUsController,

                    // ..text = coachProfileDetailsModel.about ?? "",
                    textInputType: TextInputType.text,
                    maxLines: 3,
                    // hintText: "${coachProfileDetailsModel.about}",
                    hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
                    textInputAction: TextInputAction.done,
                  ),
                  // const Spacer(),
                  SizedBox(height: 33.v),
                  _buildSaveChanges(context, ref),
                   SizedBox(height: 64.v),
                ],
              ),
            ),
      ),
    );
  }

  /// Section Widget
  // Widget _buildName(BuildContext context) {
  //   return CustomTextFormField(
  //     controller: nameController,
  //     hintText: "Golden Boi",
  //     hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
  //   );
  // }

  /// Section Widget
  // Widget _buildMale(BuildContext context) {
  //   return CustomTextFormField(
  //     controller: maleController,
  //     hintText: "${coachProfileDetailsModel.name}",",
  //     hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
  //   );
  // }

  /// Section Widget
  // Widget _buildDuration(BuildContext context) {
  //   return CustomTextFormField(
  //     controller: coachTypeController,
  //     hintText: "Cricket coach",
  //     hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
  //     textInputAction: TextInputAction.done,
  //   );
  // }

  /// Section Widget
  Widget _buildSaveChanges(BuildContext context, WidgetRef ref) {
    return ref.watch(settingCoachProvider).isUpdateProfile
        ? Utils.progressIndicator
        : CustomElevatedButton(
            onPressed: () {
              ref.read(settingCoachProvider).coachProfileUpdate(
                    context,
                    ref,
                    timeZone: selectedTimeZone?.timeZone,
                    file: _image,
                    name: nameController.text,
                    token: coachTokenPerOurController.text,
                    aboutUs: coachAboutUsController.text,
                  );
            },
            text: "Save Changes",
          );
  }
}
