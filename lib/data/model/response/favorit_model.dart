class FavoritModel {
  int _id;
  int _idUser;
  int _umur;
  String _lokasi;
  String _kategori;

  FavoritModel({
    int id,
    int idUser,
    int umur,
    String lokasi,
    String kategori,
  }) {
    this._id = id;
    this._idUser = idUser;
    this._umur = umur;
    this._lokasi = lokasi;
    this._kategori = kategori;
  }

  int get id => _id;
  int get idUser => _idUser;
  int get umur => _umur;
  String get lokasi => _lokasi;
  String get kategori => _kategori;

  FavoritModel.fromJson(Map<String, dynamic> json) {
    _id = int.parse(json['id'].toString());
    _idUser = int.parse(json['id_user'].toString());
    _umur = int.parse((json['umur'] != null) ? json['umur'].toString() : '0');
    _lokasi = (json['lokasi'] != null) ? json['lokasi'].toString() : null;
    _kategori = (json['kategori'] != null) ? json['kategori'].toString() : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_user'] = this._idUser;
    data['id_user'] = (this._umur != null) ? this._umur : 0;
    data['lokasi'] = (this._lokasi != null) ? this._lokasi : null;
    data['kategori'] = this._kategori;
    return data;
  }
}
