import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_admin/data/datasource/remote/dio/dio_client.dart';
import 'package:travel_admin/data/datasource/remote/exception/api_error_handler.dart';
import 'package:travel_admin/data/model/response/base/api_response.dart';
import 'package:travel_admin/utill/app_constants.dart';

class ContentRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  ContentRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getContentList(
      String limit, String offset, String search) async {
    try {
      final response = await dioClient.get(
        AppConstants.CONTENT_URI + '/list',
        queryParameters: {
          'limit': limit,
          'offset': offset,
          'search': search,
          'user_id': sharedPreferences.getString(AppConstants.ID_USER),
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> createContent(FormData data) async {
    try {
      final response = await dioClient.post(
        AppConstants.CONTENT_URI,
        data: data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateContent(int contentId, FormData data) async {
    try {
      final response = await dioClient.post(
        AppConstants.UPDATE_CONTENT_URI,
        queryParameters: {'content_id': contentId},
        data: data,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> deleteContent(int contentId) async {
    try {
      final response = await dioClient.post(
        AppConstants.DELETE_CONTENT_URI,
        queryParameters: {'content_id': contentId},
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
