import 'dart:developer';

import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/models/CoachProfileDetailsModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../services/api/api.dart';
import '../../services/api/configurl.dart';
import '../../services/api/dio.dart';

class CoachProfileNotifier extends ChangeNotifier {
  CoachProfileNotifier() {
    // 1. Initially load from cache so the user sees their profile immediately (offline support/speed)
    final cachedData = SharedPreferencesManager.getCoachProfile();
    if (cachedData != null) {
      coachProfileDetailsModel = cachedData;
    }
    // 2. Immediately fetch the fresh status from the backend
    getCoachProfile();
  }

  CoachProfileDetailsModel coachProfileDetailsModel =
      CoachProfileDetailsModel();
  bool isLoadingProfile = false;

  Future<void> getCoachProfile() async {
    isLoadingProfile = true;
    notifyListeners();

    // Print the API request URL
    log("===========================================");
    log("Account Info API Request (FORCED REFRESH):");
    log("URL: ${ConfigUrl.baseUrl}${ConfigUrl.cachProfileGet}");
    log("Method: GET");
    log("===========================================");
    
    Result result = await DioApi.get(path: ConfigUrl.cachProfileGet);
    
    if (result.response != null) {
      coachProfileDetailsModel =
          CoachProfileDetailsModel.fromJson(result.response?.data);
      
      // Update cache with the fresh data from server
      SharedPreferencesManager.clearCoachProfile();
      SharedPreferencesManager.saveCoachProfile(coachProfileDetailsModel);
      
      isLoadingProfile = false;
      notifyListeners();
    } else {
      log("Account Info API Error: ${result.dioError?.message}");
      isLoadingProfile = false;
      notifyListeners();
    }
  }
}

final coachProfileProvider =
    ChangeNotifierProvider.autoDispose<CoachProfileNotifier>((ref) {
  return CoachProfileNotifier();
});
