import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:travel_admin/data/model/response/base/api_response.dart';
import 'package:travel_admin/data/model/response/lokasi_model.dart';
import 'package:travel_admin/data/repo/lokasi_repo.dart';

class LokasiProvider extends ChangeNotifier {
  final LokasiRepo lokasiRepo;

  LokasiProvider({@required this.lokasiRepo});

  List<LokasiModel> _lokasiList;
  bool _isLoading;

  List<LokasiModel> get lokasiList => _lokasiList;
  bool get isLoading => _isLoading;

  Future<void> getLokasiList(bool reload) async {
    _isLoading = true;
    ApiResponse apiResponse = await lokasiRepo.getLokasiList();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      if (apiResponse.response.data['success'] == true) {
        _lokasiList = [];
        apiResponse.response.data['data'].forEach((category) {
          _lokasiList.add(LokasiModel.fromJson(category));
        });
      } else {
        _lokasiList = [];
      }
    } else {
      _lokasiList = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
