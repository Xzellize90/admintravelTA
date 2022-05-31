class LokasiModel {
  int _id;
  String _lokasi;

  LokasiModel({int id, String lokasi}) {
    this._id = id;
    this._lokasi = lokasi;
  }

  int get id => _id;
  String get lokasi => _lokasi;

  LokasiModel.fromJson(Map<String, dynamic> json) {
    _id = int.parse(json['id'].toString());
    _lokasi = json['lokasi'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['lokasi'] = this._lokasi;
    return data;
  }
}
