import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/services/api/api_serivce_export.dart';
import 'package:coach_student/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../new_class.dart';

class CoachSheduleNotifier extends ChangeNotifier {
  bool isLoadingClassShedule = false;
  bool _tzInitialized = false;

  Future<void> _ensureTimezoneInitialized() async {
    if (!_tzInitialized) {
      tz.initializeTimeZones();
      _tzInitialized = true;
    }
  }

  /// Converts a DateTime (interpreted as local time in selected timezone) to UTC
  DateTime _convertDayToUtc(DateTime localDay, String timeZoneName) {
    try {
      final location = tz.getLocation(timeZoneName);
      // Create a TZDateTime representing the start of the day in the selected timezone
      final tzDateTime = tz.TZDateTime(
        location,
        localDay.year,
        localDay.month,
        localDay.day,
        0, // Start of day
        0,
        0,
      );
      // Convert to UTC
      return tzDateTime.toUtc();
    } catch (e) {
      logger.e("Error converting day timezone: $e");
      // Fallback to device timezone conversion if timezone package fails
      return DateTime(localDay.year, localDay.month, localDay.day).toUtc();
    }
  }

  Future<void> classShedulePost(
    BuildContext context, {
    required DateTime day,
    required DateTime? startTime,
    required DateTime? endTime,
    required String locationAddress,
    required String maxStudent,
    required String longitude,
    required String latitude,
    required String typeOfClass,
    required String classFeesAmount,
    required TimeZoneWithLocal selectedTimeZone,
    required String classDescription,
    List<Map<String, dynamic>> participants = const [],
  }) async {
    try {
      isLoadingClassShedule = true;
      notifyListeners();
      
      // Ensure timezone data is initialized
      await _ensureTimezoneInitialized();
      
      // Convert day to UTC using the selected timezone (start of day in that timezone)
      DateTime dayUtc = _convertDayToUtc(day, selectedTimeZone.timeZone);
      
      Map<String, dynamic> data = {
        // Times are already in UTC from SelectTime.dart conversion
        "day": dayUtc.toIso8601String(),
        "startTime": startTime?.toUtc().toIso8601String(),
        "endTime": endTime?.toUtc().toIso8601String(),
        "location": locationAddress,
        "maxStudent": maxStudent,
        "longitude": longitude,
        "latitude": latitude,
        "typeOfClass": typeOfClass,
        "classFess": classFeesAmount,
        "class_description": classDescription,
        "time_zone": selectedTimeZone.timeZone,
      };
      
      // Add participants if any
      if (participants.isNotEmpty) {
        data["participants"] = participants;
      }
      Result result = await DioApi.post(
          path: ConfigUrl.coachClassCoachschedule, data: data);
      if (result.response != null) {
        final String formatedTime = Utils.formatNameDate(
          result.response?.data["coachSchedule"]["day"],
        );
        bool? isDone = await Dialogs.showSuccessDialog(
          context,
          title: formatedTime,
          subtitle: 'Scheduled fixed successfully for above date',
        );
        if (isDone == true) {
          Utils.removeRouteFirst(context);
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.coachBottomNavBar, (route) => false);
        }
      } else {
        result.handleError(context);
      }

      isLoadingClassShedule = false;
      notifyListeners();
    } catch (e) {
      logger.w(e);
    } finally {
      isLoadingClassShedule = false;
      notifyListeners();
    }
  }
}

final coachSheduleProvider =
    ChangeNotifierProvider<CoachSheduleNotifier>((ref) {
  return CoachSheduleNotifier();
});
