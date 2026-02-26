import 'package:coach_student/core/app_export.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../widgets/custom_app_bar_student.dart';
import '../add_location/add_location.dart';

class TimeSlotStudent extends StatefulWidget {
  const TimeSlotStudent({Key? key}) : super(key: key);

  @override
  _TimeSlotStudentState createState() => _TimeSlotStudentState();
}

class _TimeSlotStudentState extends State<TimeSlotStudent> {
  int? groupValue;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: "27th October",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 10.v),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.v,
            ),
            Text(
              'Please select the slot',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.fSize,
                fontFamily: 'Nunito Sans',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            SizedBox(
              height: 16.v,
            ),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10.v,
                  );
                },
                itemCount: 20,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // Replace the static strings with your actual time data
                  String startTime = "09:30 AM";
                  String endTime = "10:00 AM";

                  return Container(
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5.adaptSize),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: RadioListTile<int>(
                        controlAffinity: ListTileControlAffinity.trailing,
                        // enableFeedback: true,
                        value:
                            index, // Use a unique value for each RadioListTile
                        groupValue: groupValue,
                        activeColor: primaryColor,
                        onChanged: (val) {
                          setState(() {
                            groupValue = val;
                          });
                        },
                        title: Padding(
                          padding: EdgeInsets.only(
                            left: 30.adaptSize,
                          ),
                          child: Text(
                            "$startTime - $endTime",
                            style: TextStyle(
                              color: groupValue == index
                                  ? const Color.fromRGBO(61, 109, 245, 1)
                                  : Colors.black.withOpacity(0.800000011920929),
                              fontSize: 16.fSize,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.35,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
          width: 350,
          height: 70,
          child: Padding(
            padding: EdgeInsets.all(10.0.adaptSize),
            child: ElevatedButton(
              // style: ElevatedButton.styleFrom(
              //     foregroundColor: const Color(0xFF3D6DF5),
              //     backgroundColor: const Color(0xFF3D6DF5)),
              onPressed: () {
                Navigator.push(
                  context, MaterialPageRoute(builder: (context)=> const AddLocationScreen())
                );
              },
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Schedule class for-',
                        children: [
                          TextSpan(
                            text: ' 30',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.fSize,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          )
                        ],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.fSize,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    const Gap(5),
                    CustomImageView(
                      imagePath: ImageConstant.coinImage,
                      height: 21.v,
                      // width: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
