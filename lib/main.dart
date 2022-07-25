import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

import 'package:map_pro/models/volunteer_centers.dart';


final LatLng _center = const LatLng(54.4641, 17.0287);
void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  GoogleMapController? mapController; //contrller for Google map
  Set<Marker> markers = Set(); //markers for google map
  //
  // LatLng startLocation = LatLng(27.6602292, 85.308027);
  // LatLng endLocation = LatLng(27.6599592, 85.3102498);
  // LatLng carLocation = LatLng(27.659470, 85.3077363);



  @override
  void initState() {
    addMarkers();
    super.initState();
  }

  addMarkers() async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/bike.png",
    );
    Column _buildBottonNavigationMethod(name, address) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.maps_home_work_outlined),
            title: Text(name),
            subtitle: Text(address),

          )
        ],
      );
    }

    markers.add(
        Marker( //add start location marker
          markerId: MarkerId(LatLng(54.468683, 17.028140).toString()),
          position: LatLng(54.468683, 17.028140), //position of marker
          infoWindow: InfoWindow( //popup info
            title: "Regionalne Centrum Wolontariatu",
            snippet: "aleja Henryka Sienkiewicza 6, 76-200 Słupsk",
          ),
          icon: BitmapDescriptor.defaultMarker,
            onTap: (){
              showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return Container(
                      child: _buildBottonNavigationMethod("Regionalne Centrum Wolontariatu", "aleja Henryka Sienkiewicza 6, 76-200 Słupsk"),
                    );});
            }//Icon for Marker
        )
    );

    markers.add(
        Marker( //add start location marker
          markerId: MarkerId(LatLng(54.452438, 17.041785).toString()),
          position: LatLng(54.452438, 17.041785), //position of marker
          // rotation:-45,
          infoWindow: InfoWindow( //popup info
            title: "Pomeranian Academy in Slupsk",
            snippet: "Krzysztofa Arciszewskiego, 76-200 Słupsk",
          ),
          icon: BitmapDescriptor.defaultMarker,
          onTap: (){
            showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return Container(
                    child: _buildBottonNavigationMethod("Pomeranian Academy in Slupsk", "Krzysztofa Arciszewskiego, 76-200 Słupsk"),
                  );});
          }
        )
    );




    // String imgurl = "https://www.fluttercampus.com/img/car.png";
    // Uint8List bytes = (await NetworkAssetBundle(Uri.parse(imgurl))
    //     .load(imgurl))
    //     .buffer
    //     .asUint8List();

    markers.add(
        Marker( //add start location marker
          markerId: MarkerId(LatLng(54.451206, 17.023427).toString()),
          position: LatLng(54.451206, 17.023427), //position of marker
          infoWindow: InfoWindow( //popup info
            title: "Municipal Family Assistance Center",
            snippet: "Słoneczna 15D, 76-200 Słupsk",
          ),
          icon: BitmapDescriptor.defaultMarker,
            onTap: (){
              showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return Container(
                      child: _buildBottonNavigationMethod("Municipal Family Assistance Center", "Słoneczna 15D, 76-200 Słupsk"),
                    );});
            }//Icon for Marker
        )
    );
    markers.add(
        Marker( //add start location marker
          markerId: MarkerId(LatLng(54.458005, 17.028482).toString()),
          position: LatLng(54.458005, 17.028482), //position of marker
          infoWindow: InfoWindow( //popup info
            title: "Zespół Szkół Technicznych",
            snippet: "Karola Szymanowskiego 5, 76-200 Słupsk",
          ),
          icon: BitmapDescriptor.defaultMarker,
            onTap: (){
              showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return Container(
                      child: _buildBottonNavigationMethod("Zespół Szkół Technicznych", "Karola Szymanowskiego 5, 76-200 Słupsk"),
                    );});
            }//Icon for Marker
        )
    );

    setState(() {
      //refresh UI
    });
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("Image Marker on Google Map"),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: GoogleMap( //Map widget from google_maps_flutter package
          zoomGesturesEnabled: true, //enable Zoom in, out on map
          initialCameraPosition: CameraPosition( //innital position in map
            target: _center, //initial position
            zoom: 14.0, //initial zoom level
          ),
          markers: markers, //markers to show on map
          mapType: MapType.normal, //map type
          onMapCreated: (controller) { //method called when map is created
            setState(() {
              mapController = controller;
            });
          },
        )
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:map_pro/models/volunteer_centers.dart';
//
//
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   late GoogleMapController mapController;
//
//   final LatLng _center = const LatLng(54.4641, 17.0287);
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Maps Sample App'),
//           backgroundColor: Colors.green[700],
//         ),
//         body: GoogleMap(
//           onMapCreated: _onMapCreated,
//           initialCameraPosition: CameraPosition(
//             target: _center,
//             zoom: 11.0,
//           ),
//           // markers: LocationList.toSet(),
//         ),
//       ),
//     );
//   }
// }
