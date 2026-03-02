import 'dart:developer';
import 'package:coach_student/SharedPref/Shared_pref.dart';
import 'package:coach_student/core/utils/utils.dart';
import 'package:coach_student/services/notification_service/notification_service.dart';
import 'package:coach_student/services/api/api_serivce_export.dart';
import 'package:coach_student/theme/theme_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:ui';
import 'core/constants/constants.dart';
import 'firebase_options.dart';
import 'routes/app_routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  print(message.notification!.title.toString());
  print(message.notification!.body.toString());
  print(message.data.toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await initializeDateFormatting(defaultLocale);

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  // Set status bar style - dark icons on light background
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarIconBrightness:
          Brightness.dark, // Dark icons (for light background)
      statusBarBrightness: Brightness.light, // For iOS
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  await Future.wait([
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ),
    // NotificationController.initializeLocalNotifications(debug: true)
  ]);

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await SharedPreferencesManager().init();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  EasyLoading.instance.loadingStyle = EasyLoadingStyle.light;
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.wave;
  ThemeHelper().changeTheme('primary');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> _syncFcmTokenToBackend(String fcmToken) async {
    // On every sync attempt, only update if user is logged in and token is non-empty.
    final String authToken = SharedPreferencesManager.getToken();
    final String userType = SharedPreferencesManager.getUserType();

    if (authToken.isEmpty || fcmToken.isEmpty) return;

    try {
      final data = FormData.fromMap({"fcmToken": fcmToken});

      if (userType == Utils.coachType) {
        await DioApi.put(path: ConfigUrl.coachProfileUpdate, data: data);
      } else {
        // For students and parents we use the student profile endpoint
        await DioApi.put(path: ConfigUrl.updateStudentProfile, data: data);
      }
      logger.i("Synced FCM token to backend");
    } catch (e, stackTrace) {
      logger.e("Failed to sync FCM token to backend: $e\n$stackTrace");
    }
  }

  permissionNotifcation() async {
    NotificationServices notification = NotificationServices();

    // Initialize local notifications early for both iOS and Android
    await notification.initLocalNotifications(context);
    
    notification.forgroundMessage();
    notification.firebaseInit(context);
    notification.setupInteractMessage(context);
    notification.requestNotificationPermission();
    final String fcmToken = await notification.getDeviceToken();

    PermissionStatus status = await Permission.notification.request();
    logger.i("fcm permisiion Main $status");
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // On every app open, push the latest FCM token to the backend.
    await _syncFcmTokenToBackend(fcmToken);

    // Also listen for FCM token refresh events and resync automatically.
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      logger.i("FCM token refreshed: $newToken");
      await _syncFcmTokenToBackend(newToken);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    permissionNotifcation();
  }

  @override
  Widget build(BuildContext context) {
    log("token user :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: ${SharedPreferencesManager.getToken()}");
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Transparent status bar
        statusBarIconBrightness:
            Brightness.dark, // Dark icons (for light background)
        statusBarBrightness: Brightness.light, // For iOS
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        theme: theme,

        title: appName,
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),

        // home: const SplashOneScreen() ,
        initialRoute: AppRoutes.splashOneScreen,
        routes: AppRoutes.routes,
        // home: const PayPalConnectScreen(),
      ),
    );
  }
}
