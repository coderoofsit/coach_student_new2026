import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/core/app_export.dart';

import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:coach_student/widgets/custom_icon_button.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/utils.dart';
import '../../../models/student_model.dart';
import '../../../widgets/terms_condition_page.dart';
import '../AuthProvider/AuthProvider.dart';
import 'ChildFormWidget.dart';

class ChildSignUp extends ConsumerStatefulWidget {
  final String parentId;
  final String password;
  final String email;
  final String longitude;
  final String latitude;
  final String userType;
  final String radius;
  final String address;
  const ChildSignUp(
      {required this.parentId,
      required this.password,
      required this.userType,
      required this.latitude,
      required this.longitude,
      required this.radius,
      required this.address,
      required this.email,
      Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<ChildSignUp> createState() => _ChildSignUpConsumerState();
}

class _ChildSignUpConsumerState extends ConsumerState<ChildSignUp> {
  // TextEditingController nameController = TextEditingController();

  // TextEditingController maleFemaleController = TextEditingController();

  // TextEditingController enterAgeController = TextEditingController();
  // TextEditingController phoneCotnroller = TextEditingController();

  bool close = false;
  bool isChecked = true;
  String? selectedGender;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    // nameController.dispose();
    // maleFemaleController.dispose();
    // enterAgeController.dispose();
    // phoneCotnroller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    final studentProvider = ref.watch(authNotifier);
    // log("student----------- lenght ${studentProvider.listStudentForm.length}");
    // log("password is there ${widget.password}");
    //  Provider.of<>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      _buildLoginWidget(context),
                      SizedBox(height: 17.v),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: studentProvider.listStudentForm.length,
                        itemBuilder: (BuildContext context, int index) {
                          return StudentForm(
                            index: index,
                          );
                        },
                      ),
                      // Consumer<AuthProvider>(
                      //     builder: (context, consumeData, child) {
                      //   return ListView.builder(
                      //     physics: const NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     itemCount: consumeData.listStudentForm.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       return StudentForm(
                      //         index: index,
                      //       );
                      //     },
                      //   );
                      // }),

                      InkWell(
                        onTap: () {
                          ref.read(authNotifier).addStudentForm();
                          // addStudentForm();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomImageView(
                              imagePath: ImageConstant.imgMajesticonsPlus,
                              height: 22.adaptSize,
                              width: 22.adaptSize,
                              margin: EdgeInsets.symmetric(vertical: 1.v),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4.h),
                              child: Text(
                                "Add Student ",
                                style: CustomTextStyles.titleMediumPrimary18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.v),
                      SizedBox(
                        width: 150.h,
                        child: const Divider(),
                      ),
                      SizedBox(height: 78.v),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Theme(
                            data: ThemeData(
                              primarySwatch: Colors.blue,
                              unselectedWidgetColor: Colors.black, // Your color
                            ),
                            child: Container(
                              child: Checkbox(
                                  activeColor: Colors.black,
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  }),
                            ),
                          ),

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
                                              return TermsAndCondition();
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
                      // _buildClose(context),
                      SizedBox(height: 5.v),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildContinue(context),
    );
  }

  /// Section Widget
  Widget _buildLoginWidget(BuildContext context) {
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
                              //
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
  // Widget _buildName(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 30.h),
  //     child: CustomTextFormField(
  //       controller: nameController,
  //       textCapitalization: TextCapitalization.words,
  //       hintText: "Enter his/her first name",
  //     ),
  //   );
  // }

  /// Section Widget
  // Widget _buildMaleFemale(BuildContext context) {
  //   return CustomTextFormField(
  //     width: 150.h,
  //     controller: maleFemaleController,
  //     hintText: "Male/Female",
  //   );
  // }

  /// Section Widget
  // Widget _buildEnterAge(BuildContext context) {
  //   return CustomTextFormField(
  //     width: 150.h,
  //     controller: enterAgeController,
  //     textInputType: TextInputType.number,
  //     hintText: "Enter Age",
  //     textInputAction: TextInputAction.done,
  //   );
  // }

  /// Section Widget
  // Widget _buildMaleFemale1(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 30.h),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.only(left: 3.h),
  //               child: Text(
  //                 "Gender",
  //                 style: CustomTextStyles.titleMediumBlack900_3,
  //               ),
  //             ),
  //             SizedBox(height: 4.v),
  //             _buildMaleFemale(context),
  //           ],
  //         ),
  //         Padding(
  //           padding: EdgeInsets.only(left: 30.h),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Padding(
  //                 padding: EdgeInsets.only(left: 3.h),
  //                 child: Text(
  //                   "Age",
  //                   style: CustomTextStyles.titleMediumBlack900_3,
  //                 ),
  //               ),
  //               SizedBox(height: 3.v),
  //               _buildEnterAge(context),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// Section Widget

  /// Section Widget
  Widget _buildContinue(BuildContext context) {
    final studentProvider = ref.watch(authNotifier);
    return ref.watch(authNotifier).isLoadingRegistation
        ? Utils.progressIndicator
        : CustomElevatedButton(
            onPressed: () {
              if (!isChecked) {
                Utils.showSnackbarErrror(
                    context, 'Please accept terms and conditions');
                return;
              }

              //  password: widget.password,
              //                         email: widget.email,
              //                         longitude: widget.longitude,
              //                         latitude: widget.latitude,
              //                         radius: widget.radius,
              //                         address: widget.address,
              // String? selectedGender;
              print("this function is running ");

              print(
                  "student model == ${studentProvider.listStudentModel.length}");

              for (
                  // final i in studentProvider.listStudentModel
                  int i = 0;
                  i < studentProvider.listStudentModel.length;
                  i++) {
                StudentModel studentModel = studentProvider.listStudentModel[i];

                if (studentModel.name == null) {
                  Utils.showSnackbarErrror(context, 'Please enter valid name');
                  return;
                }

                if (studentModel.gender == null) {
                  Utils.showSnackbarErrror(context, 'Please select gender');
                  return;
                }

                bool islast =
                    (studentProvider.listStudentModel.length - 1) == i;

                log("isLast ++ $islast");
                log("Student $i:");
                log("student model length ${studentProvider.listStudentModel.length}");
                log("Name: ${studentModel.name}");
                log("Gender: ${studentModel.gender}");
                log("Phone Number: ${studentModel.phoneNumber}");
                log("----------- student all is there ${studentModel.toJson()}");
                // if (studentModel.image != null) {
                ref
                    .read(authNotifier)
                    .addChildren(context, islast,
                        parentId: widget.parentId,
                        name: studentModel.name ?? "",
                        email: widget.email,
                        age: studentModel.age.toString(),
                        gender: studentModel.gender ?? "",
                        file: studentModel.image,
                        userType: widget.userType)
                    .then((value) {
                  // ref.read(studentSettingProvider).getAllStudentList();
                });
              }
              // }
            },
            text: "Continue",
            margin: EdgeInsets.only(
              left: 30.h,
              right: 30.h,
              bottom: 40.v,
            ),
          );
  }
}
