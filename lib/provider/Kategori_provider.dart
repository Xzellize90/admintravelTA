import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:travel_admin/data/model/response/base/api_response.dart';
import 'package:travel_admin/data/model/response/kategori_model.dart';
import 'package:travel_admin/data/repo/kategori_repo.dart';

class KategoriProvider extends ChangeNotifier {
  final KategoriRepo kategoriRepo;

  KategoriProvider({@required this.kategoriRepo});

  List<KategoriModel> _kategoriList;
  bool _isLoading;

  List<KategoriModel> get kategoriList => _kategoriList;
  bool get isLoading => _isLoading;

  Future<void> getKategoriList(bool reload) async {
    _isLoading = true;
    ApiResponse apiResponse = await kategoriRepo.getKategoriList();
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      if (apiResponse.response.data['success'] == true) {
        _kategoriList = [];
        apiResponse.response.data['data'].forEach((category) {
          _kategoriList.add(KategoriModel.fromJson(category));
        });
      } else {
        _kategoriList = [];
      }
    } else {
      _kategoriList = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
