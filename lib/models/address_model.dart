import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    required String address,
    required String city,
    required String state,
    required String zipCode,
    @JsonKey(fromJson: _latLngFromJson, toJson: _latLngToJson)
    required LatLng coordinates,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);
}

// Helper functions for LatLng serialization
LatLng _latLngFromJson(Map<String, dynamic> json) {
  return LatLng(
    (json['latitude'] as num).toDouble(),
    (json['longitude'] as num).toDouble(),
  );
}

Map<String, dynamic> _latLngToJson(LatLng latLng) {
  return {
    'latitude': latLng.latitude,
    'longitude': latLng.longitude,
  };
}
