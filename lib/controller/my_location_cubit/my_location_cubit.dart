// import 'package:bloc/bloc.dart';
// import 'package:flutter/foundation.dart';
// import 'package:project_frame/core/local_data/shared_prefs.dart';
// import 'package:project_frame/core/service/location_service.dart';
// import 'package:project_frame/models/response_models/custom_location.dart';
// import 'package:project_frame/models/response_models/geo_location_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// part 'my_location_state.dart';

// class MyLocationCubit extends Cubit<MyLocationState> {
//   final Location location;
//   final SharedPref sharedPref;
//   final LocationService locationService;

//   MyLocationCubit({
//     required this.location,
//     required this.sharedPref,
//     required this.locationService,
//   }) : super(MyLocationState(locationBottomPadding: 50));

//   /// cHECK LOCAL LOCATION IN THE GUEST STATE
//   Future<bool> checkLocation() async {
//     String locationData = sharedPref.getString(
//       key: sharedPref.locationKey,
//     );


//     if (location != "" && locationData != "") {
//       Map<String, dynamic> mapData = jsonStringToMap(locationData);
//       CustomLocation myLocation = CustomLocation.fromMap(mapData);
//       emit(
//         MyLocationState(
//           selectedLocation: LatLng(myLocation.lat, myLocation.long),
//           locationMarker: state.locationMarker,
//           cameraPosition: state.cameraPosition,
//           locationBottomPadding: 50,
//           myLocation: myLocation,
//           locationDataExist: true,
//         ),
//       );
//       return true;
//     } else {
//       return false;
//     }
//   }

//   ///SAVE MY LOCATION IN THE LOCAL DATA
//   Future<void> saveLocation() async {
//     if (state.myLocation != null) {
//       await sharedPref.setString(
//         value: "${state.myLocation!.toJsonString()}",
//         key: sharedPref.locationKey,
//       );
//     } else {}
//   }

//   //to get the currrent location
//   Future<void> getCurrentLocation({
//     GoogleMapController? mapController,
//   }) async {
//     debugPrint("getting current location");
//     bool locationStauts = await locationService.checkLocationService(
//       location: location,
//     );

//     if (locationStauts) {
//       // Fetch current location
//       LocationData position = await location.getLocation();

//       final LatLng newLocation = LatLng(
//         position.latitude ?? 0,
//         position.longitude ?? 0,
//       );

//       // Update map camera position and marker with the new location
//       GeoLocationModel? address = await locationService.getGeoLocation(
//         newLocation,
//       );

//       if (address != null) {
//         await updateLocation(
//           newLocation: newLocation,
//           mapController: mapController,
//           myLocation: CustomLocation(
//             placeId: "${processGeoLocationData(address)["place_id"]}",
//             streetOrRoad: "${processGeoLocationData(address)["street_name"]}",
//             townshipName: extractTownshipNameWithTown(address.results ?? []),
//             cityName: "",
//             lat: 0,
//             long: 0,
//           ),
//         );
//       } else {
//         await updateLocation(
//           newLocation: newLocation,
//           mapController: mapController,
//           myLocation: state.myLocation,
//         );
//       }
//     }
//   }

//   // Update location (marker, camera, and address)
//   Future<void> updateLocation({
//     required LatLng newLocation,
//     GoogleMapController? mapController,
//     CustomLocation? myLocation,
//   }) async {
//     final newCameraPosition = CameraPosition(target: newLocation, zoom: 17);
//     final newMarker = Marker(
//       markerId: const MarkerId("my_location"),
//       position: newLocation,
//       draggable: true,
//       onDragEnd: (newPosition) async {
//         // await updateLocation(
//         //   newLocation: newPosition,
//         //   mapController: mapController,
//         // );
//       },
//     );

//     // Update the map view
//     if (mapController != null) {
//       mapController.animateCamera(
//         CameraUpdate.newCameraPosition(newCameraPosition),
//       );
//     } else {}

//     // update the state with new location details
//     if (myLocation != null) {
//       emit(
//         MyLocationState(
//           selectedLocation: newLocation,
//           locationMarker: newMarker,
//           cameraPosition: newCameraPosition,
//           locationBottomPadding: 50,
//           myLocation: myLocation,
//           locationDataExist: state.locationDataExist ?? false,
//         ),
//       );
//     } else {
//       emit(
//         MyLocationState(
//           selectedLocation: newLocation,
//           locationMarker: newMarker,
//           cameraPosition: newCameraPosition,
//           locationBottomPadding: 50,
//           myLocation: state.myLocation,
//           locationDataExist: state.locationDataExist ?? false,
//         ),
//       );
//     }
//   }

//   // Handle camera move
//   void onCameraMove(CameraPosition position) async {
//     final LatLng newLocation = position.target;
//     emit(
//       MyLocationState(
//         selectedLocation: newLocation,
//         locationMarker: Marker(
//           markerId: const MarkerId("my_location"),
//           position: newLocation,
//         ),
//         cameraPosition: position,
//         locationBottomPadding: 80,
//         myLocation: state.myLocation,
//         locationDataExist: state.locationDataExist ?? false,
//       ),
//     );
//   }

//   // Handle camera move
//   void onCameraMoveStarted() async {
//     emit(
//       MyLocationState(
//         selectedLocation: state.selectedLocation,
//         locationMarker: Marker(
//           markerId: const MarkerId("my_location"),
//           position: LatLng(
//             state.selectedLocation?.latitude ?? 0,
//             state.selectedLocation?.longitude ?? 0,
//           ),
//         ),
//         cameraPosition: state.cameraPosition,
//         locationBottomPadding: 80,
//         myLocation: state.myLocation,
//         locationDataExist: state.locationDataExist ?? false,
//       ),
//     );
//   }

