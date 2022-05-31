class KategoriModel {
  int _id;
  String _kategori;

  KategoriModel({int id, String kategori}) {
    this._id = id;
    this._kategori = kategori;
  }

  int get id => _id;
  String get kategori => _kategori;

  KategoriModel.fromJson(Map<String, dynamic> json) {
    _id = int.parse(json['id'].toString());
    _kategori = json['kategori'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['kategori'] = this._kategori;
    return data;
  }
}
