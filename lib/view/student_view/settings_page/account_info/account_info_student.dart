import 'dart:io';

import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/models/student_profile_model.dart' as stProfile;
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/utils/utils.dart';
import '../../../../provider/student_provider/settings_provider.dart';

class AccountInfoScreenStudent extends ConsumerStatefulWidget {
  const AccountInfoScreenStudent({Key? key})
      : super(
          key: key,
        );

  @override
  _AccountInfoScreenStudentState createState() =>
      _AccountInfoScreenStudentState();
}

class _AccountInfoScreenStudentState
    extends ConsumerState<AccountInfoScreenStudent> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController locationController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  stProfile.StudentProfileModel? studentProfile;
  Future _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    Utils.cropImage( context,  pickedFile).then((value) {
      if(value != null) {
        setState(() {
          image =  File(value.path);
        });
      }
    });

  }

  profilePick(
    BuildContext context,
  ) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                  setState(() {});

                  print("image ==${image!.path}");
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a picture'),
                onTap: () async {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera) ;
                  setState(() {});
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    studentProfile = SharedPreferencesManager.getStudentPorfile();
    nameController = TextEditingController(text: studentProfile?.name ?? "");
    phoneController = TextEditingController(
        text: "+1 ${studentProfile?.phoneNumber.toString() ?? ""}");
    emailController =
        TextEditingController(text: studentProfile?.email.toString() ?? "");
    ageController =
        TextEditingController(text: studentProfile?.age.toString() ?? "");
  }

  File? image;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final settingProvider = ref.watch(studentSettingProvider);

    return Scaffold(
      appBar: CustomAppBarStudent(
          title: '${SharedPreferencesManager.getStudentPorfile()?.name}'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              width: double.maxFinite,
              padding: EdgeInsets.all(28.h),
              child: SingleChildScrollView(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      profilePick(context);
                    },
                    child: Container(
                      height: 101.adaptSize,
                      width: 101.adaptSize,
                      // padding: EdgeInsets.all(30.h),
                      decoration: AppDecoration.fillGray.copyWith(
                        borderRadius: BorderRadiusStyle.roundedBorder50,
                        image: DecorationImage(
                            image: NetworkImage(
                                '${SharedPreferencesManager.getStudentPorfile()?.image?.url}'),
                            fit: BoxFit.cover),
                      ),
                      child: image != null
                          ? CircleAvatar(
                              backgroundImage: FileImage(
                                image!,
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 12.v),
                  InkWell(
                    onTap: () {
                      profilePick(context);
                    },
                    child: Text(
                      "Edit picture",
                      style: CustomTextStyles.titleMediumPrimarySemiBold_1.copyWith(
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
                        "Your name",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.v),
                  CustomTextFormField(
                    controller: nameController,
                    hintText: "Name",
                    hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
                  ),
                  SizedBox(height: 18.v),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.h),
                      child: Text(
                        "Email address",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.v),
                  CustomTextFormField(
                    readOnly: true,
                    controller: emailController,
                    hintText: "Email",
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
                        "Phone number",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.v),
                  CustomTextFormField(
                    readOnly: true,
                    controller: phoneController,
                    hintText: "Phone number",
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
                        "Age",
                        style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                      ),
                    ),
                  ),
                  SizedBox(height: 4.v),
                  CustomTextFormField(
                    controller: ageController,
                    hintText: "Age",
                    hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.phone,
                  ),

                  SizedBox(height: 33.v),

                  settingProvider.isLoading ? Utils.progressIndicator : CustomElevatedButton(
                    onPressed: () {
                      settingProvider.updateParent(context,
                        stProfile.StudentProfileModel(
                          id: studentProfile!.id,
                          email: studentProfile!.name,
                          age: int.parse(ageController.text),
                          name: nameController.text,
                          isOnline: studentProfile!.isOnline,
                          image: image != null ? stProfile.ProfileImage(url: image!.path , publicId: '') : stProfile.ProfileImage(url: "", publicId: ''),
                          latitude: studentProfile!.latitude,
                          longitude: studentProfile!.longitude,
                          password: '',
                          gender: "",
                          token: 0,
                          role: '',
                          referralCode: '',
                          radius: 0,
                          address: '',
                          phoneNumber: studentProfile!.phoneNumber,
                          verified: false,
                          createdAt: null,
                          v: 0,
                        ),
                      );
                    },
                    text: "Save changes",
                  ),
                ],
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }
}
