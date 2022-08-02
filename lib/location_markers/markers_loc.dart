

// import 'dart:core';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MarkersCreate extends StatefulWidget {
//   LatLng? latLng;
//   String? name;
//   String? address;
//   String? image;
//   String? workHours;
//   PointLatLng? pointLatLng;
//   double? sizeContainer;
//   double? aspectRatio;
//
//   MarkersCreate(
//       {Key? key, required this.latLng, required this.name, required this.address, required this.image, required this.workHours, required this.pointLatLng, required this.sizeContainer, required this.aspectRatio})
//       : super(key: key);
//
//   @override
//   State<MarkersCreate> createState() => _MarkersCreateState();
// }
//
// class _MarkersCreateState extends State<MarkersCreate> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }




import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Set<LocationMarker> markersData={
  LocationMarker(latLng: LatLng(54.468683, 17.028140),
      name: "Regionalne Centrum Wolontariatu",
      address: "aleja Henryka Sienkiewicza 6, 76-200 Słupsk",
      image: "images/1.jpg",
      workHours: "9:00 - 15:00",
      pointLatLng: PointLatLng(54.468683, 17.028140))
};
class LocationMarker{
  LatLng? latLng;
  String? name;
  String? address;
  String? image;
  String? workHours;
  PointLatLng? pointLatLng;


  LocationMarker({this.latLng, this.name, this.address, this.image, this.workHours, this.pointLatLng});

  LocationMarker.fromJson(Map<String, dynamic> json){
    latLng= json['latLng'];
    name=json['name'];
    address=json['address'];
    image=json['image'];
    workHours=json['workHours'];
    pointLatLng=json['pointLatLng'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latLng']=latLng;
    data['name']=name;
    data['address']=address;
    data['image']=image;
    data['workHours']=workHours;
    data['pointLatLng']=pointLatLng;
    return data;
  }

}