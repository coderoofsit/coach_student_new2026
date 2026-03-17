import 'dart:convert';
import 'dart:developer';

import 'package:coach_student/models/student_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/CoachProfileDetailsModel.dart';
import '../models/student_list_model.dart';

// import '../screens/my_account/models/user_model.dartt';
enum UserType {
  students,
  coach,
}

class SharedPreferencesManager {
  static late SharedPreferences _prefs;
  static const String _userKey = 'user';
  static const String parentStudentList = 'studentList';
  static const String notificationCount = 'notifcationCount';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void setToken({required String token}) {
    _prefs.setString("token", token);
  }

  static void setNoticationCount({required int count}) {
    _prefs.setInt(notificationCount, count);
  }

  static int? getNotificationCount() {
    return _prefs.getInt(notificationCount);
  }

  static void setStudentPorfile(
      {required StudentProfileModel studentProfileModel}) {
    final jsonData = jsonEncode(studentProfileModel.toJson());
    print("student json data $jsonData");
    _prefs.setString("studentProfile", jsonData);
  }

  static void setListStudent(StudentListModel list) {
    final jsonData = jsonEncode(list.toJson());
    print("student json data $jsonData");
    _prefs.setString(parentStudentList, jsonData);
  }

  static StudentListModel? getListStudent() {
    final jsonString = _prefs.getString(parentStudentList);
    if (jsonString != null && jsonString.isNotEmpty) {
      final jsonData = jsonDecode(jsonString);
      return StudentListModel.fromJson(jsonData);
    }
    return null;
  }

  static StudentProfileModel? getStudentPorfile() {
    final jsonData = _prefs.getString("studentProfile");

    if (jsonData != null) {
      final coachProfileMap = jsonDecode(jsonData);
      return StudentProfileModel.fromJson(coachProfileMap);
    }
    return null;
  }

  static String getToken() {
    return _prefs.getString("token") ?? "";
    // log("token function calling");
    // return "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2NWE3OTZhZTAwY2E1OGJkODYxMTgxN2MiLCJpYXQiOjE3MDU0ODE5NDMsImV4cGlyZXMiOiI1Iiwic2VjcmV0IjoiOG1DY09GMGtrRUNCamF0Z25EWlM1Vzh0YWw5aUFRYWUifQ.BHd6DCNr6xF7DekMFRBJhclv6O562cj6boUiewDWyTI";
  }

  static void clearToken() {
    _prefs.remove("token");
  }

  static void clearStudentList() {
    _prefs.remove(parentStudentList);
  }

  static String getUserType() {
    return _prefs.getString('userType') ?? "";
  }

  static void setUserType({required String userTpe}) {
    _prefs.setString('userType', userTpe);
  }

  // Save UserModel to SharedPreferences
  // static Future<void> saveUser({required UserModel user}) async {
  //   final userJson = jsonEncode(user.toJson());
  //   _prefs.setString(_userKey, userJson);
  // }

  // Retrieve UserModel from SharedPreferences
  // static UserModel? getUser() {
  //   final userJson = _prefs.getString(_userKey);
  //   if (userJson != null) {
  //     final userMap = jsonDecode(userJson);
  //     return UserModel.fromJson(userMap);
  //   }
  //   return null;
  // }

  // Remove UserModel from SharedPreferences
  static void removeUser() async {
    _prefs.remove(_userKey);
  }

  static void setFcmToken({required String fcmToken}) {
    _prefs.setString('fcmToken', fcmToken);
  }

  static String getFcmToken() {
    return _prefs.getString('fcmToken') ?? "";
  }

  static void saveCoachProfile(CoachProfileDetailsModel coachProfile) {
    final coachProfileJson = jsonEncode(coachProfile.toJson());
    log("save coach profile $coachProfileJson");
    _prefs.setString('coachProfile', coachProfileJson);
  }

  static CoachProfileDetailsModel? getCoachProfile() {
    final coachProfileJson = _prefs.getString('coachProfile');
    if (coachProfileJson != null) {
      final coachProfileMap = jsonDecode(coachProfileJson);
      return CoachProfileDetailsModel.fromJson(coachProfileMap);
    }
    return null;
  }

  static void clearCoachProfile() {
    _prefs.remove('coachProfile');
  }

  // access without any function
  static SharedPreferences get instance => _prefs;

  static void clearPref() {
    _prefs.clear();
  }
  
  static void setIsOnboardingComplete(bool value) {
    _prefs.setBool("isOnboardingComplete", value);
  }

  static bool getIsOnboardingComplete() {
    return _prefs.getBool("isOnboardingComplete") ?? false;
  }
}
