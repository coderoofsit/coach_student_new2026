import 'dart:developer';
import 'dart:io';

import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/models/student_list_model.dart';
import 'package:coach_student/models/student_model.dart';
import 'package:coach_student/models/student_profile_model.dart';
import 'package:coach_student/services/api/api_serivce_export.dart';
import 'package:coach_student/services/notification_service/notification_service.dart';
import 'package:coach_student/view/coach/bottom_navbar/coach_bottomnavbar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/CoachProfileDetailsModel.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/dialogs.dart';
import '../parents/ChildFormWidget.dart';
import '../parents/ChildSignUp.dart';
import '../EmailVerificationScreen.dart';

class AuthProvider extends ChangeNotifier {
  List<StudentModel> listStudentModel = [StudentModel()];

  List<StudentForm> listStudentForm = [StudentForm()];

  bool isLoadingRegistation = false;
  
  DateTime? _lastResendTime;
  static const Duration _resendCooldown = Duration(minutes: 1);

  void addStudentForm( ) {
    listStudentForm.add(StudentForm());
    listStudentModel.add(StudentModel());
    print("list of student model == ${listStudentModel.length}");

    notifyListeners();
  }

  void removeStudentForm(int index) {
    print("index ===  $index");
    listStudentForm.removeAt(index);
    listStudentModel.removeAt(index);
    print("list of student model == ${listStudentModel.length}");
    notifyListeners();
  }

  void updateStudentModel(int index, StudentModel studentModel) {
    print("index == $index");

    listStudentModel[index] = studentModel;
    notifyListeners();
  }

  // login process
  bool isLoadingSign = false;

