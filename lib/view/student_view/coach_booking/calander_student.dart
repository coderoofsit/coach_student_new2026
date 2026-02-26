
import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/widgets/custom_app_bar_student.dart';
import 'package:coach_student/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'dart:collection';


import 'time_slot_student/time_slot_after_selection_one_screen.dart';

/// Example event class.
class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5): List.generate(
        item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
}..addAll({
    kToday: [
      const Event('Today\'s Event 1'),
      const Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month, kToday.day - 1);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);

class CalenderStudent extends StatefulWidget {
  const CalenderStudent({super.key});

  @override
  State<CalenderStudent> createState() => _CalenderStudentState();
}

class _CalenderStudentState extends State<CalenderStudent> {
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
              firstDay: kFirstDay,
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
                todayDecoration: BoxDecoration(
                    color: const Color(0xFF3D6DF5).withOpacity(0.3),
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const TimeSlotStudent()));
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





 // @override
  // Widget build(BuildContext context) {
  //   mediaQueryData = MediaQuery.of(context);
  //   return Scaffold(
  //     appBar: const CustomAppBarStudent(
  //       title: 'Select date',
  //     ),
  //     body: TableCalendar(
  //       daysOfWeekVisible: true,
  //       firstDay: DateTime.utc(2010, 10, 16),
  //       lastDay: DateTime.utc(2030, 3, 14),
  //       focusedDay: DateTime.now(),

  //       // selectedDay: DateTime.now(),
  //       onDaySelected: (selectedDay, focusedDay) {
  //         log("selected day $selectedDay");
  //         log("focus day $focusedDay");
  //       },
        // headerStyle: HeaderStyle(
        //   titleCentered: true,
        //   leftChevronVisible: true,
        //   leftChevronIcon: CustomImageView(
        //     imagePath: ImageConstant1.imgVectorPrimary19x8,
        //   ),
        //   rightChevronIcon: CustomImageView(
        //     imagePath: ImageConstant1.imgVector19x8,
        //   ),
        //   //   Row(
        //   //   children: [
        //   //     CustomImageView(imagePath: ImageConstant1.imgVectorPrimary19x8 ,),
        //   //     // Icon(Icons.chevron_left),
        //   //     const Gap(5),
        //   //     const Icon(Icons.chevron_right),
        //   //   ],
        //   // ),
        //   titleTextStyle: TextStyle(
        //     color: Colors.black,
        //     fontSize: 17.60.fSize,
        //     fontFamily: 'Nunito Sans',
        //     fontWeight: FontWeight.w600,
        //     height: 0,
        //   ),
        // ),
        // availableCalendarFormats: const {
        //   CalendarFormat.month: 'Month',
        //   // CalendarFormat.twoWeeks: '2 weeks',
        //   // CalendarFormat.week: 'Week'
        // },
  //     ),
  //   );
  // }