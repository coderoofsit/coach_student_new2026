import 'dart:async';
import 'dart:io';

import 'package:coach_student/core/app_export.dart';
import 'package:coach_student/main.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../SharedPref/Shared_pref.dart';
import '../../core/utils/utils.dart';
import '../../view/Auth/SplashScreen.dart';
import '../../widgets/dialogs.dart';
import 'configurl.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor();

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      SharedPreferencesManager.clearPref();
      // Token error detected
      // Redirect to login page
      navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (_) => const SplashOneScreen()),
      );
    }
    super.onError(err, handler);
  }
}

class DioConfig {
  static BaseOptions options = BaseOptions(
    baseUrl: ConfigUrl.baseUrl,
    // connectTimeout: const Duration(seconds: 1),
    // receiveTimeout: const Duration(seconds: 2),

    connectTimeout: const Duration(seconds: 60), // 60 seconds
    receiveTimeout: const Duration(seconds: 60), // 60 seconds
    receiveDataWhenStatusError: true,
  );

  static final Dio _dio = Dio(options)
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ))
    ..interceptors.add(TokenInterceptor());

  static get dio => _dio;
}

class Result {
  Response? response;
  DioException? dioError;
  Result({this.response, this.dioError});

  void handleError(BuildContext context) {
    print("url to be called ===${response?.realUri}");
    if (dioError != null) {
      final error = dioError!.error;
      print("error == $error");
      
      // Handle network errors
      if (error is SocketException) {
        Dialogs.errorDialog(context, 'Failed to connect to $appName servers.');
        return;
      } else if (error is TimeoutException || 
                 dioError!.type == DioExceptionType.connectionTimeout ||
                 dioError!.type == DioExceptionType.sendTimeout ||
                 dioError!.type == DioExceptionType.receiveTimeout) {
        Utils.showSnackbarErrror(context, 'something went wrong retry');
        return;
      }
      
      // Handle HTTP error responses
      if (dioError!.response != null) {
        final statusCode = dioError!.response!.statusCode;
        final responseData = dioError!.response!.data;
        
        // Handle 404 errors specifically
        if (statusCode == 404) {
          Dialogs.errorDialog(context, 'The requested resource was not found. Please check the server configuration.');
          return;
        }
        
        // Handle JSON error responses
        if (responseData is Map) {
          String? errMsg;
          
          try {
            if (responseData.containsKey('error') && responseData['error'] is Map) {
              errMsg = responseData['error']['message']?.toString();
            } else if (responseData.containsKey('message')) {
              errMsg = responseData['message']?.toString();
            }
          } catch (e) {
            print("Error parsing error message: $e");
          }

          print("ERR MSG: $errMsg");

          if (errMsg != null && errMsg.isNotEmpty) {
            // ignore: use_build_context_synchronously
            Dialogs.errorDialog(context, errMsg);
          } else {
            // ignore: use_build_context_synchronously
            Dialogs.errorDialog(context, 'An error occurred. Please try again.');
          }
          return;
        }
        
        // Handle non-JSON responses (like HTML error pages)
        String errorMessage = 'An error occurred';
        if (statusCode != null) {
          errorMessage = 'Server error (${statusCode}). Please try again.';
        }
        Dialogs.errorDialog(context, errorMessage);
        return;
      }
      
      // Fallback for other error types
      final errorMessage = dioError!.message ?? 'An unexpected error occurred. Please try again.';
      Dialogs.errorDialog(context, errorMessage);
    }
  }
}

class DioErrorWithMessage implements Exception {
  DioException dioError;
  String errorMessage;

  DioErrorWithMessage(this.dioError, this.errorMessage);
  static DioErrorWithMessage showException({required Result result}) {
    if (result.dioError?.error is SocketException) {
      throw DioErrorWithMessage(
          result.dioError!, ExceptionErrorString.socketErrorMessage);
    } else if (result.dioError?.error is TimeoutException) {
      throw DioErrorWithMessage(
          result.dioError!, ExceptionErrorString.timeOutErrorMessage);
    } else if (result.dioError!.response != null &&
        result.dioError!.response!.data is Map) {
      final errMsg = result.dioError!.response?.data['error'];
      throw DioErrorWithMessage(result.dioError!, errMsg);
    } else if (result.dioError?.response?.statusCode == 404) {
      throw DioErrorWithMessage(
          result.dioError!, ExceptionErrorString.notFoundErrorMessage);
    } else {
      throw Exception('There was a problem. Try again.');
    }
  }
}

class ExceptionErrorString {
  static const socketErrorMessage = 'Failed to connect to $appName servers.';
  static const timeOutErrorMessage = 'Request timed out. Try again.';
  static const notFoundErrorMessage = 'Resource not found';
}




 // ..interceptors.add(
  //   InterceptorsWrapper(
  //     onError: (DioException err, ErrorInterceptorHandler handler) {
  //       // log("dio error $err");

  //       if (err.response?.statusCode == 401) {
  //         SharedPreferencesManager.clearPref();
  //         navigatorKey.currentState!.pushReplacement(
  //           MaterialPageRoute(builder: (_) => const SplashOneScreen()),
  //         );
  //       }
  //       // super.onError(err, handler);
  //     },
  //   ),
  // );