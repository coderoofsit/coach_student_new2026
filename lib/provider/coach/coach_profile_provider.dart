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
    getCoachProfile();
  }
  CoachProfileDetailsModel coachProfileDetailsModel =
      CoachProfileDetailsModel();
  bool isLoadingProfile = false;
  Future<void> getCoachProfile() async {
    isLoadingProfile = true;
    notifyListeners();
    final getCoachProfileData = SharedPreferencesManager.getCoachProfile();
    if (getCoachProfileData != null) {
      coachProfileDetailsModel = getCoachProfileData;
      log("===========================================");
      log("Account Info Data (from SharedPreferences):");
      log("Name: ${getCoachProfileData.name}");
      log("Email: ${getCoachProfileData.email}");
      log("Full Profile: ${getCoachProfileData.toString()}");
      log("===========================================");
      isLoadingProfile = false;
      notifyListeners();
    } else {
      // Print the API request URL
      log("===========================================");
      log("Account Info API Request:");
      log("URL: ${ConfigUrl.baseUrl}${ConfigUrl.cachProfileGet}");
      log("Method: GET");
      log("Endpoint: ${ConfigUrl.cachProfileGet}");
      log("===========================================");
      
      Result result = await DioApi.get(path: ConfigUrl.cachProfileGet);
      
      // Print the full API response
      log("===========================================");
      log("Account Info API Response:");
      log("Status Code: ${result.response?.statusCode}");
      log("Response Data: ${result.response?.data}");
      log("Full Response: ${result.response}");
      log("===========================================");
      
      if (result.response != null) {
        // Print parsed data
        log("===========================================");
        log("Parsed Coach Profile Data:");
        log("Name: ${result.response?.data['name']}");
        log("Email: ${result.response?.data['email']}");
        log("Full Parsed Model: ${CoachProfileDetailsModel.fromJson(result.response?.data)}");
        log("===========================================");
        
        coachProfileDetailsModel =
            CoachProfileDetailsModel.fromJson(result.response?.data);
        SharedPreferencesManager.clearCoachProfile();
        SharedPreferencesManager.saveCoachProfile(coachProfileDetailsModel);
        isLoadingProfile = false;
        notifyListeners();
      } else {
        log("===========================================");
        log("Account Info API Error:");
        log("DioError: ${result.dioError}");
        log("Error Message: ${result.dioError?.message}");
        log("Error Response: ${result.dioError?.response?.data}");
        log("Status Code: ${result.dioError?.response?.statusCode}");
        log("===========================================");
      }
    }
  }
}

final coachProfileProvider =
    ChangeNotifierProvider.autoDispose<CoachProfileNotifier>((ref) {
  return CoachProfileNotifier();
});
