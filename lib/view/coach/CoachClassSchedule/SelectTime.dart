import 'package:coach_student/core/utils/size_utils.dart';
import 'package:coach_student/view/coach/CoachClassSchedule/new_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../../../core/utils/utils.dart';

import '../../../theme/custom_text_style.dart';

import '../../../widgets/custom_app_bar_student.dart';
import '../../../widgets/custom_elevated_button.dart';
import 'location_pickup_coach.dart';

class SelectTimeSlotEndStartCoach extends StatefulWidget {
  final DateTime selectedDateSlot;
  final String typeOfClass;
  final String classFeesAmount;
  final TimeZoneWithLocal selectedTimeZone;
  final String classDescription;

  const SelectTimeSlotEndStartCoach({
    required this.selectedDateSlot,
    super.key,
    required this.typeOfClass,
    required this.classFeesAmount,
    required this.classDescription,
    required this.selectedTimeZone,
  });

  @override
  State<SelectTimeSlotEndStartCoach> createState() =>
      _SelectTimeSlotEndStartCoachState();
}

class _SelectTimeSlotEndStartCoachState
    extends State<SelectTimeSlotEndStartCoach> {
  DateTime? _selectedTimeStart;
  bool _tzInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeTimezone();
  }

  Future<void> _initializeTimezone() async {
    if (!_tzInitialized) {
      tz.initializeTimeZones();
      _tzInitialized = true;
    }
  }

  /// Converts a DateTime (interpreted as local time in selected timezone) to UTC
  DateTime _convertToUtc(DateTime localTime, String timeZoneName) {
    try {
      final location = tz.getLocation(timeZoneName);
      // Create a TZDateTime in the selected timezone
      final tzDateTime = tz.TZDateTime(
        location,
        localTime.year,
        localTime.month,
        localTime.day,
        localTime.hour,
        localTime.minute,
        localTime.second,
        localTime.millisecond,
        localTime.microsecond,
      );
      // Convert to UTC
      return tzDateTime.toUtc();
    } catch (e) {
      logger.e("Error converting timezone: $e");
      // Fallback to device timezone conversion if timezone package fails
      return localTime.toUtc();
    }
  }

