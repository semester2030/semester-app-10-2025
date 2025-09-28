// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestBookingModelImpl _$$RequestBookingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestBookingModelImpl(
      serviceType:
          $enumDecode(_$TransportationServiceTypeEnumMap, json['serviceType']),
      id: json['id'] as String?,
      addressType: json['addressType'] as String?,
      city: json['city'] as String?,
      schoolName: json['schoolName'] as String?,
      neighborhood: json['neighborhood'] as String?,
      areaDistrict: json['areaDistrict'] as String?,
      detailedAddress: json['detailedAddress'] as String?,
      userId: json['userId'] as String?,
      pickupAddress: json['pickupAddress'] == null
          ? null
          : AddressModel.fromJson(
              json['pickupAddress'] as Map<String, dynamic>),
      dropOffAddress: json['dropOffAddress'] == null
          ? null
          : AddressModel.fromJson(
              json['dropOffAddress'] as Map<String, dynamic>),
      selectedDate: json['selectedDate'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      selectedVehicleType: json['selectedVehicleType'] as String?,
      selectedServiceType: json['selectedServiceType'] as String?,
      selectedTripType: json['selectedTripType'] as String?,
      transportStartDate: json['transportStartDate'] as String?,
      transportStartTime: json['transportStartTime'] as String?,
      transportEndTime: json['transportEndTime'] as String?,
      selectedDriverGender: json['selectedDriverGender'] as String?,
      selectedSubscriptionPlan: json['selectedSubscriptionPlan'] as String?,
      selectedWorkSchedule: json['selectedWorkSchedule'] as String?,
      basePrice: (json['basePrice'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
      priceUnit: json['priceUnit'] as String?,
      numberOfHours: (json['numberOfHours'] as num?)?.toDouble(),
      pricePerHour: (json['pricePerHour'] as num?)?.toDouble(),
      driverId: json['driverId'] as String?,
      isTripStarted: json['isTripStarted'] as bool?,
      tripStartedAt: json['tripStartedAt'] == null
          ? null
          : DateTime.parse(json['tripStartedAt'] as String),
      tripEndedAt: json['tripEndedAt'] == null
          ? null
          : DateTime.parse(json['tripEndedAt'] as String),
      isDriverComing: json['isDriverComing'] as bool?,
      driverComingAt: json['driverComingAt'] == null
          ? null
          : DateTime.parse(json['driverComingAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      status: _statusFromJson(json['status'] as String?),
    );

Map<String, dynamic> _$$RequestBookingModelImplToJson(
        _$RequestBookingModelImpl instance) =>
    <String, dynamic>{
      'serviceType': _$TransportationServiceTypeEnumMap[instance.serviceType]!,
      'id': instance.id,
      'addressType': instance.addressType,
      'city': instance.city,
      'schoolName': instance.schoolName,
      'neighborhood': instance.neighborhood,
      'areaDistrict': instance.areaDistrict,
      'detailedAddress': instance.detailedAddress,
      'userId': instance.userId,
      'pickupAddress': instance.pickupAddress,
      'dropOffAddress': instance.dropOffAddress,
      'selectedDate': instance.selectedDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'selectedVehicleType': instance.selectedVehicleType,
      'selectedServiceType': instance.selectedServiceType,
      'selectedTripType': instance.selectedTripType,
      'transportStartDate': instance.transportStartDate,
      'transportStartTime': instance.transportStartTime,
      'transportEndTime': instance.transportEndTime,
      'selectedDriverGender': instance.selectedDriverGender,
      'selectedSubscriptionPlan': instance.selectedSubscriptionPlan,
      'selectedWorkSchedule': instance.selectedWorkSchedule,
      'basePrice': instance.basePrice,
      'finalPrice': instance.finalPrice,
      'priceUnit': instance.priceUnit,
      'numberOfHours': instance.numberOfHours,
      'pricePerHour': instance.pricePerHour,
      'driverId': instance.driverId,
      'isTripStarted': instance.isTripStarted,
      'tripStartedAt': instance.tripStartedAt?.toIso8601String(),
      'tripEndedAt': instance.tripEndedAt?.toIso8601String(),
      'isDriverComing': instance.isDriverComing,
      'driverComingAt': instance.driverComingAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'status': _statusToJson(instance.status),
    };

const _$TransportationServiceTypeEnumMap = {
  TransportationServiceType.student: 'student',
  TransportationServiceType.teacher: 'teacher',
  TransportationServiceType.employee: 'employee',
  TransportationServiceType.daily: 'daily',
};
