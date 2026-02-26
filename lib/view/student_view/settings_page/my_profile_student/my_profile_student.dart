import 'dart:io';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/models/student_list_model.dart' as studetModel;
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../SharedPref/Shared_pref.dart';
import '../../../../core/utils/utils.dart';
import '../../../../models/student_profile_model.dart';
import '../../../../provider/student_provider/settings_provider.dart';
import '../../../../widgets/profile_picker.dart';

class MyProfileStudent extends ConsumerStatefulWidget {
  const MyProfileStudent({Key? key})
      : super(
          key: key,
        );

  @override
  MyProfileStudentState createState() => MyProfileStudentState();
}

class MyProfileStudentState extends ConsumerState<MyProfileStudent> {

  TextEditingController nameController = TextEditingController();

  TextEditingController genderController = TextEditingController();

  TextEditingController ageController = TextEditingController();

  File? image ;

  StudentProfileModel? studentProfile ;

 void setValues()async{
   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
     setState((){
       final settingProvider = ref.watch(studentSettingProvider);
       print("Name ${settingProvider.selectedStudentUser.name ?? ""}");
       nameController = TextEditingController(
           text: settingProvider.selectedStudentUser.name ?? "");
       genderController = TextEditingController(
           text: settingProvider.selectedStudentUser.gender.toString() ?? "");
       ageController = TextEditingController(
           text: settingProvider.selectedStudentUser.age.toString() ?? "");
     });
   });

  }


  @override
  void initState() {

    super.initState();
    studentProfile = SharedPreferencesManager.getStudentPorfile();
    setValues();

  }

  profilePick(BuildContext context,) async {

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
                onTap: () async{
                  Navigator.pop(context);
                  image = await getImage(ImageSource.gallery) ?? image;
                  setState(() {

                  });

                  print("image ==${image!.path}");
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a picture'),
                onTap: () async {
                  Navigator.pop(context);
                  image = await getImage(ImageSource.camera) ?? image;
                  setState(() {
                  });

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
    mediaQueryData = MediaQuery.of(context);
    final settingProvider = ref.watch(studentSettingProvider);

    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:  CustomAppBarStudent(title: settingProvider.selectedStudentUser.name ?? ""),
      body: SafeArea(
        child: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 28.h,
            vertical: 29.v,
          ),
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
                        image: NetworkImage('${settingProvider.selectedStudentUser.image?.url}'),
                        fit: BoxFit.cover
                    ),
                  ),
                  child: image != null
                      ? CircleAvatar(
                    backgroundImage: FileImage(
                      image!,
                    ),
                  ) : null,
                ),
              ) ,
              SizedBox(height: 12.v),
              InkWell(
                onTap: (){
                  profilePick(context);
                },
                child: Text(
                  "Edit Picture",
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
                    "Buddy Name",
                    style: CustomTextStyles.titleMediumBlack900SemiBold_2,
                  ),
                ),
              ),
              SizedBox(height: 3.v),
              _buildName(context),
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
              _buildMale(context),
              SizedBox(height: 19.v),
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
              SizedBox(height: 3.v),
              _buildDuration(context),
              const Spacer(),
              SizedBox(height: 33.v),
              _buildSaveChanges(context,settingProvider),
              SizedBox(height: 64.v),
            ],
          ),
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildName(BuildContext context) {
    return CustomTextFormField(
      controller: nameController,
      hintText: "Name",
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
    );
  }

  /// Section Widget
  Widget _buildMale(BuildContext context) {
    return CustomTextFormField(
      readOnly: true,
      controller: genderController,
      hintText: "Gender",
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
    );
  }

  /// Section Widget
  Widget _buildDuration(BuildContext context) {
    return CustomTextFormField(
      controller: ageController,
      hintText: "Age",
      hintStyle: CustomTextStyles.titleMediumBlack900SemiBold,
      textInputAction: TextInputAction.done,
    );
  }

  /// Section Widget
  Widget _buildSaveChanges(BuildContext context,StudentSettingProvider settingData) {
    return settingData.isLoading ? Utils.progressIndicator :  CustomElevatedButton(
      onPressed: (){
        settingData.updateChild(context, studetModel.User(name: nameController.text, age: int.parse(ageController.text),image: (image != null) ? studetModel.Image(url:image!.path ,publicId: "" ) : studetModel.Image(url: "" , publicId: "")));
      },
      text: "Save Changes",
    );
  }
}