//  late DateTime _selectedTimeStart;
  String time = "-";
  String timeEnd = "-";
  DateTime? _selectedTimeEnd;

  void _showDatePickerStartEnd() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        // Create the modal bottom sheet widget containing the time picker and close button
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height * 0.5,
          child: Column(
            children: [
              SizedBox(
                height: 10.v,
              ),
              Container(
                width: 50.h,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.v,
              ),
              const Text(
                'End Time',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Time picker

              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: _selectedTimeEnd ?? widget.selectedDateSlot,
                  onDateTimeChanged: (newTime) {
                    setState(() {
                      _selectedTimeEnd = newTime;
                      timeEnd =
                          "${_selectedTimeEnd!.hour} : ${_selectedTimeEnd!.minute} ";
                    });
                  },
                ),
              ),
              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: CustomElevatedButton(
                        text: 'Done',
                        onPressed: () {
                          // _selectedTimeStart ??= DateTime.now();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 25.v,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePickerStartTime() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        // Create the modal bottom sheet widget containing the time picker and close button
        return SizedBox(
          height: MediaQuery.of(context).copyWith().size.height * 0.5,
          child: Column(
            children: [
              SizedBox(
                height: 10.v,
              ),
              Container(
                width: 50.h,
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.50,
                      strokeAlign: BorderSide.strokeAlignCenter,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.v,
              ),
              const Text(
                'Start Time',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Time picker

              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: _selectedTimeStart ?? widget.selectedDateSlot,
                  onDateTimeChanged: (newTime) {
                    setState(() {
                      _selectedTimeStart = newTime;

                      time =
                          "${_selectedTimeStart?.hour} : ${_selectedTimeStart?.minute}";
                    });
                  },
                ),
              ),
              SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 21),
                      child: CustomElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: 'Done',
                      ),
                    ),
                    SizedBox(
                      height: 25.v,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initMediaQueary(context);
    return Scaffold(
      appBar: CustomAppBarStudent(
        title: DateFormat('d  MMMM', 'en_US').format(widget.selectedDateSlot),
      ),
      // appBar: _buildAppBar(context),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 29.v),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10.h),
                child: Text("Please select start & End time",
                    style: CustomTextStyles.titleMediumBlack90018),
              ),
            ),
            SizedBox(height: 17.v),
            Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: GestureDetector(
                onTap: () {
                  _showDatePickerStartTime();
                  // _selectStartTime(context);
                },
                child: Container(
                  width: 350.h,
                  height: 55.v,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 15.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Center(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Start time',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.800000011920929),
                            fontSize: 16.fSize,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                            height: 0.09,
                            letterSpacing: -0.35,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _selectedTimeStart != null
                              ? DateFormat('hh:mm a')
                                  .format(_selectedTimeStart!)
                              : "",
                          style: const TextStyle(
                            color: Color(0xFF3D6DF5),
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                            height: 0.09,
                            letterSpacing: -0.35,
                          ),
                        ),
                        const Gap(10),
                        const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Color(0xFF3D6DF5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 17.v),
            Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: GestureDetector(
                onTap: () {
                  _showDatePickerStartEnd();
                },
                child: Container(
                  width: 350.h,
                  height: 55.v,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 15.h),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Center(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'End time',
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.800000011920929),
                            fontSize: 16.fSize,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w600,
                            height: 0.09,
                            letterSpacing: -0.35,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _selectedTimeEnd != null
                              ? DateFormat('hh:mm a').format(_selectedTimeEnd!)
                              : "",
                          style: const TextStyle(
                            color: Color(0xFF3D6DF5),
                            fontSize: 16,
                            fontFamily: 'Nunito Sans',
                            fontWeight: FontWeight.w700,
                            height: 0.09,
                            letterSpacing: -0.35,
                          ),
                        ),
                        const Gap(10),
                        const Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Color(0xFF3D6DF5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.v),
            SizedBox(height: 5.v)
          ],
        ),
      ),
      bottomNavigationBar: _buildNext(context),
    );
  }

  Widget _buildNext(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20.h,
          right: 20.h,
          bottom: 40.v,
        ),
        child: CustomElevatedButton(
          text: "Next",
          onPressed: () async {
            if (_selectedTimeStart != null) {
              // Ensure timezone data is initialized
              if (!_tzInitialized) {
                await _initializeTimezone();
              }

              // Extract hour and minute from the selected time
              // Note: CupertinoDatePicker returns time in phone's local timezone,
              // but we interpret these values as being in the selected class timezone
              final selectedStartHour = _selectedTimeStart!.hour;
              final selectedStartMinute = _selectedTimeStart!.minute;
              final selectedEndHour = _selectedTimeEnd!.hour;
              final selectedEndMinute = _selectedTimeEnd!.minute;

              logger.i("Selected timezone: ${widget.selectedTimeZone.timeZone}");
              logger.i("Start time selected: $selectedStartHour:$selectedStartMinute");
              logger.i("End time selected: $selectedEndHour:$selectedEndMinute");

              // Create TZDateTime directly in the selected timezone, then convert to UTC
              final location = tz.getLocation(widget.selectedTimeZone.timeZone);
              
              // Create start time in selected timezone
              final startTzDateTime = tz.TZDateTime(
                location,
                widget.selectedDateSlot.year,
                widget.selectedDateSlot.month,
                widget.selectedDateSlot.day,
                selectedStartHour,
                selectedStartMinute,
                0,
                0,
                0,
              );
              
              // Create end time in selected timezone
              final endTzDateTime = tz.TZDateTime(
                location,
                widget.selectedDateSlot.year,
                widget.selectedDateSlot.month,
                widget.selectedDateSlot.day,
                selectedEndHour,
                selectedEndMinute,
                0,
                0,
                0,
              );

              // Convert to UTC
              DateTime selectedStartTimeUtc = startTzDateTime.toUtc();
              DateTime selectedEndTimeUtc = endTzDateTime.toUtc();

              logger.i("Start time UTC: ${selectedStartTimeUtc.toIso8601String()}");
              logger.i("End time UTC: ${selectedEndTimeUtc.toIso8601String()}");

              // For validation, create local DateTime objects (naive, no timezone)
              DateTime selectedStartTimeLocal = DateTime(
                widget.selectedDateSlot.year,
                widget.selectedDateSlot.month,
                widget.selectedDateSlot.day,
                selectedStartHour,
                selectedStartMinute,
              );

              DateTime selectedEndTimeLocal = DateTime(
                widget.selectedDateSlot.year,
                widget.selectedDateSlot.month,
                widget.selectedDateSlot.day,
                selectedEndHour,
                selectedEndMinute,
              );

              // Get current time in the selected timezone for validation
              final nowInSelectedTz = tz.TZDateTime.now(location);
              final currentTimeInSelectedTz = DateTime(
                widget.selectedDateSlot.year,
                widget.selectedDateSlot.month,
                widget.selectedDateSlot.day,
                nowInSelectedTz.hour,
                nowInSelectedTz.minute,
                nowInSelectedTz.second,
              );

              // Validate: end time must be set
              if (_selectedTimeEnd == null) {
                Utils.toast(message: "Please select end time.");
                return;
              }

              // Validate: start time must be in the future (in selected timezone)
              if (selectedStartTimeLocal.isBefore(currentTimeInSelectedTz)) {
                Utils.toast(message: "Start time must be in the future.");
                return;
              }

              // Validate: end time must be after start time
              if (!selectedEndTimeLocal.isAfter(selectedStartTimeLocal)) {
                Utils.toast(message: "End time must be after start time.");
                return;
              }

              // Proceed to the next page with UTC times
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationPickupCoachSlot(
                    slotDate: widget.selectedDateSlot,
                    selectedTimeZone: widget.selectedTimeZone,
                    classDescription: widget.classDescription,
                    startTime: selectedStartTimeUtc,
                    endTime: selectedEndTimeUtc,
                    typeOfClass: widget.typeOfClass,
                    classFeesAmount: widget.classFeesAmount,
                  ),
                ),
              );
            } else {
              Utils.toast(message: "Start time must be in the future.");
            }
          },
          buttonTextStyle: CustomTextStyles.titleMediumWhiteA700SemiBold_1,
        ),
      ),
    );
  }

  // Widget _buildNext(BuildContext context) {
  //   return CustomElevatedButton(
  //       text: "Next",
  //       onPressed: () {
  //         DateTime currentTime = DateTime.now();

  //         // Check if start time is after the current time
  //         if (_selectedTimeStart.isBefore(currentTime)) {
  //           // Throw an error if start time is before current time
  //           Utils.toast(message: "Please select a valid start time");
  //           return;
  //         }
  //         if (_selectedTimeEnd == null ||
  //             _selectedTimeEnd!.isBefore(currentTime)) {
  //           // Throw an error if end time is before or equal to start time
  //           Utils.toast(message: "End time should be after start time");
  //           return;
  //         }

  //         // Check if end time is before or equal to start time
  //         if (_selectedTimeEnd == null ||
  //             _selectedTimeEnd!.isAtSameMomentAs(_selectedTimeStart)) {
  //           // Throw an error if end time is before or equal to start time
  //           Utils.toast(message: "End time should be after start time");
  //           return;
  //         }
  //         if (_selectedTimeEnd != null) {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => LocationPickupCoachSlot(
  //                 slotDate: widget.selectedDateSlot,
  //                 startTime: _selectedTimeStart,
  //                 //  .toIso8601String(),
  //                 endTime: _selectedTimeEnd,
  //                 typeOfClass: widget.typeOfClass,
  //                 classFeesAmount: widget.classFeesAmount,
  //               ),
  //             ),
  //           );
  //         } else {
  //           Utils.toast(
  //             message: "Please select time",
  //           );
  //         }
  //       },
  //       margin: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 40.v),
  //       buttonTextStyle: CustomTextStyles.titleMediumWhiteA700SemiBold_1);
  // }

  /// Navigates back to the previous screen.
  onTapImgArrowLeft(BuildContext context) {
    Navigator.pop(context);
  }
}
