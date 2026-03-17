import 'package:coach_student/view/Auth/coach/RegisterCoach.dart';
import 'package:coach_student/view/Auth/SplashScreen.dart';
import 'package:coach_student/view/coach/bottom_navbar/coach_bottomnavbar.dart';
import 'package:coach_student/view/student_view/bottom_navbar/student_bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:coach_student/view/Auth/SelectCoachOrStudent.dart';
import 'package:coach_student/view/Auth/student/StudentFrontScreen.dart';
import '../view/Auth/RegisterScreen.dart';
import '../view/Auth/coach/CoachFrontScreen.dart';
import '../view/Auth/ForgotPassword.dart';
import '../view/Auth/LoginScreen.dart';
import '../view/Auth/parents/ParentsFrontScreen.dart';
import '../view/Auth/parents/registation_parents.dart';
import '../view/Auth/student/student_registation.dart';
import '../view/Auth/EmailVerificationScreen.dart';
import '../view/Auth/onboarding/onboarding_screen.dart';

class AppRoutes {
  static const String splashOneScreen = '/splash_one_screen';
  static const String onboardingScreen = '/onboarding_screen';
  // static const String selectCoachOrStudentScreen =
  //     '/select_coach_or_student_screen';

  static const String selectCoachOrStudentOneScreen =
      '/select_coach_or_student_one_screen';
// student side side
  static const String studentRegScreen = '/student_reg_screen';
  static const String studentSignup = '/studentSignup';
  static const String studentBottomNavBarScreen = '/student_home_bottomnavbar';

// coach side
  static const String coachAuthScreen = '/coach_auth_screen';
  static const String registerCoach = '/register_coach_info_screen';
  static const String coachBottomNavBar = '/coach_bottom_navbar';

  // parents registation
  static const String parentsRegistation = '/parent_regisrtation';
  // get started screens
  static const String parentsAuthScreen = '/parent_auth_screen';

// auth route
  static const String loginScreen = '/login_screen';
  static const String registationScreen = '/register_screen';
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String emailVerificationScreen = '/email_verification_screen';

  static Map<String, WidgetBuilder> routes = {
    splashOneScreen: (context) => const SplashOneScreen(),
    onboardingScreen: (context) => const OnboardingScreen(),
    // HomeNewUserTwoTabContainerPage(),
    selectCoachOrStudentOneScreen: (context) =>
        const SelectCoachOrStudentOneScreen(),

    // auth side
    registationScreen: (context) {
      final routes =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;

      return RegisterScreen(
        userType: routes['userType'] ?? "",
      );
    },
    parentsRegistation: (context) {
      final routes =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;

      return RegisterParents(
        email: routes['email'] ?? "",
        password: routes['password'] ?? "",
        userType: routes['userType'] ?? "",
      );
    },
    parentsAuthScreen: (context) {
      final routes =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;

      return ParentsAuthScreen(
        userType: routes['userType'] ?? "",
      );
    },

    loginScreen: (context) {

      final routes =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;

      return LoginScreen(
        userType: routes['userType'] ?? "",
      );
    },
    forgotPasswordScreen: (context) {
      final routes =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      return ForgotPasswordScreen(
        userType: routes['userType'] ?? "",
      );
    },
    emailVerificationScreen: (context) {
      final routes =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      return EmailVerificationScreen(
        email: routes['email'] ?? "",
        userType: routes['userType'] ?? "",
      );
    },

    // student side
    studentRegScreen: (context) {
      final routes =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;

      return StudentRegScreen(
        userType: routes['userType'] ?? "",
      );
    },
    studentBottomNavBarScreen: (context) => const StudentBottomNavbar(),
    // student signup

    studentSignup: (context) {
      final routes =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      return RegisterStudent(
        email: routes['email'] ?? "",
        password: routes['password'] ?? "",
        userType: routes['userType'] ?? "",
      );
    },

    // coach side
    registerCoach: (context) {
      final routes =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      return RegisterCoach(
        email: routes['email'] ?? "",
        password: routes['password'] ?? "",
        userType: routes['userType'] ?? "",
      );
    },

    coachAuthScreen: (context) {
      final routes =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      return CoachAuthScreen(
        userType: routes['userType'] ?? "",
      );
    },
    coachBottomNavBar: (context) => const CoachBottomNavbar(),
  };
}
