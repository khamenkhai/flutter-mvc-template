import 'dart:convert';

class CustomLocation {
  final String placeId;
  final String streetOrRoad;
  final String townshipName;
  final String cityName;
  final double lat;
  final double long;

  CustomLocation({
    required this.placeId,
    required this.streetOrRoad,
    required this.townshipName,
    required this.cityName,
    required this.lat,
    required this.long,
  });

  // Method to convert the object into a Map
  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'streetOrRoad': streetOrRoad,
      'townshipName': townshipName,
      'cityName': cityName,
      'lat': lat,
      'long': long,
    };
  }

  // Factory constructor to create an instance from a Map
  factory CustomLocation.fromMap(Map<String, dynamic> map) {
    return CustomLocation(
      placeId: map['placeId'],
      streetOrRoad: map['streetOrRoad'],
      townshipName: map['townshipName'],
      cityName: map['cityName'],
      lat: map['lat'],
      long: map['long']
    );
  }

  // Method to convert the Map into a JSON string
  String toJsonString() {
    // Convert the map to JSON string using json.encode()
    return jsonEncode(toMap());
  }
}

// Method to convert a JSON string into a Map
Map<String, dynamic> jsonStringToMap(String jsonString) {
  return json.decode(jsonString);
}
