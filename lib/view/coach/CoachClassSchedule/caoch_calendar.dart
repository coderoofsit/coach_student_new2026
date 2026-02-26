import 'dart:developer';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/view/coach/CoachClassSchedule/new_class.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/utils/utils.dart';
import 'SelectTime.dart';

final kToday = DateTime.now();
// final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day + 1);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class CalenderCoachClass extends StatefulWidget {
  final String typeClass;
  final String feesAmount;
  final String classDescription;
  final TimeZoneWithLocal selectedTimeZone;
  const CalenderCoachClass(
      {super.key,
      required this.typeClass,
      required this.feesAmount,
      required this.classDescription,
      required this.selectedTimeZone});

  @override
  State<CalenderCoachClass> createState() => _CalenderCoachClassState();
}

class _CalenderCoachClassState extends State<CalenderCoachClass> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // DateTime? _rangeStart;
  // DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: const CustomAppBarStudent(
        title: 'Select date',
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24.h,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 10.v,
            ),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: kLastDay,
              focusedDay: _focusedDay,

              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              // rangeStartDay: _rangeStart,
              // rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,

              // rangeSelectionMode: _rangeSelectionMode,
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;

                    _focusedDay = focusedDay;
                    logger.i("$_selectedDay");
                    // _rangeStart = null; // Important to clean those
                    // _rangeEnd = null;
                    // _rangeSelectionMode = RangeSelectionMode.toggledOff;
                  });
                }
              },
              // onRangeSelected: (start, end, focusedDay) {
              //   setState(() {
              //     _selectedDay = null;
              //     _focusedDay = focusedDay;
              //     _rangeStart = start;
              //     _rangeEnd = end;
              //     // _rangeSelectionMode = RangeSelectionMode.toggledOn;
              //   });
              // },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(
                    color: Color(0xFF3D6DF5), shape: BoxShape.circle),
                defaultTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 17.60.fSize,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
                todayTextStyle: TextStyle(
                  color: const Color(0xFF3D6DF5),
                  fontSize: 17.60.fSize,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
                todayDecoration: BoxDecoration(
                    color: const Color(0xFF3D6DF5).withOpacity(0.15),
                    border: Border.all(
                      color: const Color(0xFF3D6DF5),
                      width: 2,
                    ),
                    shape: BoxShape.circle),
              ),

              headerStyle: HeaderStyle(
                titleCentered: true,
                leftChevronVisible: true,
                leftChevronIcon: CustomImageView(
                  imagePath: ImageConstant1.imgVectorPrimary19x8,
                ),
                rightChevronIcon: CustomImageView(
                  imagePath: ImageConstant1.imgVector19x8,
                ),
                //   Row(
                //   children: [
                //     CustomImageView(imagePath: ImageConstant1.imgVectorPrimary19x8 ,),
                //     // Icon(Icons.chevron_left),
                //     const Gap(5),
                //     const Icon(Icons.chevron_right),
                //   ],
                // ),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 17.60.fSize,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                // CalendarFormat.twoWeeks: '2 weeks',
                // CalendarFormat.week: 'Week'
              },
            ),
            const Spacer(),
            SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomElevatedButton(
                    text: 'Next',
                    onPressed: () {
                      log("selecte date $_selectedDay");
                      if (_selectedDay == null) {
                        Utils.toast(message: "Please Select date slot ");
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectTimeSlotEndStartCoach(
                            selectedDateSlot: _selectedDay!,
                            selectedTimeZone: widget.selectedTimeZone,
                            classDescription:widget.classDescription,
                            typeOfClass: widget.typeClass,
                            classFeesAmount: widget.feesAmount,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 30.v,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
