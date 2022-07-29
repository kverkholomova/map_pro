


import 'dart:async';
import 'dart:developer';
import 'dart:math' show cos, sqrt, asin;

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';


import 'map_style.dart';

const LatLng _center = LatLng(54.4641, 17.0287);
bool isVisible = false;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();
  // GoogleMapController? mapController; //contrller for Google map
  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  LatLng? startLocation;
  LatLng? endLocation;

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }
  String googleApiKey = "AIzaSyDgTt2bcZuY9E80r1aglafLEyVd7g8Qcfk";
  GoogleMapController? mapController; //contrller for Google map
  Set<Marker> markers = {}; //markers for google map

  String mapStyle = '';
  Position? _currentPosition;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Image Marker on Google Map"),
      //   backgroundColor: Colors.deepPurpleAccent,
      // ),
      body: Stack(
        children: [
          GoogleMap(
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            polylines: Set<Polyline>.of(polylines.values),
            //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true,
            //enable Zoom in, out on map
            initialCameraPosition: const CameraPosition(
              //innital position in map
              // target: ,
              target: _center, //initial position
              zoom: 14.0, //initial zoom level
            ),
            markers: markers,
            //markers to show on map
            mapType: MapType.normal,
            //map type
            onMapCreated: (controller) {
              _customInfoWindowController.googleMapController = controller;
              controller.setMapStyle(MapStyle.mapStyles);
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            // height: 75,
            // width: 150,
            // offset: 50,
          ),
          Visibility(
            visible: isVisible,
            child: Positioned(
                bottom: MediaQuery.of(context).size.height * 0,
                left: MediaQuery.of(context).size.height * 0.08,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                    child: Card(
                      child: Container(
                          padding: const EdgeInsets.all(9),
                          child: Text("Total Distance: ${distance.toStringAsFixed(2)} KM",
                              style: const TextStyle(fontSize: 16, fontWeight:FontWeight.bold))
                      ),
                    )
                )
            ),
          )
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.0),
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurpleAccent,
          child: const Icon(
            Icons.location_searching,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _getCurrentLocation();
              // _determinePosition();
              // var a = _currentPosition as Position;

              // print(a);
              // if(_currentPosition!=null) {
              //   print("empty");
              // }
              // else{

              // }

              if (_currentPosition != null) {

                markers.add(Marker(
                    markerId: const MarkerId('Home'),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen,
                    ),
                    position: LatLng(_currentPosition?.latitude ?? 0.0,
                        _currentPosition?.longitude ?? 0.0)));
                mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                  target: LatLng(_currentPosition?.latitude ?? 0.0,
                      _currentPosition?.longitude ?? 0.0),
                  zoom: 15.0,
                )));
              }
            });
          },
        ),
      ),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Future<Position>?> _determinePosition() async {
    // _currentPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1);
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    // return await Geolocator.getCurrentPosition();
    return await _getCurrentLocation();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) {
      setState(() {
        _currentPosition = position;

      });
    }).catchError((e) {
      print(e);
    });

  }


  double distance = 0.0;
  List<LatLng> polylineCoordinates = [];



  ListView _buildBottonNavigationMethod(
      name, address, imageURL, workHours, point) {
    return ListView(
      // mainAxisSize: MainAxisSize.min,
      // mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Image.asset(
          imageURL,
          // width: 50.0,
          // height: 200.0,
          // fit: BoxFit.cover,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.maps_home_work_outlined),
            title: Text(name),
            subtitle: Text(address),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 80, bottom: 20.0),
          child: Align(
              alignment: Alignment.topLeft,
              child: Text("Work hours: $workHours")),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                minimumSize: const Size.fromHeight(50),
                // NEW
              ),
              onPressed: () async {
                isVisible = true;
                await getDirections(point);
                setState(() {
                  Navigator.pop(context);
                });

              },
              child: const Text(
                "Directions",
                style: TextStyle(fontSize: 14),
              )),
        )
      ],
    );
  }

  double totalDistance = 0.0;

