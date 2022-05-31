import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_admin/data/datasource/remote/dio/dio_client.dart';
import 'package:meta/meta.dart';
import 'package:travel_admin/data/datasource/remote/exception/api_error_handler.dart';
import 'package:travel_admin/data/model/response/base/api_response.dart';
import 'package:travel_admin/utill/app_constants.dart';

class KategoriRepo {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;
  KategoriRepo({@required this.dioClient, @required this.sharedPreferences});

  Future<ApiResponse> getKategoriList() async {
    try {
      final response = await dioClient.get(AppConstants.CATEGORY_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
