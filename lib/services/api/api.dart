import 'dart:developer';

import 'package:dio/dio.dart';

import '../../SharedPref/Shared_pref.dart';
import '../../core/utils/utils.dart';
import 'dio.dart';

class DioApi {
  static Future<Result> post(
      {required String path,
      required dynamic data,
      Duration? sendTimeout,
      Duration? recvTimeout}) async {
    final token = SharedPreferencesManager.getToken();
    try {
      Response response = await DioConfig.dio.request(
        path,
        data: data,
        options: Options(
          sendTimeout: sendTimeout,
          receiveTimeout: recvTimeout,
          headers: {
            // "x-access-token": token,
            "Authorization": "Bearer $token",
          },
          method: 'POST',
        ),
      );
      DioException? err;

      return Result(response: response, dioError: err);
    } on DioException catch (e) {
      Response? response;

      try {
        if (e.response?.data != null && e.response!.data is Map) {
          final data = e.response!.data as Map;
          if (data.containsKey('error') && data['error'] is Map) {
            logger.e("response ${data['error']['message']?.toString()}");
          } else if (data.containsKey('message')) {
            logger.e("response ${data['message']?.toString()}");
          } else {
            logger.e("response ${e.response?.data?.toString()}");
          }
        } else if (e.response?.data != null) {
          // Handle non-Map responses (like HTML error pages)
          logger.e("response (non-Map): ${e.response?.data?.toString()}");
        }
      } catch (logError) {
        logger.e("response error: ${e.message}");
      }

      // Safely try to log error message without causing exceptions
      try {
        if (e.response?.data != null && e.response!.data is Map) {
          final data = e.response!.data as Map;
          if (data.containsKey('error') && data['error'] is Map) {
            logger.e("error message: ${data['error']['message']?.toString()}");
          }
        }
      } catch (logError) {
        // Ignore logging errors, don't let them break the flow
        logger.e("Could not log error details: ${logError.toString()}");
      }

      return Result(response: response, dioError: e);
    }
  }

  static Future<Result> get(
      {required String path,
      dynamic data,
      Map<String, dynamic>? queryParameters,
      Duration? sendTimeout,
      Duration? recvTimeout}) async {
    final token = SharedPreferencesManager.getToken();
    log(" token get  $token");
    try {
      Response response = await DioConfig.dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(
          sendTimeout: sendTimeout,
          receiveTimeout: recvTimeout,
          headers: {
            // "x-access-token": token
            "Authorization": "Bearer $token",
          },
          method: 'GET',
        ),
      );
      DioException? err;
      return Result(response: response, dioError: err);
    } on DioException catch (e) {
      Response? response;
      // logger.e("response ${e.response?.data['error']['message'].toString()}");
      return Result(response: response, dioError: e);
    }
  }

  static Future<Result> delete(
      {required String path,
      Duration? sendTimeout,
      Duration? recvTimeout}) async {
    final token = SharedPreferencesManager.getToken();
    log(token);
    try {
      Response response = await DioConfig.dio.request(
        path,
        options: Options(
          sendTimeout: sendTimeout,
          receiveTimeout: recvTimeout,
          headers: {
            // "x-access-token": token
            "Authorization": "Bearer $token",
          },
          method: 'DELETE',
        ),
      );
      DioException? err;
      return Result(response: response, dioError: err);
    } on DioException catch (e) {
      Response? response;
      logger.e("response ${e.response?.data['error']['message'].toString()}");
      return Result(response: response, dioError: e);
    }
  }

  static Future<Result> put(
      {required String path,
      dynamic data,
      Duration? sendTimeout,
      Duration? recvTimeout}) async {
    final token = SharedPreferencesManager.getToken();
    try {
      Response response = await DioConfig.dio.request(
        path,
        data: data,
        options: Options(
          sendTimeout: sendTimeout,
          receiveTimeout: recvTimeout,
          headers: {
            // "x-access-token": token
            "Authorization": "Bearer $token",
          },
          method: 'PUT',
        ),
      );
      DioException? err;
      return Result(response: response, dioError: err);
    } on DioException catch (e) {
      Response? response;
      logger.e("response ${e.response?.data['error']['message'].toString()}");
      return Result(response: response, dioError: e);
    }
  }

  static Future<Result> patch(
      {required String path,
      Duration? sendTimeout,
      Duration? recvTimeout}) async {
    final token = SharedPreferencesManager.getToken();
    log(token);
    try {
      Response response = await DioConfig.dio.request(
        path,
        options: Options(
          sendTimeout: sendTimeout,
          receiveTimeout: recvTimeout,
          headers: {
            // "x-access-token": token
            "Authorization": "Bearer $token",
          },
          method: 'PATCH',
        ),
      );
      DioException? err;
      return Result(response: response, dioError: err);
    } on DioException catch (e) {
      Response? response;
      logger.e("response ${e.response?.data['error']['message'].toString()}");
      return Result(response: response, dioError: e);
    }
  }
}
