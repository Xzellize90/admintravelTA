import 'package:flutter/widgets.dart';
import 'package:travel_admin/data/model/response/base/api_response.dart';
import 'package:travel_admin/data/model/response/favorit_model.dart';
import 'package:travel_admin/data/model/response/response_model.dart';
import 'package:travel_admin/data/repo/favorit_repo.dart';

class FavoritProvider extends ChangeNotifier {
  final FavoritRepo favoritRepo;
  FavoritProvider({@required this.favoritRepo});

  dynamic _favoritList;
  bool _isLoading;

  dynamic get favoritList => _favoritList;
  bool get isLoading => _isLoading;

  Future<void> getFavorit() async {
    _isLoading = true;
    ApiResponse apiResponse = await favoritRepo.getFavorit();
    if (apiResponse.response.statusCode == 200 &&
        apiResponse.response.data['success']) {
      FavoritModel data =
          FavoritModel.fromJson(apiResponse.response.data['data']);
      _favoritList = null;
      if (data != null) {
        _favoritList = data;
      }
    } else {
      _favoritList = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<ResponseModel> updateFavorit(Map<String, dynamic> data) async {
    _isLoading = true;
    ApiResponse apiResponse = await favoritRepo.saveFavorit(data);
    ResponseModel responseModel;

    if (apiResponse.response.statusCode == 200 &&
        apiResponse.response.data['success']) {
      responseModel = ResponseModel(apiResponse.response.data['success'],
          apiResponse.response.data['message']);
    } else {
      responseModel = ResponseModel(apiResponse.response.data['success'],
          apiResponse.response.data['message']);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }
}
