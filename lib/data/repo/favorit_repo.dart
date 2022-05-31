import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_admin/data/datasource/remote/dio/dio_client.dart';
import 'package:travel_admin/data/datasource/remote/exception/api_error_handler.dart';
import 'package:travel_admin/data/model/response/base/api_response.dart';
import 'package:travel_admin/data/model/response/favorit_model.dart';
import 'package:travel_admin/utill/app_constants.dart';

class FavoritRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  FavoritRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getFavorit() async {
    try {
      print('user id >> ${sharedPreferences.getString(AppConstants.ID_USER)}');
      Response response = await dioClient.get(
        AppConstants.FAVORIT_URI,
        queryParameters: {
          "user_id": sharedPreferences.getString(AppConstants.ID_USER)
        },
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> saveFavorit(Map<String, dynamic> data) async {
    try {
      Map<String, dynamic> postData = {
        "user_id": sharedPreferences.getString(AppConstants.ID_USER),
        "umur": data['umur'],
        "lokasi": data['lokasi'],
        "kategori": data['kategori']
      };
      Response response = await dioClient.post(
        AppConstants.FAVORIT_URI,
        data: postData,
      );
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(e.toString());
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
