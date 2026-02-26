import 'dart:developer';

import 'package:coach_student/main.dart';
import 'package:coach_student/services/api/api.dart';
import 'package:coach_student/services/api/configurl.dart';
import 'package:coach_student/services/api/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/coach_model/CoachClassDetails_model.dart';
import '../../models/coach_model/StudentListClientModel.dart';
import '../../widgets/dialogs.dart';

class ClassDetailsCoachProviderNotifier extends ChangeNotifier {
  bool isLoadingClassDetails = false;
  ClassDetailsCoachModel classDetailsCoachModel = ClassDetailsCoachModel(
    upcomingSchedules: [],
    pastSchedules: [],
    pendingSchedules: [],
  );
  Future<void> fetchClassDeatilsProvider(BuildContext context) async {
    if (_isDisposed) return;

    isLoadingClassDetails = true;
    _safeNotifyListeners();
    Result result = await DioApi.get(path: ConfigUrl.classDetailsCoach);

    if (_isDisposed) return;

    if (result.response != null) {
      classDetailsCoachModel =
          ClassDetailsCoachModel.fromJson(result.response?.data);
      log("class details ${classDetailsCoachModel.pastSchedules.toString()}");

      isLoadingClassDetails = false;
      _safeNotifyListeners();
    } else {
      isLoadingClassDetails = false;
      _safeNotifyListeners();
      if (!_isDisposed) {
        result.handleError(context);
      }
    }
  }

  bool isLoadingStudentList = false;
  StudentListClientModel studentListClientModel =
      StudentListClientModel(clients: []);

  StudentListClientModel classAttendedStudentList =
      StudentListClientModel(clients: []);

  num currentClassFee = 0;

  Future<void> fetchMyStudent(BuildContext context) async {
    if (_isDisposed) return;

    isLoadingStudentList = true;
    _safeNotifyListeners();
    Result result = await DioApi.get(path: ConfigUrl.classAttendedStudent);

    if (_isDisposed) return;

    if (result.response != null) {
      studentListClientModel =
          StudentListClientModel.fromJson(result.response?.data);
      isLoadingStudentList = false;
      _safeNotifyListeners();
    } else {
      isLoadingStudentList = false;
      _safeNotifyListeners();
      if (!_isDisposed) {
        result.handleError(context);
      }
    }
  }

  Future<void> fetchMyClassAttendedStudent(BuildContext context) async {
    if (_isDisposed) return;

    isLoadingStudentList = true;
    _safeNotifyListeners();
    Result result = await DioApi.get(path: ConfigUrl.classAttendedStudent);

    if (_isDisposed) return;

    if (result.response != null) {
      classAttendedStudentList =
          StudentListClientModel.fromJson(result.response?.data);
      isLoadingStudentList = false;
      _safeNotifyListeners();
    } else {
      isLoadingStudentList = false;
      _safeNotifyListeners();
      if (!_isDisposed) {
        result.handleError(context);
      }
    }
  }

  Future<void> fetchScheduleParticipants(BuildContext context,
      {required String scheduleId}) async {
    if (_isDisposed) return;

    isLoadingStudentList = true;
    _safeNotifyListeners();
    Result result = await DioApi.get(
        path: "${ConfigUrl.scheduleParticipants}/$scheduleId/participants");

    if (_isDisposed) return;

    if (result.response != null) {
      classAttendedStudentList =
          StudentListClientModel.fromJson(result.response?.data);
      if (result.response?.data['classFess'] != null) {
        currentClassFee = result.response?.data['classFess'];
      }
      isLoadingStudentList = false;
      _safeNotifyListeners();
    } else {
      isLoadingStudentList = false;
      _safeNotifyListeners();
      if (!_isDisposed) {
        result.handleError(context);
      }
    }
  }

  void updateIsSelected({required bool? value, required int index}) {
    if (value != null) {
      classAttendedStudentList.clients[index].isSelected = value;
      log("value $value");
      // notifyListeners();
    }
  }

  void selectAllStudents({required bool selectAll}) {
    for (var client in classAttendedStudentList.clients) {
      client.isSelected = selectAll;
    }
    _safeNotifyListeners();
  }

  bool get areAllStudentsSelected {
    if (classAttendedStudentList.clients.isEmpty) return false;
    return classAttendedStudentList.clients
        .every((client) => client.isSelected);
  }

  void updateStudentListIsSelected({required bool? value, required int index}) {
    if (value != null &&
        index >= 0 &&
        index < studentListClientModel.clients.length) {
      studentListClientModel.clients[index].isSelected = value;
      log("student list selection updated: index=$index, value=$value");
      _safeNotifyListeners();
    }
  }

  void selectAllStudentsInList({required bool selectAll}) {
    for (var client in studentListClientModel.clients) {
      client.isSelected = selectAll;
    }
    _safeNotifyListeners();
  }

  bool get areAllStudentsInListSelected {
    if (studentListClientModel.clients.isEmpty) return false;
    return studentListClientModel.clients.every((client) => client.isSelected);
  }

  bool isLoadingAddParticipants = false;
  Future<void> addParticipants(BuildContext context,
      {required List<String> participants,
      required String classSheduleId}) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    Map<String, dynamic> data = {"participants": participants};
    Result result = await DioApi.post(
        path: "${ConfigUrl.addParticipants}/$classSheduleId", data: data);
    EasyLoading.dismiss();
    if (result.response != null) {
      if (result.response?.data["success"] == true) {
        navigatorKey.currentState?.pop();
        await Dialogs.showSuccessDialog(context,
            title: 'Payment Successful', subtitle: '');

        fetchClassDeatilsProvider(context);

        navigatorKey.currentState?.pop();
      }
    } else {
      result.handleError(context);
    }
    EasyLoading.dismiss();
  }

  List<Schedule> upcommingList = [];
  bool isUpcommingLoading = false;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> upcommingListFetch(
    BuildContext context,
  ) async {
    if (_isDisposed) return;

    isUpcommingLoading = true;
    _safeNotifyListeners();

    Result result = await DioApi.get(path: ConfigUrl.upcommingClassCoach);

    if (_isDisposed) return;

    if (result.response != null) {
      List data = result.response?.data["upcomingSchedules"];
      // logger.i("data up $data");
      upcommingList = data.map((e) => Schedule.fromJson(e)).toList();
      // logger.i("upcomming info ${upcommingList.toString()}");

      isUpcommingLoading = false;
      _safeNotifyListeners();
    } else {
      isUpcommingLoading = false;
      _safeNotifyListeners();
      if (!_isDisposed) {
        result.handleError(context);
      }
    }
  }

  // bool isLoadingDeletClass = false;
  Future<void> deleteScheduleClass(BuildContext context,
      {required sheduleCLassId}) async {
    EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
    // isLoadingDeletClass = true;
    // notifyListeners();
    Result result = await DioApi.delete(
      path: "${ConfigUrl.scheduleClassDelete}/$sheduleCLassId",
    );
    if (result.response != null) {
      EasyLoading.dismiss();
      // isLoadingDeletClass = false;
      // notifyListeners();
      fetchClassDeatilsProvider(context);
    } else {
      // isLoadingDeletClass = false;
      // notifyListeners();
      EasyLoading.dismiss();

      result.handleError(context);
    }
  }
}

final classDetailsCoachNotifier =
    ChangeNotifierProvider.autoDispose<ClassDetailsCoachProviderNotifier>(
        (ref) {
  return ClassDetailsCoachProviderNotifier();
});
