abstract class ConfigUrl {
  const ConfigUrl._();

 static String url = "https://coach-backend-jnq6.onrender.com/api";
  // static String url = "http://192.168.0.110:8001/api";

  // 'https://coachus.onrender.com/api';
  // "http://192.168.0.9:8000/api";
  // "https://65c752a9e7c384aada6e63ae.mockapi.io/getCoach";

  static String baseUrl = url;

  // coachSide
  static String coachSignUp = '/coach/signup';
//  /coach/signup
  static String coachLogin = '/coach/signin';
  static String coachForgetPassword = '/coach/forget-password';

// coach setting side\
  static String coachPasswordChange = '/coach/change-password';
  static String senMail = '/coach/send-mail';
  static String coachDeleteAccount = '/coach/delete/me';
  static String cachProfileGet = '/coach/me';

  static String coachProfileUpdate = "/coach/update-profile";
  static String coachGetStaredAccount = "/stared/account";
  static String coachClassCoachschedule = "/coach/coach-schedule";
  static String classDetailsCoach = "/coach/coach-schedule";
  static String listOfStudentClient = "/coach/get-client";

  static String classAttendedStudent = "/coach/get-client-all-student";
  static String addParticipants = "/coach/add-participants";
  static String scheduleParticipants = "/coach/coach-schedule";
  static String addCreditsToClient(String studentId) =>
      "/coach/clients/$studentId/add-credits";
  static String studentGetByIdCoach = "/student/profile";
  static String upcommingClassCoach = "/coach/coach-upcomming-schedule";
  static String getTranscationHistory = "/get-transaction";
  static String getLowBalanceStudent = "/coach/get-low-balance-student";
  static String deleteBalanceStudent = "/payment/delete-pending-students/";
  static String collectFeeFromStudent = "/coach/add-participants";
  static String scheduleClassDelete = "/coach/coach-schedule";
  // /coach/coach-schedule

  // private note
  static String privateNote = "/coach/note";

// user side
  static String studentLogin = '/student/signin';
  static String studentSignup = '/student/signup';
  static String studentLoginWithProfile = '/student/get-signin';
  static String studentForegetpassword = '/student/forget-password';
  static String studentProfile = "/student/me";

  // /student/get-signin

  // google maps
  static String mapApiKey = "AIzaSyAA9UnJTpCP2kuhkB-sbvGOGG-o7EnzHuw";

  static String googleMap =
      "https://maps.googleapis.com/maps/api/place/autocomplete/json";

  //add children in parent
  static String addChildren = "/student/children/add";

  //add children
  static String address = "/student/children/add";

  //update student profile
  static String updateStudentProfile = "/student/update-profile";
  static String changePassword = "/student/change-password";
  static String deleteAccount = "/student/delete/me";

  //  student home page
  static String coachesList = "/student/coach-all";
  static String allCoachesList = "/coach/";
  static String notificationUrl = "/get-notification";

  static String coachesClassList = "/student/get-class";
  // fcm notification
  static String notificationFCM = "/send-notification";

  // payment updated
  static String paymentTokenUpdateStudent = "/student/save-payment";
  static String paymentTokenGetStudent = "/student/get/saved-payment";

  // referral class
  static String referralLink = "/referral/new";

  // payment coach side
  static String paypalConnected = "/payment/save-payment-info";
  static String paypalGetInfo = "/payment/get-payment-info";
  static String paypalWithdrawAmount = "/payment/withdraw-token";

  //Status of withdraw
  static String withdrawStatus = "/payment/withdraw-status";

  // Backend-Driven PayPal Flow
  static String createPayPalOrder = "/payment/create-order";
  static String verifySubscription = "/subscription/verify";
}
