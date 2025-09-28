// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewModelImpl _$$ReviewModelImplFromJson(Map<String, dynamic> json) =>
    _$ReviewModelImpl(
      id: json['id'] as String?,
      bookingId: json['bookingId'] as String,
      driverId: json['driverId'] as String,
      passengerId: json['passengerId'] as String,
      overallRating: (json['overallRating'] as num).toDouble(),
      driverCommunicationRating:
          (json['driverCommunicationRating'] as num).toDouble(),
      vehicleConditionRating:
          (json['vehicleConditionRating'] as num).toDouble(),
      reviewText: json['reviewText'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ReviewModelImplToJson(_$ReviewModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'driverId': instance.driverId,
      'passengerId': instance.passengerId,
      'overallRating': instance.overallRating,
      'driverCommunicationRating': instance.driverCommunicationRating,
      'vehicleConditionRating': instance.vehicleConditionRating,
      'reviewText': instance.reviewText,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