  Future<void> signIn(
    BuildContext context, {
    required String email,
    required String password,
    required userType,
  }) async {
    isLoadingSign = true;
    notifyListeners();

    try {
      Map<String, dynamic> data = {"email": email, "password": password};
      log("userType: $userType");
      Result result = await DioApi.post(
        path: userType == Utils.coachType
            ? ConfigUrl.coachLogin
            : ConfigUrl.studentLogin,
        data: data,
      );
      if (result.response != null) {
        SharedPreferencesManager.setUserType(userTpe: userType);
        SharedPreferencesManager.setToken(token: result.response?.data['token']);

        // Fetch a fresh FCM token after login and sync it to the backend
        final notificationServices = NotificationServices();
        final fcmToken = await notificationServices.getDeviceToken();

        if (userType == Utils.coachType) {
          await coachFCMTOKEN(fcmToken: fcmToken);
        } else {
          await studentFcmToken(fcmToken: fcmToken, context: context).then((value) async{
          if (userType == Utils.studentType) {
         print("user data ===  ${result.response?.data['user']}");

         SharedPreferencesManager.setStudentPorfile(
         studentProfileModel:
         StudentProfileModel.fromJson(result.response?.data['user']),
         );

         isLoadingSign = false;
         notifyListeners();

         Navigator.popUntil(context, (route) => route.isFirst);
         Navigator.pushNamedAndRemoveUntil(
         context, AppRoutes.studentBottomNavBarScreen, (route) => false);
         } else if (userType == Utils.parentsType) {
         StudentListModel? studentList =
         await getStudentsList(result.response?.data['user']['_id']);



         SharedPreferencesManager.setStudentPorfile(
         studentProfileModel:
         StudentProfileModel.fromJson(result.response?.data['user']),
         );

         if (studentList != null) {
         SharedPreferencesManager.setListStudent(studentList);
         }
         isLoadingSign = false;
         notifyListeners();
         Navigator.popUntil(context, (route) => route.isFirst);
         Navigator.pushNamedAndRemoveUntil(
         context, AppRoutes.studentBottomNavBarScreen, (route) => false);
         }
       });
      }
      isLoadingSign = false;
      notifyListeners();

      Utils.toast(message: 'Login successful');
      if (userType == Utils.coachType) {
        // log("user Token : ${SharedPreferencesManager.getToken()}");
        // SharedPreferencesManager.setUserType(userTpe: userType);
        // Navigator.pushNamed(
        //   context,

        SharedPreferencesManager.clearCoachProfile();
        CoachProfileDetailsModel coachProfileDetailsModel =
            CoachProfileDetailsModel.fromJson(result.response?.data['user']);
        SharedPreferencesManager.saveCoachProfile(coachProfileDetailsModel);



        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CoachBottomNavbar()),
            (route) => false);
      }

    } else {
      log("reponse ${result.dioError?.message}");
      result.handleError(context);
      isLoadingSign = false;
      notifyListeners();
    }
    } catch (e, stackTrace) {
      // Ensure loading state is always reset, even if an exception occurs
      log("Error during sign in: $e");
      log("Stack trace: $stackTrace");
      isLoadingSign = false;
      notifyListeners();
      
      // Show error dialog to user
      if (context.mounted) {
        Dialogs.errorDialog(
          context,
          'An unexpected error occurred during login. Please try again.',
        );
      }
    } finally {
      // Ensure loading state is reset in all cases
      isLoadingSign = false;
      notifyListeners();
    }
  }

  Future<StudentListModel?> getStudentsList(String parentId) async {
    String finalUrl = "/student/children/all?parent=$parentId";
    final result = await DioApi.get(path: finalUrl);

    if (result.response != null) {
      try {
        log("student data  ==  ${result.response?.data}");
        List<dynamic>? childrens = result.response?.data["childrens"];
        print("childrens == ${result.response?.data["childrens"]}");
        return StudentListModel.fromJson({"users": childrens});
      } catch (e) {
        print("something went wrong");
      }
    }

    return null;
  }

  Future<void> registerCoach(
      BuildContext context, {
        required String name,
        required String email,
        required String password,
        required String coachType,
        required String gender,
        required File? file,
        required String userType,
        // required String latitude,
        // required String longitude,
        // required String radius,
        required String about,
        required String chargesPerHours,
        required String phoneNumber,
        // required String address,
      }) async {
    isLoadingRegistation = true;
    notifyListeners();
    final data = FormData.fromMap({
      'name': name,
      'email': email,
      'password': password,
      'coachType': coachType,
      'gender': gender,
      if(file != null) 'image': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
      "phoneNumber": phoneNumber,
      "chargePerHour": chargesPerHours,
      "about": about,

    });
    Result result = await DioApi.post(path: ConfigUrl.coachSignUp, data: data);
    if (result.response != null) {
      log('Register Success $userType');
      // SharedPreferencesManager.setToken(token: result.response?.data['token']);
      // log("user Type : ${SharedPreferencesManager.getUserType()}");
      // SharedPreferencesManager.setUserType(userTpe: userType);
      // Utils.showSnackbarSucc(context, 'Login successful');

      Utils.toast(message: result.response?.data['message']);

      // Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EmailVerificationScreen(
                    email: email,
                    userType: userType,
                  )),
          // (route) => false,
      );

      isLoadingRegistation = false;
      notifyListeners();
    } else {
      result.handleError(context);
      isLoadingRegistation = false;
      notifyListeners();
    }
  }

  Future<void> registrationStudent(
    BuildContext context, {
    required String name,
    required String email,
    required String password,
    required String age,
    required String gender,
     File? file,
    required String phoneNumber,
    required String userType,
    required String latitude,
    required String longitude,
    required String radius,
    required String address,
  }) async {
    isLoadingRegistation = true;
    notifyListeners();
    final data = FormData.fromMap({
      'name': name,
      'email': email,
      'password': password,
      'age': age,
      'gender': gender,
      if(file != null)'image': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
      "phoneNumber": phoneNumber,
      if (userType == Utils.parentsType) "role": userType,
    });
    Result result =
        await DioApi.post(path: ConfigUrl.studentSignup, data: data);
    if (result.response != null) {
      isLoadingRegistation = false;
      notifyListeners();
      log('Register Success $userType');
      // SharedPreferencesManager.setToken(token: result.response?.data['token']);
      log("user Type : ${SharedPreferencesManager.getUserType()}");
      SharedPreferencesManager.setUserType(userTpe: userType);

      final parentData = result.response?.data["user"];

      // Utils.showSnackbarSucc(context, 'Login successful');
      if (userType == Utils.parentsType) {
        // this fllow only parent side accaptible
        // Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChildSignUp(
                    parentId: parentData["_id"],
                    password: password,
                    userType: userType,
                    latitude: latitude,
                    longitude: longitude,
                    radius: radius,
                    email: email,
                    address: address,
                  )),
          // (route) => false,
        );
        return;
      }

      //  else {
      Utils.toast(message: result.response?.data['message']);

      // Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EmailVerificationScreen(
                    email: email,
                    userType: userType,
                  )),
          // (route) => false
      );
      // }

      isLoadingRegistation = false;
      notifyListeners();
    } else {
      isLoadingRegistation = false;
      notifyListeners();
      result.handleError(context);
    }
  }

  Future<void> addChildren(
    BuildContext context,
    bool isLast, {
    required String parentId,
    required String name,
    required String email,
    required String age,
    required String gender,
     File? file,
    required userType,
  }) async {
    isLoadingRegistation = true;
    notifyListeners();

    final data = FormData.fromMap({
      'name': name,
      'email': email,
      'parent': parentId,
      'age': age,
      'gender': gender,
      if(file != null )'image': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
    });

    final result = await DioApi.post(path: ConfigUrl.addChildren, data: data);

    print("isLast == $isLast");

    if (result.response != null) {
      if (isLast) {
        isLoadingRegistation = false;
        notifyListeners();
        Utils.toast(message: "An Email sent to your account please verify");
         Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => EmailVerificationScreen(
                      email: email,
                      userType: userType,
                    )),
            // (route) => false
        );
      }
    } else {
      isLoadingRegistation = false;
      notifyListeners();
      result.handleError(context);
    }
  }

  Future<void> addStudent(
    BuildContext context,
    bool isLast, {
    required String parentId,
    required String name,
    required String email,
    required String age,
    required String gender,
     File? file,
    required userType,
  }) async {
    isLoadingRegistation = true;
    notifyListeners();

    final data = FormData.fromMap({
      'name': name,
      'email': email,
      'parent': parentId,
      'age': age,
      'gender': gender,
     if(file != null) 'image': await MultipartFile.fromFile(file.path,
          filename: file.path.split('/').last),
    });

    final result = await DioApi.post(path: ConfigUrl.addChildren, data: data);

    print("isLast == $isLast");

    if (result.response != null) {
      if (isLast) {
        isLoadingRegistation = false;
        notifyListeners();

        if (isLast) {

          StudentListModel? studentList = await getStudentsList(parentId);

          if (studentList != null) {
            SharedPreferencesManager.setListStudent(studentList);
          }
          Utils.toast(message: "Student added successfully");
          Navigator.of(context).pop();
        }
      }
    } else {
      isLoadingRegistation = false;
      notifyListeners();
      result.handleError(context);
    }
  }

  bool isLoadingForgetPassword = false;

  // forget password both side
  Future<void> forgetPassword(BuildContext context,
      {required String userType, required String email}) async {
    isLoadingForgetPassword = true;
    notifyListeners();

    Map<String, dynamic> data = {"email": email};

    Result result = await DioApi.get(
        path: userType == Utils.coachType
            ? ConfigUrl.coachForgetPassword
            : ConfigUrl.studentForegetpassword,
        data: data);
    if (result.response != null) {
      isLoadingForgetPassword = false;
      notifyListeners();
      // coach type follow
      if (userType == Utils.coachType) {
        bool? isClose = await Dialogs.showSuccessDialog(context,
            title: result.response?.data['message'], subtitle: '');
        if (isClose == true) {
          Navigator.pop(context);
        }
      } else {
        bool? isClose = await Dialogs.showSuccessDialog(context,
            title: result.response?.data['message'], subtitle: '');
        if (isClose == true) {
          Navigator.pop(context);
        }
        // Navigator.pushNamed(
        //   context,
        // );
        // StudentListModel studentListModel =
        //     StudentListModel.fromJson(result.response?.data);
        // showStdentListDialog(context,
        //     studentListModel: studentListModel, password: '');

        // Navigator.popUntil(context, (route) => route.isFirst);
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const StudentBottomNavbar()),
        //     (route) => false);
      }
    } else {
      result.handleError(context);
      isLoadingForgetPassword = false;
      notifyListeners();
    }
  }

  bool canResendEmail() {
    if (_lastResendTime == null) {
      return true;
    }
    final now = DateTime.now();
    final difference = now.difference(_lastResendTime!);
    return difference >= _resendCooldown;
  }

  Duration? getRemainingCooldown() {
    if (_lastResendTime == null) {
      return null;
    }
    final now = DateTime.now();
    final difference = now.difference(_lastResendTime!);
    if (difference >= _resendCooldown) {
      return null;
    }
    return _resendCooldown - difference;
  }

  Future<void> resendVerificationEmail(
    BuildContext context, {
    required String email,
    required String userType,
  }) async {
    if (!canResendEmail()) {
      final remaining = getRemainingCooldown();
      if (remaining != null) {
        final seconds = remaining.inSeconds;
        Utils.toast(
          message: 'Please wait ${seconds} seconds before resending',
        );
      }
      return;
    }

    Map<String, dynamic> data = {"email": email};

    String path = userType == Utils.coachType
        ? '/coach/resend-verification'
        : '/student/resend-verification';

    Result result = await DioApi.post(path: path, data: data);
    if (result.response != null) {
      _lastResendTime = DateTime.now();
      notifyListeners();
      Utils.toast(
        message: result.response?.data['message'] ?? 'Verification email sent successfully',
      );
    } else {
      result.handleError(context);
    }
  }

  Future<void> coachFCMTOKEN({
    required String fcmToken,
  }) async {
    var data = FormData.fromMap({
      if (fcmToken.isNotEmpty) "fcmToken": fcmToken,
    });
    log("tokenFCM TOKEN $fcmToken ");

    await DioApi.put(path: ConfigUrl.coachProfileUpdate, data: data);
  }
}


Future<void> studentFcmToken({
    required String fcmToken,
   required BuildContext context
  }) async {
    var data = FormData.fromMap({
      if (fcmToken.isNotEmpty) "fcmToken": fcmToken,
    });
    log("tokenFCM TOKEN $fcmToken ");
    logger.e("fcm token by student2 $fcmToken");

    Result result =
        await DioApi.put(path: ConfigUrl.updateStudentProfile, data: data);
    
    if(result.response  != null) { 
      
    }else { 
      result.handleError(context);
    }
  }


final authNotifier = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider();
});
