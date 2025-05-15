class GeoLocationModel {
  PlusCode? plusCode;
  List<Results>? results;
  String? status;

  GeoLocationModel({this.plusCode, this.results, this.status});

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) {
    return GeoLocationModel(
      plusCode: json['plus_code'] != null
          ? PlusCode.fromJson(json['plus_code'])
          : null,
      results: json['results'] != null
          ? (json['results'] as List)
              .map((v) => Results.fromJson(v))
              .toList()
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'plus_code': plusCode?.toJson(),
      'results': results?.map((v) => v.toJson()).toList(),
      'status': status,
    };
  }
}

class PlusCode {
  String? compoundCode;
  String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  factory PlusCode.fromJson(Map<String, dynamic> json) {
    return PlusCode(
      compoundCode: json['compound_code'],
      globalCode: json['global_code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compound_code': compoundCode,
      'global_code': globalCode,
    };
  }
}

class Results {
  List<AddressComponents>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  List<String>? types;
  PlusCode? plusCode;

  Results({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.types,
    this.plusCode,
  });

  factory Results.fromJson(Map<String, dynamic> json) {
    return Results(
      addressComponents: json['address_components'] != null
          ? (json['address_components'] as List)
              .map((v) => AddressComponents.fromJson(v))
              .toList()
          : null,
      formattedAddress: json['formatted_address'],
      geometry: json['geometry'] != null
          ? Geometry.fromJson(json['geometry'])
          : null,
      placeId: json['place_id'],
      types: List<String>.from(json['types'] ?? []),
      plusCode: json['plus_code'] != null
          ? PlusCode.fromJson(json['plus_code'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_components':
          addressComponents?.map((v) => v.toJson()).toList(),
      'formatted_address': formattedAddress,
      'geometry': geometry?.toJson(),
      'place_id': placeId,
      'types': types,
      'plus_code': plusCode?.toJson(),
    };
  }
}

class AddressComponents {
  String? longName;
  String? shortName;
  List<String>? types;

  AddressComponents({this.longName, this.shortName, this.types});

  factory AddressComponents.fromJson(Map<String, dynamic> json) {
    return AddressComponents(
      longName: json['long_name'],
      shortName: json['short_name'],
      types: List<String>.from(json['types'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'long_name': longName,
      'short_name': shortName,
      'types': types,
    };
  }
}

class Geometry {
  GelLocationData? location;
  String? locationType;
  Viewport? viewport;
  Viewport? bounds;

  Geometry({this.location, this.locationType, this.viewport, this.bounds});

  factory Geometry.fromJson(Map<String, dynamic> json) {
    return Geometry(
      location: json['location'] != null
          ? GelLocationData.fromJson(json['location'])
          : null,
      locationType: json['location_type'],
      viewport: json['viewport'] != null
          ? Viewport.fromJson(json['viewport'])
          : null,
      bounds: json['bounds'] != null ? Viewport.fromJson(json['bounds']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location?.toJson(),
      'location_type': locationType,
      'viewport': viewport?.toJson(),
      'bounds': bounds?.toJson(),
    };
  }
}

class GelLocationData {
  double? lat;
  double? lng;

  GelLocationData({this.lat, this.lng});

  factory GelLocationData.fromJson(Map<String, dynamic> json) {
    return GelLocationData(
      lat: json['lat'],
      lng: json['lng'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class Viewport {
  GelLocationData? northeast;
  GelLocationData? southwest;

  Viewport({this.northeast, this.southwest});

  factory Viewport.fromJson(Map<String, dynamic> json) {
    return Viewport(
      northeast: json['northeast'] != null
          ? GelLocationData.fromJson(json['northeast'])
          : null,
      southwest: json['southwest'] != null
          ? GelLocationData.fromJson(json['southwest'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'northeast': northeast?.toJson(),
      'southwest': southwest?.toJson(),
    };
  }
}
