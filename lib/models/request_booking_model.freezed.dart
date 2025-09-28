// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestBookingModel _$RequestBookingModelFromJson(Map<String, dynamic> json) {
  return _RequestBookingModel.fromJson(json);
}

/// @nodoc
mixin _$RequestBookingModel {
// Service Type
  TransportationServiceType get serviceType =>
      throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError; // Address Information
  String? get addressType =>
      throw _privateConstructorUsedError; // 'School', 'University', 'Others'
  String? get city => throw _privateConstructorUsedError;
  String? get schoolName => throw _privateConstructorUsedError;
  String? get neighborhood => throw _privateConstructorUsedError;
  String? get areaDistrict => throw _privateConstructorUsedError;
  String? get detailedAddress => throw _privateConstructorUsedError;
  String? get userId =>
      throw _privateConstructorUsedError; // Pickup and Drop-off Addresses with full details
  AddressModel? get pickupAddress => throw _privateConstructorUsedError;
  AddressModel? get dropOffAddress =>
      throw _privateConstructorUsedError; // Daily Transport specific
  String? get selectedDate => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError;
  String? get endTime =>
      throw _privateConstructorUsedError; // Student Transport specific
  String? get selectedVehicleType =>
      throw _privateConstructorUsedError; // 'Sedan Car', 'Small Van', 'Small Bus', 'Bus (Large)'
  String? get selectedServiceType =>
      throw _privateConstructorUsedError; // 'Private Transport', 'Group Transport'
  String? get selectedTripType =>
      throw _privateConstructorUsedError; // 'One Way', 'Round Trip'
  String? get transportStartDate => throw _privateConstructorUsedError;
  String? get transportStartTime => throw _privateConstructorUsedError;
  String? get transportEndTime =>
      throw _privateConstructorUsedError; // Teacher/Employee Transport specific
  String? get selectedDriverGender =>
      throw _privateConstructorUsedError; // 'Male', 'Female', 'Any'
  String? get selectedSubscriptionPlan =>
      throw _privateConstructorUsedError; // 'Monthly', 'Quarterly', 'Yearly'
  String? get selectedWorkSchedule =>
      throw _privateConstructorUsedError; // 'Morning', 'Evening', 'Flexible'
// Pricing
  double? get basePrice => throw _privateConstructorUsedError;
  double? get finalPrice => throw _privateConstructorUsedError;
  String? get priceUnit =>
      throw _privateConstructorUsedError; // 'Riyal', 'Riyal/Month', 'Riyal/Hour'
// Additional information
  double? get numberOfHours =>
      throw _privateConstructorUsedError; // For daily transport
  double? get pricePerHour =>
      throw _privateConstructorUsedError; // For daily transport
// Trip tracking
  String? get driverId =>
      throw _privateConstructorUsedError; // Driver who accepted the booking
  bool? get isTripStarted =>
      throw _privateConstructorUsedError; // Whether driver has started the trip
  DateTime? get tripStartedAt =>
      throw _privateConstructorUsedError; // When the trip was started
  DateTime? get tripEndedAt =>
      throw _privateConstructorUsedError; // When the trip was completed
  bool? get isDriverComing =>
      throw _privateConstructorUsedError; // Whether driver has clicked "I'm Coming"
  DateTime? get driverComingAt =>
      throw _privateConstructorUsedError; // When the driver clicked "I'm Coming"
// Booking status
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  BookingStatus? get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RequestBookingModelCopyWith<RequestBookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestBookingModelCopyWith<$Res> {
  factory $RequestBookingModelCopyWith(
          RequestBookingModel value, $Res Function(RequestBookingModel) then) =
      _$RequestBookingModelCopyWithImpl<$Res, RequestBookingModel>;
  @useResult
  $Res call(
      {TransportationServiceType serviceType,
      String? id,
      String? addressType,
      String? city,
      String? schoolName,
      String? neighborhood,
      String? areaDistrict,
      String? detailedAddress,
      String? userId,
      AddressModel? pickupAddress,
      AddressModel? dropOffAddress,
      String? selectedDate,
      String? startTime,
      String? endTime,
      String? selectedVehicleType,
      String? selectedServiceType,
      String? selectedTripType,
      String? transportStartDate,
      String? transportStartTime,
      String? transportEndTime,
      String? selectedDriverGender,
      String? selectedSubscriptionPlan,
      String? selectedWorkSchedule,
      double? basePrice,
      double? finalPrice,
      String? priceUnit,
      double? numberOfHours,
      double? pricePerHour,
      String? driverId,
      bool? isTripStarted,
      DateTime? tripStartedAt,
      DateTime? tripEndedAt,
      bool? isDriverComing,
      DateTime? driverComingAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
      BookingStatus? status});

  $AddressModelCopyWith<$Res>? get pickupAddress;
  $AddressModelCopyWith<$Res>? get dropOffAddress;
}

/// @nodoc
class _$RequestBookingModelCopyWithImpl<$Res, $Val extends RequestBookingModel>
    implements $RequestBookingModelCopyWith<$Res> {
  _$RequestBookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceType = null,
    Object? id = freezed,
    Object? addressType = freezed,
    Object? city = freezed,
    Object? schoolName = freezed,
    Object? neighborhood = freezed,
    Object? areaDistrict = freezed,
    Object? detailedAddress = freezed,
    Object? userId = freezed,
    Object? pickupAddress = freezed,
    Object? dropOffAddress = freezed,
    Object? selectedDate = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? selectedVehicleType = freezed,
    Object? selectedServiceType = freezed,
    Object? selectedTripType = freezed,
    Object? transportStartDate = freezed,
    Object? transportStartTime = freezed,
    Object? transportEndTime = freezed,
    Object? selectedDriverGender = freezed,
    Object? selectedSubscriptionPlan = freezed,
    Object? selectedWorkSchedule = freezed,
    Object? basePrice = freezed,
    Object? finalPrice = freezed,
    Object? priceUnit = freezed,
    Object? numberOfHours = freezed,
    Object? pricePerHour = freezed,
    Object? driverId = freezed,
    Object? isTripStarted = freezed,
    Object? tripStartedAt = freezed,
    Object? tripEndedAt = freezed,
    Object? isDriverComing = freezed,
    Object? driverComingAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as TransportationServiceType,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      addressType: freezed == addressType
          ? _value.addressType
          : addressType // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      schoolName: freezed == schoolName
          ? _value.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String?,
      neighborhood: freezed == neighborhood
          ? _value.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String?,
      areaDistrict: freezed == areaDistrict
          ? _value.areaDistrict
          : areaDistrict // ignore: cast_nullable_to_non_nullable
              as String?,
      detailedAddress: freezed == detailedAddress
          ? _value.detailedAddress
          : detailedAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      pickupAddress: freezed == pickupAddress
          ? _value.pickupAddress
          : pickupAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      dropOffAddress: freezed == dropOffAddress
          ? _value.dropOffAddress
          : dropOffAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedVehicleType: freezed == selectedVehicleType
          ? _value.selectedVehicleType
          : selectedVehicleType // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedServiceType: freezed == selectedServiceType
          ? _value.selectedServiceType
          : selectedServiceType // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedTripType: freezed == selectedTripType
          ? _value.selectedTripType
          : selectedTripType // ignore: cast_nullable_to_non_nullable
              as String?,
      transportStartDate: freezed == transportStartDate
          ? _value.transportStartDate
          : transportStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      transportStartTime: freezed == transportStartTime
          ? _value.transportStartTime
          : transportStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      transportEndTime: freezed == transportEndTime
          ? _value.transportEndTime
          : transportEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDriverGender: freezed == selectedDriverGender
          ? _value.selectedDriverGender
          : selectedDriverGender // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedSubscriptionPlan: freezed == selectedSubscriptionPlan
          ? _value.selectedSubscriptionPlan
          : selectedSubscriptionPlan // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedWorkSchedule: freezed == selectedWorkSchedule
          ? _value.selectedWorkSchedule
          : selectedWorkSchedule // ignore: cast_nullable_to_non_nullable
              as String?,
      basePrice: freezed == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      finalPrice: freezed == finalPrice
          ? _value.finalPrice
          : finalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      priceUnit: freezed == priceUnit
          ? _value.priceUnit
          : priceUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfHours: freezed == numberOfHours
          ? _value.numberOfHours
          : numberOfHours // ignore: cast_nullable_to_non_nullable
              as double?,
      pricePerHour: freezed == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as double?,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      isTripStarted: freezed == isTripStarted
          ? _value.isTripStarted
          : isTripStarted // ignore: cast_nullable_to_non_nullable
              as bool?,
      tripStartedAt: freezed == tripStartedAt
          ? _value.tripStartedAt
          : tripStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tripEndedAt: freezed == tripEndedAt
          ? _value.tripEndedAt
          : tripEndedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDriverComing: freezed == isDriverComing
          ? _value.isDriverComing
          : isDriverComing // ignore: cast_nullable_to_non_nullable
              as bool?,
      driverComingAt: freezed == driverComingAt
          ? _value.driverComingAt
          : driverComingAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get pickupAddress {
    if (_value.pickupAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.pickupAddress!, (value) {
      return _then(_value.copyWith(pickupAddress: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get dropOffAddress {
    if (_value.dropOffAddress == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.dropOffAddress!, (value) {
      return _then(_value.copyWith(dropOffAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RequestBookingModelImplCopyWith<$Res>
    implements $RequestBookingModelCopyWith<$Res> {
  factory _$$RequestBookingModelImplCopyWith(_$RequestBookingModelImpl value,
          $Res Function(_$RequestBookingModelImpl) then) =
      __$$RequestBookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {TransportationServiceType serviceType,
      String? id,
      String? addressType,
      String? city,
      String? schoolName,
      String? neighborhood,
      String? areaDistrict,
      String? detailedAddress,
      String? userId,
      AddressModel? pickupAddress,
      AddressModel? dropOffAddress,
      String? selectedDate,
      String? startTime,
      String? endTime,
      String? selectedVehicleType,
      String? selectedServiceType,
      String? selectedTripType,
      String? transportStartDate,
      String? transportStartTime,
      String? transportEndTime,
      String? selectedDriverGender,
      String? selectedSubscriptionPlan,
      String? selectedWorkSchedule,
      double? basePrice,
      double? finalPrice,
      String? priceUnit,
      double? numberOfHours,
      double? pricePerHour,
      String? driverId,
      bool? isTripStarted,
      DateTime? tripStartedAt,
      DateTime? tripEndedAt,
      bool? isDriverComing,
      DateTime? driverComingAt,
      DateTime? createdAt,
      DateTime? updatedAt,
      @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
      BookingStatus? status});

  @override
  $AddressModelCopyWith<$Res>? get pickupAddress;
  @override
  $AddressModelCopyWith<$Res>? get dropOffAddress;
}

/// @nodoc
class __$$RequestBookingModelImplCopyWithImpl<$Res>
    extends _$RequestBookingModelCopyWithImpl<$Res, _$RequestBookingModelImpl>
    implements _$$RequestBookingModelImplCopyWith<$Res> {
  __$$RequestBookingModelImplCopyWithImpl(_$RequestBookingModelImpl _value,
      $Res Function(_$RequestBookingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceType = null,
    Object? id = freezed,
    Object? addressType = freezed,
    Object? city = freezed,
    Object? schoolName = freezed,
    Object? neighborhood = freezed,
    Object? areaDistrict = freezed,
    Object? detailedAddress = freezed,
    Object? userId = freezed,
    Object? pickupAddress = freezed,
    Object? dropOffAddress = freezed,
    Object? selectedDate = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? selectedVehicleType = freezed,
    Object? selectedServiceType = freezed,
    Object? selectedTripType = freezed,
    Object? transportStartDate = freezed,
    Object? transportStartTime = freezed,
    Object? transportEndTime = freezed,
    Object? selectedDriverGender = freezed,
    Object? selectedSubscriptionPlan = freezed,
    Object? selectedWorkSchedule = freezed,
    Object? basePrice = freezed,
    Object? finalPrice = freezed,
    Object? priceUnit = freezed,
    Object? numberOfHours = freezed,
    Object? pricePerHour = freezed,
    Object? driverId = freezed,
    Object? isTripStarted = freezed,
    Object? tripStartedAt = freezed,
    Object? tripEndedAt = freezed,
    Object? isDriverComing = freezed,
    Object? driverComingAt = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? status = freezed,
  }) {
    return _then(_$RequestBookingModelImpl(
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as TransportationServiceType,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      addressType: freezed == addressType
          ? _value.addressType
          : addressType // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      schoolName: freezed == schoolName
          ? _value.schoolName
          : schoolName // ignore: cast_nullable_to_non_nullable
              as String?,
      neighborhood: freezed == neighborhood
          ? _value.neighborhood
          : neighborhood // ignore: cast_nullable_to_non_nullable
              as String?,
      areaDistrict: freezed == areaDistrict
          ? _value.areaDistrict
          : areaDistrict // ignore: cast_nullable_to_non_nullable
              as String?,
      detailedAddress: freezed == detailedAddress
          ? _value.detailedAddress
          : detailedAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String?,
      pickupAddress: freezed == pickupAddress
          ? _value.pickupAddress
          : pickupAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      dropOffAddress: freezed == dropOffAddress
          ? _value.dropOffAddress
          : dropOffAddress // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      selectedDate: freezed == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as String?,
      startTime: freezed == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String?,
      endTime: freezed == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedVehicleType: freezed == selectedVehicleType
          ? _value.selectedVehicleType
          : selectedVehicleType // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedServiceType: freezed == selectedServiceType
          ? _value.selectedServiceType
          : selectedServiceType // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedTripType: freezed == selectedTripType
          ? _value.selectedTripType
          : selectedTripType // ignore: cast_nullable_to_non_nullable
              as String?,
      transportStartDate: freezed == transportStartDate
          ? _value.transportStartDate
          : transportStartDate // ignore: cast_nullable_to_non_nullable
              as String?,
      transportStartTime: freezed == transportStartTime
          ? _value.transportStartTime
          : transportStartTime // ignore: cast_nullable_to_non_nullable
              as String?,
      transportEndTime: freezed == transportEndTime
          ? _value.transportEndTime
          : transportEndTime // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedDriverGender: freezed == selectedDriverGender
          ? _value.selectedDriverGender
          : selectedDriverGender // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedSubscriptionPlan: freezed == selectedSubscriptionPlan
          ? _value.selectedSubscriptionPlan
          : selectedSubscriptionPlan // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedWorkSchedule: freezed == selectedWorkSchedule
          ? _value.selectedWorkSchedule
          : selectedWorkSchedule // ignore: cast_nullable_to_non_nullable
              as String?,
      basePrice: freezed == basePrice
          ? _value.basePrice
          : basePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      finalPrice: freezed == finalPrice
          ? _value.finalPrice
          : finalPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      priceUnit: freezed == priceUnit
          ? _value.priceUnit
          : priceUnit // ignore: cast_nullable_to_non_nullable
              as String?,
      numberOfHours: freezed == numberOfHours
          ? _value.numberOfHours
          : numberOfHours // ignore: cast_nullable_to_non_nullable
              as double?,
      pricePerHour: freezed == pricePerHour
          ? _value.pricePerHour
          : pricePerHour // ignore: cast_nullable_to_non_nullable
              as double?,
      driverId: freezed == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String?,
      isTripStarted: freezed == isTripStarted
          ? _value.isTripStarted
          : isTripStarted // ignore: cast_nullable_to_non_nullable
              as bool?,
      tripStartedAt: freezed == tripStartedAt
          ? _value.tripStartedAt
          : tripStartedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tripEndedAt: freezed == tripEndedAt
          ? _value.tripEndedAt
          : tripEndedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isDriverComing: freezed == isDriverComing
          ? _value.isDriverComing
          : isDriverComing // ignore: cast_nullable_to_non_nullable
              as bool?,
      driverComingAt: freezed == driverComingAt
          ? _value.driverComingAt
          : driverComingAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BookingStatus?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestBookingModelImpl implements _RequestBookingModel {
  const _$RequestBookingModelImpl(
      {required this.serviceType,
      this.id,
      this.addressType,
      this.city,
      this.schoolName,
      this.neighborhood,
      this.areaDistrict,
      this.detailedAddress,
      this.userId,
      this.pickupAddress,
      this.dropOffAddress,
      this.selectedDate,
      this.startTime,
      this.endTime,
      this.selectedVehicleType,
      this.selectedServiceType,
      this.selectedTripType,
      this.transportStartDate,
      this.transportStartTime,
      this.transportEndTime,
      this.selectedDriverGender,
      this.selectedSubscriptionPlan,
      this.selectedWorkSchedule,
      this.basePrice,
      this.finalPrice,
      this.priceUnit,
      this.numberOfHours,
      this.pricePerHour,
      this.driverId,
      this.isTripStarted,
      this.tripStartedAt,
      this.tripEndedAt,
      this.isDriverComing,
      this.driverComingAt,
      this.createdAt,
      this.updatedAt,
      @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson) this.status});

  factory _$RequestBookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestBookingModelImplFromJson(json);

// Service Type
  @override
  final TransportationServiceType serviceType;
  @override
  final String? id;
// Address Information
  @override
  final String? addressType;
// 'School', 'University', 'Others'
  @override
  final String? city;
  @override
  final String? schoolName;
  @override
  final String? neighborhood;
  @override
  final String? areaDistrict;
  @override
  final String? detailedAddress;
  @override
  final String? userId;
// Pickup and Drop-off Addresses with full details
  @override
  final AddressModel? pickupAddress;
  @override
  final AddressModel? dropOffAddress;
// Daily Transport specific
  @override
  final String? selectedDate;
  @override
  final String? startTime;
  @override
  final String? endTime;
// Student Transport specific
  @override
  final String? selectedVehicleType;
// 'Sedan Car', 'Small Van', 'Small Bus', 'Bus (Large)'
  @override
  final String? selectedServiceType;
// 'Private Transport', 'Group Transport'
  @override
  final String? selectedTripType;
// 'One Way', 'Round Trip'
  @override
  final String? transportStartDate;
  @override
  final String? transportStartTime;
  @override
  final String? transportEndTime;
// Teacher/Employee Transport specific
  @override
  final String? selectedDriverGender;
// 'Male', 'Female', 'Any'
  @override
  final String? selectedSubscriptionPlan;
// 'Monthly', 'Quarterly', 'Yearly'
  @override
  final String? selectedWorkSchedule;
// 'Morning', 'Evening', 'Flexible'
// Pricing
  @override
  final double? basePrice;
  @override
  final double? finalPrice;
  @override
  final String? priceUnit;
// 'Riyal', 'Riyal/Month', 'Riyal/Hour'
// Additional information
  @override
  final double? numberOfHours;
// For daily transport
  @override
  final double? pricePerHour;
// For daily transport
// Trip tracking
  @override
  final String? driverId;
// Driver who accepted the booking
  @override
  final bool? isTripStarted;
// Whether driver has started the trip
  @override
  final DateTime? tripStartedAt;
// When the trip was started
  @override
  final DateTime? tripEndedAt;
// When the trip was completed
  @override
  final bool? isDriverComing;
// Whether driver has clicked "I'm Coming"
  @override
  final DateTime? driverComingAt;
// When the driver clicked "I'm Coming"
// Booking status
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final BookingStatus? status;

  @override
  String toString() {
    return 'RequestBookingModel(serviceType: $serviceType, id: $id, addressType: $addressType, city: $city, schoolName: $schoolName, neighborhood: $neighborhood, areaDistrict: $areaDistrict, detailedAddress: $detailedAddress, userId: $userId, pickupAddress: $pickupAddress, dropOffAddress: $dropOffAddress, selectedDate: $selectedDate, startTime: $startTime, endTime: $endTime, selectedVehicleType: $selectedVehicleType, selectedServiceType: $selectedServiceType, selectedTripType: $selectedTripType, transportStartDate: $transportStartDate, transportStartTime: $transportStartTime, transportEndTime: $transportEndTime, selectedDriverGender: $selectedDriverGender, selectedSubscriptionPlan: $selectedSubscriptionPlan, selectedWorkSchedule: $selectedWorkSchedule, basePrice: $basePrice, finalPrice: $finalPrice, priceUnit: $priceUnit, numberOfHours: $numberOfHours, pricePerHour: $pricePerHour, driverId: $driverId, isTripStarted: $isTripStarted, tripStartedAt: $tripStartedAt, tripEndedAt: $tripEndedAt, isDriverComing: $isDriverComing, driverComingAt: $driverComingAt, createdAt: $createdAt, updatedAt: $updatedAt, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestBookingModelImpl &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.addressType, addressType) ||
                other.addressType == addressType) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.schoolName, schoolName) ||
                other.schoolName == schoolName) &&
            (identical(other.neighborhood, neighborhood) ||
                other.neighborhood == neighborhood) &&
            (identical(other.areaDistrict, areaDistrict) ||
                other.areaDistrict == areaDistrict) &&
            (identical(other.detailedAddress, detailedAddress) ||
                other.detailedAddress == detailedAddress) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pickupAddress, pickupAddress) ||
                other.pickupAddress == pickupAddress) &&
            (identical(other.dropOffAddress, dropOffAddress) ||
                other.dropOffAddress == dropOffAddress) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.selectedVehicleType, selectedVehicleType) ||
                other.selectedVehicleType == selectedVehicleType) &&
            (identical(other.selectedServiceType, selectedServiceType) ||
                other.selectedServiceType == selectedServiceType) &&
            (identical(other.selectedTripType, selectedTripType) ||
                other.selectedTripType == selectedTripType) &&
            (identical(other.transportStartDate, transportStartDate) ||
                other.transportStartDate == transportStartDate) &&
            (identical(other.transportStartTime, transportStartTime) ||
                other.transportStartTime == transportStartTime) &&
            (identical(other.transportEndTime, transportEndTime) ||
                other.transportEndTime == transportEndTime) &&
            (identical(other.selectedDriverGender, selectedDriverGender) ||
                other.selectedDriverGender == selectedDriverGender) &&
            (identical(
                    other.selectedSubscriptionPlan, selectedSubscriptionPlan) ||
                other.selectedSubscriptionPlan == selectedSubscriptionPlan) &&
            (identical(other.selectedWorkSchedule, selectedWorkSchedule) ||
                other.selectedWorkSchedule == selectedWorkSchedule) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.finalPrice, finalPrice) ||
                other.finalPrice == finalPrice) &&
            (identical(other.priceUnit, priceUnit) ||
                other.priceUnit == priceUnit) &&
            (identical(other.numberOfHours, numberOfHours) ||
                other.numberOfHours == numberOfHours) &&
            (identical(other.pricePerHour, pricePerHour) ||
                other.pricePerHour == pricePerHour) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.isTripStarted, isTripStarted) ||
                other.isTripStarted == isTripStarted) &&
            (identical(other.tripStartedAt, tripStartedAt) ||
                other.tripStartedAt == tripStartedAt) &&
            (identical(other.tripEndedAt, tripEndedAt) ||
                other.tripEndedAt == tripEndedAt) &&
            (identical(other.isDriverComing, isDriverComing) ||
                other.isDriverComing == isDriverComing) &&
            (identical(other.driverComingAt, driverComingAt) ||
                other.driverComingAt == driverComingAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        serviceType,
        id,
        addressType,
        city,
        schoolName,
        neighborhood,
        areaDistrict,
        detailedAddress,
        userId,
        pickupAddress,
        dropOffAddress,
        selectedDate,
        startTime,
        endTime,
        selectedVehicleType,
        selectedServiceType,
        selectedTripType,
        transportStartDate,
        transportStartTime,
        transportEndTime,
        selectedDriverGender,
        selectedSubscriptionPlan,
        selectedWorkSchedule,
        basePrice,
        finalPrice,
        priceUnit,
        numberOfHours,
        pricePerHour,
        driverId,
        isTripStarted,
        tripStartedAt,
        tripEndedAt,
        isDriverComing,
        driverComingAt,
        createdAt,
        updatedAt,
        status
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestBookingModelImplCopyWith<_$RequestBookingModelImpl> get copyWith =>
      __$$RequestBookingModelImplCopyWithImpl<_$RequestBookingModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestBookingModelImplToJson(
      this,
    );
  }
}

abstract class _RequestBookingModel implements RequestBookingModel {
  const factory _RequestBookingModel(
      {required final TransportationServiceType serviceType,
      final String? id,
      final String? addressType,
      final String? city,
      final String? schoolName,
      final String? neighborhood,
      final String? areaDistrict,
      final String? detailedAddress,
      final String? userId,
      final AddressModel? pickupAddress,
      final AddressModel? dropOffAddress,
      final String? selectedDate,
      final String? startTime,
      final String? endTime,
      final String? selectedVehicleType,
      final String? selectedServiceType,
      final String? selectedTripType,
      final String? transportStartDate,
      final String? transportStartTime,
      final String? transportEndTime,
      final String? selectedDriverGender,
      final String? selectedSubscriptionPlan,
      final String? selectedWorkSchedule,
      final double? basePrice,
      final double? finalPrice,
      final String? priceUnit,
      final double? numberOfHours,
      final double? pricePerHour,
      final String? driverId,
      final bool? isTripStarted,
      final DateTime? tripStartedAt,
      final DateTime? tripEndedAt,
      final bool? isDriverComing,
      final DateTime? driverComingAt,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
      final BookingStatus? status}) = _$RequestBookingModelImpl;

  factory _RequestBookingModel.fromJson(Map<String, dynamic> json) =
      _$RequestBookingModelImpl.fromJson;

  @override // Service Type
  TransportationServiceType get serviceType;
  @override
  String? get id;
  @override // Address Information
  String? get addressType;
  @override // 'School', 'University', 'Others'
  String? get city;
  @override
  String? get schoolName;
  @override
  String? get neighborhood;
  @override
  String? get areaDistrict;
  @override
  String? get detailedAddress;
  @override
  String? get userId;
  @override // Pickup and Drop-off Addresses with full details
  AddressModel? get pickupAddress;
  @override
  AddressModel? get dropOffAddress;
  @override // Daily Transport specific
  String? get selectedDate;
  @override
  String? get startTime;
  @override
  String? get endTime;
  @override // Student Transport specific
  String? get selectedVehicleType;
  @override // 'Sedan Car', 'Small Van', 'Small Bus', 'Bus (Large)'
  String? get selectedServiceType;
  @override // 'Private Transport', 'Group Transport'
  String? get selectedTripType;
  @override // 'One Way', 'Round Trip'
  String? get transportStartDate;
  @override
  String? get transportStartTime;
  @override
  String? get transportEndTime;
  @override // Teacher/Employee Transport specific
  String? get selectedDriverGender;
  @override // 'Male', 'Female', 'Any'
  String? get selectedSubscriptionPlan;
  @override // 'Monthly', 'Quarterly', 'Yearly'
  String? get selectedWorkSchedule;
  @override // 'Morning', 'Evening', 'Flexible'
// Pricing
  double? get basePrice;
  @override
  double? get finalPrice;
  @override
  String? get priceUnit;
  @override // 'Riyal', 'Riyal/Month', 'Riyal/Hour'
// Additional information
  double? get numberOfHours;
  @override // For daily transport
  double? get pricePerHour;
  @override // For daily transport
// Trip tracking
  String? get driverId;
  @override // Driver who accepted the booking
  bool? get isTripStarted;
  @override // Whether driver has started the trip
  DateTime? get tripStartedAt;
  @override // When the trip was started
  DateTime? get tripEndedAt;
  @override // When the trip was completed
  bool? get isDriverComing;
  @override // Whether driver has clicked "I'm Coming"
  DateTime? get driverComingAt;
  @override // When the driver clicked "I'm Coming"
// Booking status
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  BookingStatus? get status;
  @override
  @JsonKey(ignore: true)
  _$$RequestBookingModelImplCopyWith<_$RequestBookingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
