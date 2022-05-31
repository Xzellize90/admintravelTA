import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:travel_admin/utill/app_constants.dart';
import 'package:shimmer/shimmer.dart';

class LocationPicker extends StatefulWidget {
  final LatLng position;
  final String addressLine;
  LocationPicker({Key key, this.position = null, this.addressLine = null})
      : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Completer<GoogleMapController> _mapController = Completer();
  final TextEditingController textController = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: AppConstants.API_KEY);
  LatLng currentLocation = null;

  int _markerIdCounter = 0;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  // ignore: unused_field
  Position _position;
  Prediction prediction;
  Address address;
  StreamSubscription _streamSubscription;
  LatLng searchLocation;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    // mendapatkan current location
    if (widget.position == null) {
      _streamSubscription = Geolocator.getPositionStream().listen(
        (Position position) {
          setState(
            () {
              _position = position;
              currentLocation = LatLng(position.latitude, position.longitude);

              if (position == null) {
                final coordinates =
                    new Coordinates(position.latitude, position.longitude);
                convertGeocodesToAddress(coordinates)
                    .then((value) => address = value);
                _streamSubscription.cancel();
              }
            },
          );
        },
      );
    } else {
      setState(() {
        currentLocation = widget.position;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.position == null) {
      _streamSubscription.cancel();
    }
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void _onMapCreated(GoogleMapController controller) async {
    // inisialisasi map
    _mapController.complete(controller);
    if (currentLocation != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = currentLocation;
      Marker marker = Marker(
          markerId: markerId,
          position: position,
          draggable: true,
          onTap: () {
            Navigator.pop(context, address);
          });
      setState(() {
        markers[markerId] = marker;
      });

      GoogleMapController controller = await _mapController.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 18.0),
        ),
      );
    }
  }

  Future<Address> convertGeocodesToAddress(Coordinates coordinates) async {
    // konversi coordinate ke alamat
    var addresses = await Geocoder.google(AppConstants.API_KEY, language: 'ID')
        .findAddressesFromCoordinates(coordinates);
    return addresses.first;
  }

  void _updatePosition(CameraPosition _position) {
    // update posisi kamera pada map
    if (markers.length > 0) {
      MarkerId markerId = MarkerId(_markerIdVal());
      Marker marker = markers[markerId];
      Marker updatedmarker = marker.copyWith(
        positionParam: _position.target,
      );
      setState(() {
        markers[markerId] = updatedmarker;

        final coordinates = new Coordinates(
            _position.target.latitude, _position.target.longitude);
        print(
            "hasil update: ${_position.target.latitude} ${_position.target.longitude}");
        convertGeocodesToAddress(coordinates).then((value) => address = value);
      });
    }
  }

  Future<void> _currentPosition() async {
    // mendapatkan posisi saat ini
    if (markers.length > 0) {
      MarkerId markerId = MarkerId(_markerIdVal());
      Marker marker = markers[markerId];
      Marker updatedmarker = marker.copyWith(
        positionParam: currentLocation,
      );
      final GoogleMapController controller = await _mapController.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: currentLocation, zoom: 18.0)));
      setState(() {
        markers[markerId] = updatedmarker;
      });
    }
  }

  void onError(PlacesAutocompleteResponse value) {
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text(value.errorMessage)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari lokasi wisata'),
      ),
      body: Container(
        child: Stack(
          children: [
            Container(
              child: currentLocation == null
                  // preload sebelum memproses peta
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  :
                  // menampilkan map
                  GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition:
                          CameraPosition(target: currentLocation, zoom: 18.0),
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      markers: Set<Marker>.of(markers.values),
                      onCameraMove: ((_position) => _updatePosition(_position)),
                      // myLocationButtonEnabled: true,
                      onMapCreated: _onMapCreated,
                    ),
            ),
            Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /* floating action button */
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          FloatingActionButton(
                            heroTag: 'currentButton',
                            onPressed: () {
                              _currentPosition();
                            },
                            child: Icon(
                              Icons.my_location_outlined,
                              color: Colors.red,
                              size: 20,
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                        20,
                        20,
                        20,
                        20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.8),
                              offset: Offset(3, 2),
                              blurRadius: 7)
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Lokasi wisata?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 10),
                                FlatButton(
                                  onPressed: () async {
                                    // melalkukan pencarian alamat pada
                                    // google maps
                                    isLoading = true;
                                    prediction = await PlacesAutocomplete.show(
                                      offset: 0,
                                      radius: 1000,
                                      context: context,
                                      apiKey: AppConstants.API_KEY,
                                      mode: Mode.overlay,
                                      onError: onError,
                                      types: [],
                                      strictbounds: false,
                                      region: "ID",
                                      language: "ID",
                                      components: [
                                        Component(Component.country, "ID"),
                                      ],
                                      hint: "Search Lokasi",
                                    );

                                    if (prediction != null) {
                                      PlacesDetailsResponse detail =
                                          await _places.getDetailsByPlaceId(
                                              prediction.placeId);

                                      MarkerId markerId =
                                          MarkerId(_markerIdVal());

                                      // konveri prediction menjadi latlang
                                      LatLng position = LatLng(
                                        detail.result.geometry.location.lat,
                                        detail.result.geometry.location.lng,
                                      );
                                      // inisialisasi data update marker
                                      Marker marker = Marker(
                                        markerId: markerId,
                                        position: position,
                                        draggable: true,
                                      );

                                      // update posisi kamera
                                      GoogleMapController controller =
                                          await _mapController.future;
                                      controller.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: position, zoom: 18.0),
                                        ),
                                      );

                                      // melakukan pencarian data alamat
                                      var addresses = await Geocoder.google(
                                              AppConstants.API_KEY,
                                              language: 'ID')
                                          .findAddressesFromQuery(
                                              prediction.description);

                                      setState(() {
                                        // melakukan update marker
                                        markers[markerId] = marker;
                                        // mengambil data alamat berdasarkan list yang diperoleh
                                        address = addresses.first;
                                        isLoading = false;
                                      });
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        size: 14,
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Cari",
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                  size: 3.0,
                                ),
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        (!isLoading)
                                            ? Text(
                                                (prediction != null)
                                                    ? address.addressLine
                                                    : (widget.addressLine !=
                                                            null)
                                                        ? widget.addressLine
                                                        : '-',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 3,
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ),
                                              )
                                            : shimmering(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          prediction != null
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // kembali kehalaman sebelumnya
                                        // dengan melakukan parsing data
                                        Navigator.pop(context, prediction);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "Pilih Lokasi",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  shimmering() {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Container(
            child: ClipRRect(
                borderRadius: new BorderRadius.circular(5),
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: 15,
                )),
          ),
        ),
        SizedBox(height: 5),
        Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Column(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: new BorderRadius.circular(5),
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
