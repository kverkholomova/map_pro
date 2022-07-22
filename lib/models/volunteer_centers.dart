List<Location> LocationList = [
  Location(longitude: 54.468683, latitude: 17.028140, name: "Regionalne Centrum Wolontariatu", address: "aleja Henryka Sienkiewicza 6, 76-200 Słupsk"),
  Location(longitude: 54.452438, latitude: 17.041785, name: "Pomeranian Academy in Slupsk", address: "Krzysztofa Arciszewskiego, 76-200 Słupsk"),
  Location(longitude: 54.451206, latitude: 17.023427, name: "Municipal Family Assistance Center", address: "Słoneczna 15D, 76-200 Słupsk"),
  Location(longitude: 54.458005, latitude: 17.028482, name: "Zespół Szkół Technicznych", address: "Karola Szymanowskiego 5, 76-200 Słupsk")
];

class Location{
  double? longitude;
  double? latitude;
  String? name;
  String? address;

  Location({this.longitude, this.latitude, this.name, this.address});

  Location.fromJson(Map<String, dynamic> json){
    longitude = json['longitude'];
    latitude = json['latitude'];
    name = json['name'];
    address = json['address'];

  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude']=longitude;
    data['latitude']=latitude;
    data['name']=name;
    data['address']=address;
    return data;
  }
}