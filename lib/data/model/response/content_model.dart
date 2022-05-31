import 'dart:io';

class ContentModel {
  String _id;
  String _idKategori;
  String _kategori;
  String _judul;
  String _maxVisitor;
  String _currentUser;
  String _lokasi;
  String _idLokasi;
  String _batasUmur;
  String _alamat;
  String _jamBuka;
  String _deskripsi;
  String _foto;
  String _latitude;
  String _longitude;
  String _idUser;
  String _createdAt;
  String _updatedAt;
  String _deletedAt;

  ContentModel({
    String id,
    String idKategori,
    String kategori,
    String judul,
    String maxVisitor,
    String currentUser,
    String lokasi,
    String idLokasi,
    String batasUmur,
    String alamat,
    String jamBuka,
    String deskripsi,
    String foto,
    String latitude,
    String longitude,
    String idUser,
    String createdAt,
    String updatedAt,
    String deletedAt,
  }) {
    this._id = id;
    this._idKategori = idKategori;
    this._kategori = kategori;
    this._judul = judul;
    this._maxVisitor = maxVisitor;
    this._currentUser = currentUser;
    this._idLokasi = idLokasi;
    this._lokasi = lokasi;
    this._batasUmur = batasUmur;
    this._alamat = alamat;
    this._jamBuka = jamBuka;
    this._deskripsi = deskripsi;
    this._foto = foto;
    this._latitude = latitude;
    this._longitude = longitude;
    this._idUser = idUser;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._deletedAt = deletedAt;
  }

  String get id => _id;
  String get idKategori => _idKategori;
  String get kategori => _kategori;
  String get judul => _judul;
  String get maxVisitor => _maxVisitor;
  String get currentUser => _currentUser;
  String get idLokasi => _idLokasi;
  String get lokasi => _lokasi;
  String get batasUmur => _batasUmur;
  String get alamat => _alamat;
  String get jamBuka => _jamBuka;
  String get deskripsi => _deskripsi;
  String get foto => _foto;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get idUser => _idUser;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get deletedAt => _deletedAt;

  ContentModel.fromJson(Map<String, dynamic> map) {
    _id = map['id'];
    _idKategori = map['id_kategori'];
    _kategori = map['kategori'];
    _judul = map['judul'];
    _maxVisitor = map['max_visitor'];
    _currentUser = map['current_user'];
    _idLokasi = map['id_lokasi'];
    _lokasi = map['lokasi'];
    _batasUmur = map['batas_umur'];
    _alamat = map['alamat'];
    _jamBuka = map['jam_buka'];
    _deskripsi = map['deskripsi'];
    _foto = map['foto'];
    _latitude = map['latitude'];
    _longitude = map['longitude'];
    _idUser = map['id_user'];
    _createdAt = map['created_at'];
    _updatedAt = map['updated_at'];
    _deletedAt = map['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_kategori'] = this._idKategori;
    data['kategori'] = this._kategori;
    data['judul'] = this._judul;
    data['max_visitor'] = this._maxVisitor;
    data['current_user'] = this._currentUser;
    data['id_lokasi'] = this._idLokasi;
    data['lokasi'] = this._lokasi;
    data['batas_umur'] = this._batasUmur;
    data['alamat'] = this._alamat;
    data['jamBuka'] = this._jamBuka;
    data['deskripsi'] = this._deskripsi;
    data['foto'] = this._foto;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['id_user'] = this._idUser;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['deleted_at'] = this._deletedAt;

    return data;
  }
}
