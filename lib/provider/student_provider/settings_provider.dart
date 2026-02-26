import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/models/student_list_model.dart';
import 'package:coach_student/models/student_profile_model.dart';
import 'package:coach_student/services/api/api_serivce_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../routes/app_routes.dart';
import '../../widgets/dialogs.dart';

class StudentSettingProvider extends ChangeNotifier {
  User selectedStudentUser = User();

  StudentListModel? studentList ;
  StudentProfileModel? studentProfile ;
  bool isLoading = false;

  void setSelectedStudent(User data) {
    selectedStudentUser = data;
    notifyListeners();
  }

  void setStudent() {
    final studentList = SharedPreferencesManager.getListStudent();
    if (studentList != null && studentList.users.isNotEmpty) {
      selectedStudentUser = studentList.users[0];
      notifyListeners();
    }
  }

  void getAllStudentList(){
    studentList = SharedPreferencesManager.getListStudent();
    notifyListeners();
  }

  void getStudentProfile(){
    studentProfile = SharedPreferencesManager.getStudentPorfile();
    notifyListeners();
  }

  void getProfile()async{

    final result = await DioApi.get(path: "/student/me",);

    if(result.response!= null){
      studentProfile = StudentProfileModel.fromJson(result.response?.data);
      SharedPreferencesManager.setStudentPorfile(studentProfileModel: studentProfile!);
      notifyListeners();
    }else{

    }
  }

  Future<void> updateChild(BuildContext context, User userData) async {
    print("image url === ${userData.image?.url}");
    final data = FormData.fromMap({
      "name": userData.name,
      'age': userData.age,
      'gender': userData.gender,
      if(userData.image?.url != null && userData.image!.url.isNotEmpty)
        'image': [
          await MultipartFile.fromFile(
              '${userData.image?.url}',
              filename: '${userData.image?.url}')
        ],
    });

    print("object ${SharedPreferencesManager.getToken()}");
    isLoading = true;
    notifyListeners();

    final url =
        "/student/parents/${SharedPreferencesManager
        .getStudentPorfile()
        ?.id}/children/${selectedStudentUser.id}";

    final result = await DioApi.put(path: url, data: data);

    if (result.response?.data != null) {

      StudentListModel? studentList = SharedPreferencesManager.getListStudent();
      studentList?.users.removeWhere((element) =>
          result.response?.data["updatedChild"]["_id"].toString() == element.id.toString());
      selectedStudentUser = User.fromJson(result.response?.data["updatedChild"]);
      studentList?.users.add(selectedStudentUser);
      SharedPreferencesManager.setListStudent(studentList!);
      isLoading = false;
      notifyListeners();
      bool? popPage = await Dialogs.showSuccessDialog(context,
          title: "Updated Successfully", subtitle: ''
        //  result.response?.data['message']
      );
      getAllStudentList();
      if (popPage != null && popPage == true) {
        Navigator.pop(context);
        // popUntil((route) => route.isFirst);
      }
    } else {
      isLoading = false;
      notifyListeners();
      result.handleError(context);
    }
  }

  Future<void> updateParent(BuildContext context,StudentProfileModel userData) async {


    isLoading = true;
    notifyListeners();

    final data = FormData.fromMap(
        {
      "name": userData.name,
      'age': userData.age,
      if(userData.image?.url != null && userData.image!.url.isNotEmpty)
        'image': [
          await MultipartFile.fromFile(
              '${userData.image?.url}',
              filename: '${userData.image?.url}',)
        ],}
    );

    final result = await DioApi.put(path: ConfigUrl.updateStudentProfile, data: data);

    if (result.response?.data != null) {


      StudentProfileModel? studentProfileModel = SharedPreferencesManager.getStudentPorfile();

      studentProfileModel = StudentProfileModel.fromJson(result.response?.data["user"]);
      SharedPreferencesManager.setStudentPorfile(studentProfileModel: studentProfileModel);
      notifyListeners();
      isLoading = false;
      notifyListeners();
      getStudentProfile();
      bool? popPage = await Dialogs.showSuccessDialog(context,
          title: "Updated Successfully", subtitle: ''
        //  result.response?.data['message']
      );

      if (popPage != null && popPage == true) {
        Navigator.pop(context);
        // popUntil((route) => route.isFirst);
      }

    } else {
      isLoading = false;
      notifyListeners();
      result.handleError(context);
    }

  }

  Future<void> changePassword(BuildContext context,var userData) async {

    isLoading = true;
    notifyListeners();

    final result = await DioApi.put(path: ConfigUrl.changePassword, data: userData);
    if (result.response?.data != null) {
      bool? popPage = await Dialogs.showSuccessDialog(context,
          title: result.response?.data['message'], subtitle: ''
        //  result.response?.data['message']
      );
      if (popPage != null && popPage == true) {
        Navigator.pop(context);
        // popUntil((route) => route.isFirst);
      }

    } else {
      isLoading = false;
      notifyListeners();
      result.handleError(context);
    }

  }

  Future<void> deleteAccount(context)async{

    isLoading = true;
    notifyListeners();

    final result = await DioApi.delete(path: ConfigUrl.deleteAccount,);
    if (result.response?.data != null) {


        SharedPreferencesManager.instance.clear();
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.selectCoachOrStudentOneScreen,
              (route) => false,
        );


    } else {

      result.handleError(context);
    }

  }



}

final studentSettingProvider = ChangeNotifierProvider.autoDispose<StudentSettingProvider>(
        (ref) => StudentSettingProvider());
