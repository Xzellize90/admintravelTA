import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:travel_admin/data/model/response/content_model.dart';
import 'package:travel_admin/provider/content_provider.dart';
import 'package:travel_admin/utill/app_constants.dart';
import 'package:travel_admin/utill/styles.dart';
import 'package:travel_admin/view/base/custom_login_field.dart';
import 'package:travel_admin/view/base/custom_snackbar.dart';
import 'package:travel_admin/view/screens/dashboard_screen.dart';
import 'package:travel_admin/view/screens/location_picker.dart';

class ViewContent extends StatefulWidget {
  final ContentModel contentModel;
  ViewContent({Key key, @required this.contentModel}) : super(key: key);

  @override
  State<ViewContent> createState() => _ViewContentState();
}

class _ViewContentState extends State<ViewContent> {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  File file;
  final picker = ImagePicker();

  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: AppConstants.API_KEY);
  TextEditingController _judulController = TextEditingController();
  TextEditingController _umurController = TextEditingController();
  TextEditingController _idLokasiController = TextEditingController();
  TextEditingController _idKategoriController = TextEditingController();
  TextEditingController _lokasiController = TextEditingController();
  TextEditingController _kategoriController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();
  TextEditingController _jamBukaController = TextEditingController();
  TextEditingController _currentUserController = TextEditingController();
  TextEditingController _deskripsiController = TextEditingController();
  double latitude = 0;
  double longitude = 0;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Address address;
  LatLng _currentPosition;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    _currentPosition = LatLng(
      double.parse(widget.contentModel.latitude),
      double.parse(widget.contentModel.longitude),
    );
    final Marker marker = Marker(
      markerId: MarkerId('lokasi'),
      position: _currentPosition,
    );
    markers[MarkerId('lokasi')] = marker;
    loadData();
  }

  void onError(PlacesAutocompleteResponse value) {
    _scaffoldKey.currentState
        // ignore: deprecated_member_use
        .showSnackBar(SnackBar(content: Text(value.errorMessage)));
  }

  @override
  void dispose() {
    _judulController.dispose();
    _umurController.dispose();
    _lokasiController.dispose();
    _kategoriController.dispose();
    _idLokasiController.dispose();
    _idKategoriController.dispose();
    _alamatController.dispose();
    _jamBukaController.dispose();
    _currentUserController.dispose();
    if (file != null) file.delete();
    super.dispose();
  }

  void loadData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _idKategoriController.text = widget.contentModel.idKategori;
      _idLokasiController.text = widget.contentModel.idLokasi;
      _judulController.text = widget.contentModel.judul;
      _kategoriController.text = widget.contentModel.kategori;
      _lokasiController.text = widget.contentModel.lokasi;
      _umurController.text = widget.contentModel.batasUmur;
      _deskripsiController.text = widget.contentModel.deskripsi;
      _jamBukaController.text = widget.contentModel.jamBuka;
      _currentUserController.text = widget.contentModel.currentUser;
      _alamatController.text = widget.contentModel.alamat;
    });
    Provider.of<ContentProvider>(context, listen: false).init();
  }

  _pickImage() async {
    var storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) {
      final pickedFile = await picker.getImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          maxHeight: 500,
          maxWidth: 500);
      if (pickedFile != null) {
        setState(() {
          file = File(pickedFile.path);
          print('file name >> ${file.path}}');
        });
      } else {
        print('No image selected.');
      }
    } else {
      await Permission.storage.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ContentProvider>(
      builder: (context, contentProvider, child) {
        return Stack(
          children: [
            Scaffold(
              resizeToAvoidBottomInset: true,
              key: _globalKey,
              body: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/image/home_bg.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                            color: Colors.orange,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                      'Back',
                                      style: rockSaltMedium.copyWith(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    widget.contentModel.judul,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: rockSaltMedium.copyWith(
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ketuk gambar untuk merubah gambar',
                                  style: rockSaltMedium.copyWith(fontSize: 18),
                                ),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: file != null
                                      ? Image.file(
                                          file,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          widget.contentModel.foto,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Deskripsi',
                                  style: rockSaltRegular.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                CustomLoginField(
                                  hintText: 'Deskripsi',
                                  maxLines: 5,
                                  controller: _deskripsiController,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.done,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Number Of Visitor',
                                  style: rockSaltRegular.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                CustomLoginField(
                                  hintText: 'Number Of Visitor',
                                  controller: _currentUserController,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.done,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Alamat',
                                  style: rockSaltRegular.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                CustomLoginField(
                                  readOnly: true,
                                  maxLines: 4,
                                  hintText: 'Alamat',
                                  controller: _alamatController,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.done,
                                  isShowSuffixIcon: true,
                                  isIcon: true,
                                  suffixIcon: Icons.pin_drop_outlined,
                                  onTap: () async {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LocationPicker(
                                          position: _currentPosition,
                                          addressLine:
                                              (_alamatController.text != null)
                                                  ? _alamatController.text
                                                  : widget.contentModel.alamat,
                                        ),
                                      ),
                                    );

                                    if (result is Prediction) {
                                      PlacesDetailsResponse detail =
                                          await _places.getDetailsByPlaceId(
                                              result.placeId);

                                      LatLng position = LatLng(
                                        detail.result.geometry.location.lat,
                                        detail.result.geometry.location.lng,
                                      );

                                      var addresses = await Geocoder.google(
                                              AppConstants.API_KEY,
                                              language: 'ID')
                                          .findAddressesFromQuery(
                                              result.description);

                                      address = addresses.first;

                                      if (result != null) {
                                        setState(() {
                                          _currentPosition = position;
                                          latitude = detail
                                              .result.geometry.location.lat;
                                          longitude = detail
                                              .result.geometry.location.lng;
                                          _alamatController.text =
                                              address.addressLine;
                                        });
                                      }
                                    }
                                  },
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Jam Buka',
                                  style: rockSaltRegular.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                CustomLoginField(
                                  hintText: 'Jam Buka',
                                  controller: _jamBukaController,
                                  inputType: TextInputType.name,
                                  inputAction: TextInputAction.done,
                                ),
                                SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        int idContent =
                                            int.parse(widget.contentModel.id);
                                        Map<String, dynamic> data;
                                        data = {
                                          'id_kategori': int.parse(
                                              _idKategoriController.text),
                                          'id_lokasi': int.parse(
                                              _idLokasiController.text),
                                          'judul': _judulController.text,
                                          'alamat': _alamatController.text,
                                          'max_visitor': int.parse(
                                              widget.contentModel.maxVisitor),
                                          'current_user': int.parse(
                                              _currentUserController.text),
                                          'batas_umur':
                                              int.parse(_umurController.text),
                                          'jam_buka': _jamBukaController.text,
                                          'deskripsi':
                                              _deskripsiController.text,
                                          'latitude': latitude,
                                          'longitude': longitude,
                                          'id_user': sharedPreferences
                                              .getString(AppConstants.ID_USER)
                                        };

                                        if (file != null) {
                                          String fileName =
                                              file.path.split('/').last;
                                          data['foto'] = [
                                            await MultipartFile.fromFile(
                                              file.path,
                                              filename: fileName,
                                            ),
                                          ];
                                        }

                                        // inisialisasi data
                                        FormData formData =
                                            FormData.fromMap(data);

                                        // proses update data
                                        await contentProvider
                                            .updateContent(idContent, formData)
                                            .then(
                                          (value) {
                                            if (value.isSuccess) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  backgroundColor: Colors.green,
                                                  duration: Duration(
                                                      milliseconds: 500),
                                                  content: Text(value.message),
                                                ),
                                              );
                                              Timer(
                                                  Duration(
                                                    milliseconds: 500,
                                                  ), () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DashboardScreen(
                                                            pageIndex: 1),
                                                  ),
                                                );
                                              });
                                            } else {
                                              showCustomSnackBar(
                                                value.message,
                                                context,
                                              );
                                            }
                                          },
                                        );
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 30),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 0),
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          'Update',
                                          style: rockSaltMedium.copyWith(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: () async {
                                        return showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (_) => deleteDialog(),
                                        );
                                      },
                                      child: Container(
                                        margin:
                                            EdgeInsets.only(top: 5, bottom: 30),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 0),
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          'Delete',
                                          style: rockSaltMedium.copyWith(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            // preloader sebalum pemrosesan data
            (contentProvider.isLoading)
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  )
                : Container(),
          ],
        );
      },
    );
  }

  AlertDialog deleteDialog() {
    return AlertDialog(
      title: Text(
        'Hapus wisata?',
        style: rockSaltMedium.copyWith(
          fontSize: 14,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text(
              'Anda ingin menghapus wisata ini?',
              style: rockSaltRegular,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Delete',
            style: rockSaltMedium.copyWith(
              fontSize: 14,
              color: Colors.orange,
            ),
          ),
          onPressed: () {
            // menutup layar sebelumnya
            Navigator.of(context).pop();
            // memanggil proses penghapusan data
            Provider.of<ContentProvider>(context, listen: false)
                .deleteContent(
              int.parse(widget.contentModel.id),
            )
                .then(
              (value) {
                if (value.isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      duration: Duration(milliseconds: 500),
                      content: Text(value.message),
                    ),
                  );
                  Timer(
                      Duration(
                        milliseconds: 500,
                      ), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardScreen(pageIndex: 1),
                      ),
                    );
                  });
                } else {
                  showCustomSnackBar(
                    value.message,
                    context,
                  );
                }
              },
            );
          },
        ),
        TextButton(
          child: Text(
            'Cancle',
            style: rockSaltMedium.copyWith(
              fontSize: 14,
              color: Colors.red,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
