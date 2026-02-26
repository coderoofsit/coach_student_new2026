// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:coach_student/core/utils/size_utils.dart';
import 'package:coach_student/view/coach/CoachClassSchedule/caoch_calendar.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';

import '../../../theme/custom_text_style.dart';
import '../../../theme/theme_helper.dart';
import '../../../widgets/custom_text_form_field.dart';

class TimeZoneWithLocal {
  final String local;
  final String timeZone;
  TimeZoneWithLocal({
    required this.local,
    required this.timeZone,
  });
}

class NewClassScheduleaCoach extends StatefulWidget {
  const NewClassScheduleaCoach({super.key});

  @override
  State<NewClassScheduleaCoach> createState() => _NewClassScheduleaCoachState();
}

class _NewClassScheduleaCoachState extends State<NewClassScheduleaCoach> {
  final TextEditingController _controllerTypeOfClass = TextEditingController();

  final TextEditingController _controllerFeesAmount = TextEditingController();
  final _controllerDescription = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final _timeZoneController = TextEditingController();
  TimeZoneWithLocal? selectedTimeZone;
  int descriptionLength = 0;
  // Initial selected value
  final List<TimeZoneWithLocal> timeZone = [
    TimeZoneWithLocal(local: "est", timeZone: 'America/New_York'),
    TimeZoneWithLocal(local: "pst", timeZone: 'America/Los_Angeles'),
    TimeZoneWithLocal(local: "cst", timeZone: 'America/Chicago'),
    TimeZoneWithLocal(local: "mst", timeZone: 'America/Denver'),
  ];
  // Navigator.push(
  //                         context,
  //                         CupertinoPageRoute(
  //                             builder: (context) =>
  //                                 const CalenderCoachClass()));
  @override
  void dispose() {
    _controllerFeesAmount.dispose();
    _controllerTypeOfClass.dispose();
    _controllerDescription.dispose();
    _timeZoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: "New Class",
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 20.v),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 18.v),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.h),
                    child: Text(
                      "Type of class",
                      style: CustomTextStyles.titleMediumBlack900Bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.v),
                CustomTextFormField(
                  hintText: "Enter the Class type",
                  controller: _controllerTypeOfClass,
                  validator: (value) =>
                      value!.isNotEmpty ? null : "This field is required",
                  hintStyle: CustomTextStyles.titleSmallBlack900,
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 18.v),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.h),
                    child: Text(
                      "Token for class",
                      style: CustomTextStyles.titleMediumBlack900Bold,
                    ),
                  ),
                ),
                SizedBox(height: 8.v),
                CustomTextFormField(
                  hintText: "Amount in tokens",
                  controller: _controllerFeesAmount,
                  validator: (value) =>
                      value!.isNotEmpty ? null : "This field is required",
                  hintStyle: CustomTextStyles.titleSmallBlack900,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.number,
                ),

                SizedBox(height: 28.v),
                SizedBox(height: 8.v),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 7.h),
                    child: Row(
                      children: [
                        Text(
                          "Class description and requirements",
                          style: CustomTextStyles.titleMediumBlack900Bold,
                        ),

                      ],
                    ),
                  ),
                ),

                CustomTextFormField(

                  maxLength: 200,
                  hintText: "Please enter description",
                  controller: _controllerDescription,
                  maxLines: 5,
                  validator: (value) {
                    if(value!.isEmpty){
                      return "This field is required";
                    }
                    if (value.length > 200) {
                      return 'Reached max words';
                    }
                    return null;
                  },
                  hintStyle: CustomTextStyles.titleSmallBlack900,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 8.v),
                SizedBox(
                  width: double.infinity,
                  height: 90,
                  child: DropdownButtonFormField<TimeZoneWithLocal>(
                    
                    validator: (value) =>
                        value != null ? null : "This field is required",
                    value: selectedTimeZone,
                    items: timeZone
                        .map((zone) => DropdownMenuItem<TimeZoneWithLocal>(
                              value: zone,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.h),
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
                    
                    hint: const Text('Select Time Zone'),
                    icon: const Icon(Icons.arrow_drop_down),
                  ),
                ),
                // const Spacer(),
                SizedBox(height: 33.v),
                // const Spacer(),
                CustomElevatedButton(
                  text: "Next",
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => CalenderCoachClass(
                            classDescription: _controllerDescription.text,
                            selectedTimeZone: selectedTimeZone ??
                                TimeZoneWithLocal(
                                    local: "est", timeZone: 'America/New_York'),
                            typeClass: _controllerTypeOfClass.text,
                            feesAmount: _controllerFeesAmount.text,
                          ),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
