import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:travel_admin/data/datasource/remote/dio/dio_client.dart';
import 'package:travel_admin/data/datasource/remote/exception/api_error_handler.dart';
import 'package:travel_admin/data/model/response/base/api_response.dart';
import 'package:travel_admin/utill/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> registration(
      String email, String password, int role) async {
    try {
      Response response = await dioClient.post(
        AppConstants.REGISTER_URI,
        data: {'email': email, 'password': password, 'role': role},
      ).timeout(const Duration(seconds: 10));
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(
          ApiErrorHandler.getMessage('Terjadi kesalahan'));
    }
  }

  Future<void> saveUserData(int idUser, String email) async {
    try {
      sharedPreferences.setString(AppConstants.ID_USER, idUser.toString());
      sharedPreferences.setString(AppConstants.EMAIL, email);
      print(
          'get user data >> ${sharedPreferences.getString(AppConstants.ID_USER)}, $email');
    } catch (e) {}
  }

  Future<ApiResponse> login(String email, String password) async {
    try {
      Response response = await dioClient.post(
        AppConstants.LOGIN_URI,
        data: {"email": email, "password": password},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> forgetPassword(String email) async {
    try {
      Response response = await dioClient
          .post(AppConstants.FORGET_PASSWORD_URI, data: {"email": email});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> resetPassword(
      String resetToken, String password, String confirmPassword) async {
    try {
      Response response = await dioClient.post(
        AppConstants.RESET_PASSWORD_URI,
        data: {
          "_method": "put",
          "reset_token": resetToken,
          "password": password,
          "confirm_password": confirmPassword
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  // for verify phone number
  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.ID_USER);
  }

  Future<bool> clearSharedData() async {
    await sharedPreferences.remove(AppConstants.ID_USER);
    await sharedPreferences.remove(AppConstants.EMAIL);
    return true;
  }
}