//   // Called when the camera stops moving
//   Future<GeoLocationModel?> onCameraIdle() async {
//     LatLng? newLocation = state.selectedLocation;

//     GeoLocationModel? address = await locationService.getGeoLocation(
//       newLocation,
//     );

//     emit(
//       MyLocationState(
//         selectedLocation: newLocation,
//         locationMarker: state.locationMarker,
//         cameraPosition: state.cameraPosition,
//         locationBottomPadding: 50,
//         myLocation: state.myLocation,
//         locationDataExist: state.locationDataExist ?? false,
//       ),
//     );

//     return address;
//   }

//   // Called when the camera stops moving
//   Future<bool> onConfirmAddress() async {
//     LatLng? newLocation = state.selectedLocation;

//     GeoLocationModel? address = await locationService.getGeoLocation(
//       newLocation,
//     );

//     if (address != null) {
//       emit(
//         MyLocationState(
//           selectedLocation: newLocation,
//           locationMarker: state.locationMarker,
//           cameraPosition: state.cameraPosition,
//           locationBottomPadding: 50,
//           locationDataExist: state.locationDataExist ?? false,
//           myLocation: CustomLocation(
//             placeId: "${processGeoLocationData(address)["place_id"]}",
//             streetOrRoad: "${processGeoLocationData(address)["street_name"]}",
//             townshipName: extractTownshipNameWithTown(address.results ?? []),
//             cityName: "",
//             lat: 0,
//             long: 0,
//           ),
//         ),
//       );
//       await saveLocation();
//       return true;
//     } else {
//       emit(
//         MyLocationState(
//           selectedLocation: newLocation,
//           locationMarker: state.locationMarker,
//           cameraPosition: state.cameraPosition,
//           locationBottomPadding: 50,
//           myLocation: state.myLocation,
//           locationDataExist: state.locationDataExist ?? false,
//         ),
//       );
//       return false;
//     }
//   }

//   // New method to select a new address
//   Future<void> selectNewAddress({
//     required LatLng newLocation,
//     required GoogleMapController mapController,
//   }) async {
//     // Create a new camera position centered around the new location
//     final newCameraPosition = CameraPosition(target: newLocation, zoom: 17);

//     // Create a new marker for the selected location
//     final newMarker = Marker(
//       markerId: const MarkerId("my_location"),
//       position: newLocation,
//       draggable: true,
//       onDragEnd: (newPosition) async {
//         // await selectNewAddress(
//         //   newLocation: newPosition,
//         //   mapController: mapController,
//         // );
//       },
//     );

//     // Update the map view to show the new location
//     mapController.animateCamera(
//       CameraUpdate.newCameraPosition(newCameraPosition),
//     );

//     // update state with the new location and address
//     emit(
//       MyLocationState(
//         selectedLocation: newLocation,
//         locationMarker: newMarker,
//         cameraPosition: newCameraPosition,
//         locationBottomPadding: 50,
//         myLocation: state.myLocation,
//         locationDataExist: state.locationDataExist ?? false,
//       ),
//     );
//   }
// }

// Map<String, String> processGeoLocationData(GeoLocationModel geoLocationModel) {
//   // Initialize variables to store the extracted values
//   String streetName = "";
//   String streetNo = "";
//   String roadName = "";
//   String townshipName = "";
//   String cityName = "";
//   String place_id = "";

//   // Iterate through the results in GeoLocationModel
//   geoLocationModel.results?.forEach((result) {
//     // Iterate through address components of each result
//     result.addressComponents?.forEach((component) {
//       // Check if component is a streetNo (route type)
//       if (component.types?.contains('street_number') == true) {
//         streetNo = component.longName ?? '';
//       }
//       // Check if component is a street name (route type)
//       if (component.types?.contains('route') == true) {
//         streetName = component.longName ?? '';
//         place_id = result.placeId.toString();
//       }

//       // Check if component is a locality (city name)
//       if (component.types?.contains('locality') == true) {
//         cityName = component.longName ?? '';
//       }

//       // Check if component is a township (administrative_area_level_3 or administrative_area_level_2)
//       if (component.types?.contains('administrative_area_level_3') == true) {
//         townshipName = component.longName ?? '';
//       } else if (component.types?.contains('administrative_area_level_2') ==
//           true) {
//         townshipName = component.longName ?? '';
//       }

//       // Check if component is a road name (administrative_area_level_1)
//       if (component.types?.contains('administrative_area_level_1') == true) {
//         roadName = component.longName ?? '';
//       }
//     });
//   });

//   // Print the extracted information
//   if (kDebugMode) {
//     print('Street Name: $streetName');
//     print('Road Name: $roadName');
//     print('Township Name: $townshipName');
//     print('City Name: $cityName');
//   }

//   // Return the extracted information as a map
//   return {
//     "street_name": streetName,
//     "street_no": streetNo,
//     "road_name": roadName,
//     "township_name": townshipName,
//     "city_name": cityName,
//     "place_id": place_id,
//   };
// }

// String extractTownshipNameWithTown(List<Results> results) {
//   // Iterate through the results
//   for (var result in results) {
//     // Iterate through the address components of each result
//     for (var component in result.addressComponents ?? []) {
//       // Check if the long_name or short_name contains 'town' (case-insensitive)
//       if (component.longName != null &&
//           component.longName!.toLowerCase().contains('town')) {
//         return component.longName!;
//       }
//       if (component.shortName != null &&
//           component.shortName!.toLowerCase().contains('town')) {
//         return component.shortName!;
//       }
//     }
//   }
//   // Return an empty string if no match is found
//   return '';
// }