// Calculating the total distance by adding the distance
// between small segments

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var a = 0.5 - cos((lat2 - lat1) * p)/2 +
        cos(lat1 * p) * cos(lat2 * p) *
            (1 - cos((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  getDirections(PointLatLng pointLatLng) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(_currentPosition != null ? _currentPosition!.latitude : 0,
          _currentPosition != null ? _currentPosition!.longitude : 0),
      pointLatLng,
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    _customInfoWindowController.googleMapController=mapController;
    addPolyLine(polylineCoordinates);

    double totalDistance = 0;
    for(var i = 0; i < polylineCoordinates.length-1; i++){
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i+1].latitude,
          polylineCoordinates[i+1].longitude);
    }
    // print("Final distance:");
    // print(totalDistance);

    setState(() {
      distance = totalDistance;
    });

  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {

    });
  }



  @override
  void initState() {
    // print(_currentPosition?.latitude);
    // _getCurrentLocation();

    addMarkers();
    super.initState();
    setState(() {
      _determinePosition();
    });
    DefaultAssetBundle.of(context).loadString('map_style.dart').then((string) {
      mapStyle = string;
    }).catchError((error) {
      log(error.toString());
    });
  }

  void mapCreated(GoogleMapController controller) {
    //set style on the map on creation to customize look showing only map features
    //we want to show.
    log(mapStyle);
    setState(() {
      mapController = controller;
      if (mapStyle != null) {
        mapController?.setMapStyle(mapStyle).then((value) {
          log("Map Style set");
        }).catchError(
                (error) => log("Error setting map style:$error"));
      } else {
        log("GoogleMapView:_onMapCreated: Map style could not be loaded.");
      }
    });
  }

  addMarkers() async {
    // BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
    //   ImageConfiguration(),
    //   "assets/images/bike.png",
    // );

    markers.add(custom_marker(LatLng(54.468683, 17.028140,),
        "Regionalne Centrum Wolontariatu",
        "aleja Henryka Sienkiewicza 6, 76-200 Słupsk",
        "images/1.jpg",
        "9:00 - 15:00",
        const PointLatLng(54.468683, 17.028140),0.60));

    markers.add(custom_marker(LatLng(54.452438, 17.041785), "Pomeranian Academy in Slupsk",
        "Krzysztofa Arciszewskiego, 76-200 Słupsk",
        "images/2.jpg",
        "9:00 - 15:00",
        const PointLatLng(54.452438, 17.041785),0.60));

    markers.add(custom_marker(LatLng(54.451206, 17.023427), "Municipal Family Assistance Center",
        "Słoneczna 15D, 76-200 Słupsk",
        "images/3.jpg",
        "9:00 - 15:00",
        const PointLatLng(54.451206, 17.023427),0.70));

    markers.add(custom_marker(LatLng(54.458005, 17.028482), "Zespół Szkół Technicznych",
        "Karola Szymanowskiego 5, 76-200 Słupsk",
        "images/4.jpg",
        "9:00 - 15:00",
        const PointLatLng(54.458005, 17.028482),0.57));

    // markers.add(Marker(
    //   //add start location marker
    //     markerId: MarkerId(const LatLng(54.452438, 17.041785).toString()),
    //     position: const LatLng(54.452438, 17.041785),
    //     //position of marker
    //     // rotation:-45,
    //     infoWindow: const InfoWindow(
    //       //popup info
    //       // title: "Pomeranian Academy in Slupsk",
    //       // snippet: "Krzysztofa Arciszewskiego, 76-200 Słupsk",
    //     ),
    //     icon: BitmapDescriptor.defaultMarker,
    //     onTap: () {
    //       showModalBottomSheet(
    //           isScrollControlled: true,
    //           context: context,
    //           builder: (builder) {
    //             return Wrap(children: <Widget>[
    //               SizedBox(
    //                 height: MediaQuery.of(context).size.height * 0.60,
    //                 child: _buildBottonNavigationMethod(
    //                     "Pomeranian Academy in Slupsk",
    //                     "Krzysztofa Arciszewskiego, 76-200 Słupsk",
    //                     "images/2.jpg",
    //                     "9:00 - 15:00",
    //                     const PointLatLng(54.452438, 17.041785)),
    //               )
    //             ]);
    //           });
    //     }));

    // String imgurl = "https://www.fluttercampus.com/img/car.png";
    // Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl))
    //     .load(imgurl))
    //     .buffer
    //     .asUint8List();

    // markers.add(Marker(
    //   //add start location marker
    //     markerId: MarkerId(const LatLng(54.451206, 17.023427).toString()),
    //     position: const LatLng(54.451206, 17.023427),
    //     //position of marker
    //     infoWindow: const InfoWindow(
    //       //popup info
    //       // title: "Municipal Family Assistance Center",
    //       // snippet: "Słoneczna 15D, 76-200 Słupsk",
    //     ),
    //     icon: BitmapDescriptor.defaultMarker,
    //     onTap: () {
    //       showModalBottomSheet(
    //           isScrollControlled: true,
    //           context: context,
    //           builder: (builder) {
    //             return Wrap(children: <Widget>[
    //               SizedBox(
    //                 height: MediaQuery.of(context).size.height * 0.70,
    //                 child: _buildBottonNavigationMethod(
    //                     "Municipal Family Assistance Center",
    //                     "Słoneczna 15D, 76-200 Słupsk",
    //                     "images/3.jpg",
    //                     "9:00 - 15:00",
    //                     const PointLatLng(54.451206, 17.023427)),
    //               )
    //             ]);
    //           });
    //     } //Icon for Marker
    // ));
    // markers.add(Marker(
    //   //add start location marker
    //     markerId: MarkerId(const LatLng(54.458005, 17.028482).toString()),
    //     position: const LatLng(54.458005, 17.028482),
    //     //position of marker
    //     infoWindow: const InfoWindow(
    //       //popup info
    //       // title: "Zespół Szkół Technicznych",
    //       // snippet: "Karola Szymanowskiego 5, 76-200 Słupsk",
    //     ),
    //     icon: BitmapDescriptor.defaultMarker,
    //     onTap: () {
    //       showModalBottomSheet(
    //           isScrollControlled: true,
    //           context: context,
    //           builder: (builder) {
    //             return Wrap(children: <Widget>[
    //               SizedBox(
    //                 height: MediaQuery.of(context).size.height * 0.57,
    //                 child: _buildBottonNavigationMethod(
    //                     "Zespół Szkół Technicznych",
    //                     "Karola Szymanowskiego 5, 76-200 Słupsk",
    //                     "images/4.jpg",
    //                     "9:00 - 15:00",
    //                     const PointLatLng(54.458005, 17.028482)),
    //               )
    //             ]);
    //           });
    //     } //Icon for Marker
    // ));

    setState(() {
      //refresh UI
    });
  }

  Marker custom_marker(LatLng latLng, String name, String address, String image, String workHours, PointLatLng pointLatLng, double sizeContainer) {
    return Marker(
    //add start location marker
      markerId: MarkerId(latLng.toString()),
      position: latLng,
      //position of marker
      infoWindow: const InfoWindow(
        //popup info
        // title: "Regionalne Centrum Wolontariatu",
        // snippet: "aleja Henryka Sienkiewicza 6, 76-200 Słupsk",
      ),
      icon: BitmapDescriptor.defaultMarker,
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            // elevation: 25,
            context: context,
            builder: (builder) {
              return Wrap(children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height * sizeContainer,
                  child: _buildBottonNavigationMethod(name,address,image,workHours,pointLatLng),
                ),
              ]);
            });
      } //Icon for Marker
  );
  }

}
