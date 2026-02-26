import 'dart:developer';
import 'dart:io';

import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/provider/coach/coach_profile_provider.dart';
import 'package:coach_student/services/api/api_serivce_export.dart';
import 'package:coach_student/widgets/dialogs.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/CoachProfileDetailsModel.dart';
import '../../../../models/coach_model/StudentListClientModel.dart';

class SettingCoachProvider extends ChangeNotifier {
  // profile info get api
  // Future<void> getProfileInfo() async {}

  bool isLoadingPasswordChange = false;
  Future<void> changePassword(
    BuildContext context, {
    required String currentPassword,
    required String newPassword,
    required String confirmsPassword,
  }) async {
    isLoadingPasswordChange = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmsPassword
      };
      Result result = await DioApi.put(
        path: ConfigUrl.coachPasswordChange,
        data: data,
      );
      if (result.response != null) {
        bool? popPage = await Dialogs.showSuccessDialog(context,
            title: result.response?.data['message'], subtitle: ''
            //  result.response?.data['message']
            );
        if (popPage != null && popPage == true) {
          Navigator.pop(context);
          // popUntil((route) => route.isFirst);
        }
      } else {
        log("error profile ${result.dioError}");
        result.handleError(context);
      }
    } catch (e) {
      log("password change error $e");
    } finally {
      isLoadingPasswordChange = false;
      notifyListeners();
    }
  }

  bool userFeedbackLoading = false;

  Future<void> userFeedback(
    BuildContext context, {
    required String title,
    required String message,
  }) async {
    try {
      Map<String, dynamic> data = {"title": title, "message": message};
      userFeedbackLoading = true;
      notifyListeners();
      Result result = await DioApi.post(
        path: ConfigUrl.senMail,
        data: data,
      );
      if (result.response != null) {
        userFeedbackLoading = false;
        notifyListeners();
        bool? popPage = await Dialogs.showSuccessDialog(context,
            title: result.response?.data['message'], subtitle: ''
            //  result.response?.data['message']
            );
        if (popPage != null && popPage == true) {
          Navigator.pop(context);
          // popUntil((route) => route.isFirst);
        }
      } else {
        log("error profile ${result.dioError}");
        result.handleError(context);
      }
    } catch (e) {
      log("password change error $e");
    } finally {
      userFeedbackLoading = false;
      notifyListeners();
    }
  }

  Future<bool> coachDeleteAccount(BuildContext context) async {
    Result result = await DioApi.delete(path: ConfigUrl.coachDeleteAccount);
    if (result.response != null) {
      return true;
    } else {
      result.handleError(context);
      return false;
    }
  }

  bool isUpdateProfile = false;
  Future<void> coachProfileUpdate(
    BuildContext context,
    WidgetRef? ref, {
    File? file,
    String? name,
    String? token,
    String? aboutUs,
    String? fcmToken,
    String? timeZone,
  }) async {
    isUpdateProfile = true;
    notifyListeners();

    var data = FormData.fromMap({
      if (name != null && name.isNotEmpty) "name": name,
      if (aboutUs != null && aboutUs.isNotEmpty) "about": aboutUs,
      if (token != null && token.isNotEmpty) "chargePerHour": token,
      if (fcmToken != null && fcmToken.isNotEmpty) "fcmToken": fcmToken,
      if (timeZone != null && timeZone.isNotEmpty) "timeZone": timeZone,
      if (file != null)
        'image': await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
    });
    log({"token $token abour $aboutUs name: $name"}.toString());
    try {
      Result result =
          await DioApi.put(path: ConfigUrl.coachProfileUpdate, data: data);

      if (result.response != null) {
        isUpdateProfile = false;
        notifyListeners();

        SharedPreferencesManager.clearCoachProfile();
        SharedPreferencesManager.saveCoachProfile(
            CoachProfileDetailsModel.fromJson(result.response?.data['user']));

        log("shared pref profile user ${SharedPreferencesManager.getCoachProfile().toString()}");

        if (fcmToken != null && fcmToken.isNotEmpty) {
          logger.i("fcm token updated");
        } else {
          if (ref != null) {
            ref.read(coachProfileProvider).getCoachProfile();
          }
          bool? isClose = await Dialogs.showSuccessDialog(
            context,
            title: result.response?.data['message'],
            subtitle: '',
          );

          if (isClose == true) {
            Navigator.pop(context);
          }
        }
      } else {
        isUpdateProfile = false;
        notifyListeners();
        result.handleError(context);
      }
    } finally {
      isUpdateProfile = false;
      notifyListeners();
    }
  }

  // Stared account By Coach
  // CoachStaredAccountStudent coachStaredAccountStudent =
  //     CoachStaredAccountStudent();

  // bool isLoadingStaredAccount = false;
  // Future<void> getClinetListFetch(
  //   BuildContext context,
  // ) async {
  //   isLoadingStaredAccount = true;
  //   notifyListeners();

  //   Result result = await DioApi.get(
  //     path: ConfigUrl.coachGetStaredAccount,
  //   );
  //   if (result.response != null) {
  //     coachStaredAccountStudent =
  //         CoachStaredAccountStudent.fromJson(result.response?.data);
  //     isLoadingStaredAccount = false;
  //     notifyListeners();
  //   } else {
  //     log("error profile ${result.dioError}");
  //     isLoadingStaredAccount = false;
  //     notifyListeners();
  //     result.handleError(context);
  //   }
  // }

  // CoachProfileDetailsModel coachProfileDetailsModel =
  //     CoachProfileDetailsModel();
  // bool isLoadingProfile = false;
  // Future<void> getProfileInfoCaoch(BuildContext context) async {
  //   isLoadingProfile = true;
  //   notifyListeners();
  //   Result result = await DioApi.get(path: ConfigUrl.cachProfileGet);
  //   if (result.response != null) {
  //     coachProfileDetailsModel =
  //         CoachProfileDetailsModel.fromJson(result.response?.data);
  //     isLoadingProfile = false;
  //     SharedPreferencesManager.clearCoachProfile();
  //     SharedPreferencesManager.saveCoachProfile(coachProfileDetailsModel);
  //     notifyListeners();
  //   } else {
  //     result.handleError(context);
  //     isLoadingProfile = false;
  //     notifyListeners();
  //   }
  // }
  // bool isupdateProfile = false;
  // // profile update
  // Future<void> coachProfileUpdate(BuildContext context, WidgetRef ref,
  //     {File? file, required name, required token, required aboutUs}) async {
  //   isupdateProfile = true;
  //   notifyListeners();
  //   var data = FormData.fromMap({});
  //   if (file != null) {
  //     data = FormData.fromMap({
  //       "name": name,
  //       "about": aboutUs,
  //       "chargePerHour": token,
  //       'image': await MultipartFile.fromFile(file.path,
  //           filename: file.path.split('/').last),
  //     });
  //   } else {
  //     data = FormData.fromMap({
  //       "name": name,
  //       "about": aboutUs,
  //       "chargePerHour": token,
  //     });
  //   }
  //   Result result =
  //       await DioApi.post(path: ConfigUrl.coachProfileUpdate, data: data);
  //   if (result.response != null) {
  //     isupdateProfile = false;
  //     notifyListeners();
  //     bool? isclose = await Dialogs.showSuccessDialog(context,
  //         title: result.response?.data['message'], subtitle: '');

  //     if (isclose == true) {
  //       Navigator.pop(context);
  //     }
  //   } else {
  //     isupdateProfile = false;
  //     notifyListeners();
  //     result.handleError(context);
  //   }
  // }

  bool isLoadingStudentList = false;
  StudentListClientModel studentListClientModel =
      StudentListClientModel(clients: []);
  bool isAddingCredits = false;
  Future<void> fetchMyStudent(BuildContext context) async {
    isLoadingStudentList = true;
    notifyListeners();
    Result result = await DioApi.get(path: ConfigUrl.listOfStudentClient);
    if (result.response != null) {
      studentListClientModel =
          StudentListClientModel.fromJson(result.response?.data);
      isLoadingStudentList = false;
      notifyListeners();
    } else {
      isLoadingStudentList = false;
      notifyListeners();
      result.handleError(context);
    }
  }

  Future<void> addCreditsToClient(
    BuildContext context, {
    required String studentId,
    required int amount,
    required DateTime dateReceived,
    String? methodOrNotes,
  }) async {
    isAddingCredits = true;
    notifyListeners();

    try {
      final data = {
        "amount": amount,
        "dateReceived": dateReceived.toIso8601String(),
        if (methodOrNotes != null && methodOrNotes.isNotEmpty)
          "methodOrNotes": methodOrNotes,
      };

      final path = ConfigUrl.addCreditsToClient(studentId);

      Result result = await DioApi.post(path: path, data: data);

      if (result.response != null) {
        Utils.toast(
            message: result.response?.data['message'] ??
                'Credits added successfully');
        // Refresh the client list to get updated credits
        await fetchMyStudent(context);
      } else {
        result.handleError(context);
      }
    } catch (e) {
      log("Error adding credits: $e");
      Utils.toast(message: "Error adding credits. Please try again.");
    } finally {
      isAddingCredits = false;
      notifyListeners();
    }
  }

  bool isAddingNote = false;
  Future<void> addPrivateNote(
    BuildContext context, {
    required String studentId,
    String? childrenId,
    required String note,
  }) async {
    isAddingNote = true;
    notifyListeners();

    try {
      final data = {
        "studentId": studentId,
        "note": note,
        if (childrenId != null) "childrenId": childrenId,
      };

      Result result =
          await DioApi.post(path: ConfigUrl.privateNote, data: data);

      if (result.response != null) {
        Utils.toast(message: "Note saved successfully");
      } else {
        result.handleError(context);
      }
    } catch (e) {
      log("Error adding note: $e");
      Utils.toast(message: "Error saving note. Please try again.");
    } finally {
      isAddingNote = false;
      notifyListeners();
    }
  }

  Future<String?> getPrivateNote(
    BuildContext context, {
    required String studentId,
    String? childrenId,
  }) async {
    try {
      final Map<String, dynamic> queryParameters = {
        "studentId": studentId,
        if (childrenId != null) "childrenId": childrenId,
      };

      Result result = await DioApi.get(
        path: ConfigUrl.privateNote,
        queryParameters: queryParameters,
      );

      if (result.response != null) {
        if (result.response?.data['privateNote'] != null) {
          return result.response?.data['privateNote']['note'] ?? "";
        }
        return "";
      }
    } catch (e) {
      log("Error fetching note: $e");
    }
    return null;
  }
}

final settingCoachProvider =
    ChangeNotifierProvider<SettingCoachProvider>((ref) {
  return SettingCoachProvider();
});
