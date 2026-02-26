import 'package:coach_student/models/CoachClassModel.dart';
import 'package:coach_student/models/NotificationModel.dart';
import 'package:coach_student/models/coach_model/ReferrralClassModel.dart';
import 'package:coach_student/services/api/api_serivce_export.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/CoachChatModel.dart';
import '../../models/CoachProfileDetailsModel.dart';

class StudentHomeProvider extends ChangeNotifier {
  List<CoachProfileDetailsModel> coachesList = [];
  List<CoachClassesModel> coachClassesList = [];
  List<CoachClassesModel> pastClassesList = [];
  List<NotificationClassModel> notificationList = [];
  ReferrelClassModel? referrelClassModel;
  List<CoachChatModel> userList = [];

  bool isLoading = false;

  Future<List<CoachProfileDetailsModel>> getCoachesList(
    BuildContext context,
  ) async {
    final result = await DioApi.get(path: ConfigUrl.coachesList);
    isLoading = true;
    notifyListeners();
    if (result.response?.data != null) {
      coachesList = result.response?.data != null
          ? (result.response?.data["coaches"] as List<dynamic>)
              .map((map) => CoachProfileDetailsModel.fromJson(map))
              .toList()
          : <CoachProfileDetailsModel>[];
      isLoading = false;
      notifyListeners();
      return coachesList;
    } else {
      isLoading = false;
      notifyListeners();
      result.handleError(context);
      return coachesList;
    }
  }

  Future<List<CoachProfileDetailsModel>> getAllCoachesList(
    BuildContext context,
  ) async {
    final result = await DioApi.get(path: ConfigUrl.allCoachesList);
    isLoading = true;
    notifyListeners();
    if (result.response?.data != null) {
      coachesList = result.response?.data != null
          ? (result.response?.data["coaches"] as List<dynamic>)
              .map((map) => CoachProfileDetailsModel.fromJson(map))
              .toList()
          : <CoachProfileDetailsModel>[];
      isLoading = false;
      notifyListeners();
      return coachesList;
    } else {
      isLoading = false;
      notifyListeners();
      result.handleError(context);
      return coachesList;
    }
  }

  Future<List<CoachClassesModel>> getCoachClassesList(
    BuildContext context,
  ) async {
    isLoading = true;
    notifyListeners();

    final result = await DioApi.get(path: ConfigUrl.coachesClassList);

    if (result.response?.data != null) {
      coachClassesList = result.response?.data != null
          ? (result.response?.data["upcomingClasses"] as List<dynamic>)
              .map((map) => CoachClassesModel.fromJson(map))
              .toList()
          : <CoachClassesModel>[];

      pastClassesList = result.response?.data != null
          ? (result.response?.data["pastClasses"] as List<dynamic>)
              .map((map) => CoachClassesModel.fromJson(map))
              .toList()
          : <CoachClassesModel>[];

      // Sort past classes in descending order by day (most recent first)
      pastClassesList.sort((a, b) {
        if (a.day == null && b.day == null) return 0;
        if (a.day == null) return 1;
        if (b.day == null) return -1;
        return b.day!.compareTo(a.day!);
      });
      for (var data in coachClassesList) {
        print("data in === ${data.toJson()}");
      }
      isLoading = false;
      notifyListeners();
      return coachClassesList;
    } else {
      isLoading = false;
      notifyListeners();
      result.handleError(context);
      return coachClassesList;
    }
  }

  Future<List<NotificationClassModel>> getNotificationList(
    BuildContext context,
  ) async {
    final result = await DioApi.get(path: ConfigUrl.notificationUrl);
    isLoading = true;
    notifyListeners();
    if (result.response?.data != null) {
      notificationList = result.response?.data != null
          ? (result.response?.data["notification"] as List<dynamic>)
              .map((map) => NotificationClassModel.fromJson(map))
              .toList()
          : <NotificationClassModel>[];

      isLoading = false;
      notifyListeners();
      return notificationList;
    } else {
      isLoading = false;
      notifyListeners();
      result.handleError(context);
      return notificationList;
    }
  }

  Future<ReferrelClassModel?> getReferral(
      BuildContext context, String userId) async {
    final data = {"referredUserId": userId};

    referrelClassModel = ReferrelClassModel();
    isLoading = true;
    notifyListeners();
    final result = await DioApi.post(path: ConfigUrl.referralLink, data: data);

    if (result.response?.data != null) {
      final referalModel =
          ReferrelClassModel.fromJson(result.response?.data["referral"]);
      referrelClassModel = referalModel;
      isLoading = false;
      notifyListeners();
      return referalModel;
    } else {
      isLoading = false;
      notifyListeners();
      result.handleError(context);
      return null;
    }
  }

  changeUserList(int index, bool val) async {
    userList[index].isSelected = val;
    notifyListeners();
  }
}

final homeStudentNotifier =
    ChangeNotifierProvider.autoDispose<StudentHomeProvider>(
  (ref) => StudentHomeProvider(),
);
