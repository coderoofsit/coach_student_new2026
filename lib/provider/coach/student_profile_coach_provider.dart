import 'package:coach_student/services/api/api_serivce_export.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/coach_model/student_by_id_coachclient.dart';

class StudentProfileCoachNotifier extends ChangeNotifier {
  StudentProfileIdClinetCoachModel studentProfileIdClinetCoachModel =
      StudentProfileIdClinetCoachModel();
  bool isLoadingStudent = false;
  Future<void> fetchStdeuntById(
    BuildContext context, {
    required String studentId,
  }) async {
    isLoadingStudent = true;
    notifyListeners();
    Result result =
        await DioApi.get(path: "${ConfigUrl.studentGetByIdCoach}/$studentId");
    if (result.response != null) {
      studentProfileIdClinetCoachModel =
          StudentProfileIdClinetCoachModel.fromJson(result.response?.data);
      isLoadingStudent = false;
      notifyListeners();
    } else {
      isLoadingStudent = false;
      notifyListeners();
      result.handleError(context);
    }
  }
}

final studentProfileByIdCoachProvider =
    ChangeNotifierProvider.autoDispose<StudentProfileCoachNotifier>((ref) {
  return StudentProfileCoachNotifier();
});
