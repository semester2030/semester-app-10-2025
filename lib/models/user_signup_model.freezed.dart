// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_signup_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSignupModel _$UserSignupModelFromJson(Map<String, dynamic> json) {
  return _UserSignupModel.fromJson(json);
}

/// @nodoc
mixin _$UserSignupModel {
  String? get id =>
      throw _privateConstructorUsedError; // Document ID from Firestore
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  bool get isDriver => throw _privateConstructorUsedError; // For students only
  String? get gender => throw _privateConstructorUsedError;
  String? get role =>
      throw _privateConstructorUsedError; // Student, Teacher, Employee
// For drivers only
  String? get vehicleMake => throw _privateConstructorUsedError;
  String? get vehicleModel => throw _privateConstructorUsedError;
  String? get vehicleYear =>
      throw _privateConstructorUsedError; // Location fields (cascading dropdowns)
  String? get region => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get district => throw _privateConstructorUsedError;
  String? get serviceType =>
      throw _privateConstructorUsedError; // Profile and documents
  String? get profilePicture => throw _privateConstructorUsedError;
  String? get IdImage =>
      throw _privateConstructorUsedError; // Driver documents (only for drivers)
  String? get drivingLicenseImage => throw _privateConstructorUsedError;
  String? get vehicleRegistrationImage => throw _privateConstructorUsedError;
  String? get vehiclePhotoImage =>
      throw _privateConstructorUsedError; // Available services for drivers
  List<String>? get availableServices =>
      throw _privateConstructorUsedError; // Location data for drivers
  Map<String, dynamic>? get currentLocation =>
      throw _privateConstructorUsedError; // Driver status and activity
  bool get isOnline => throw _privateConstructorUsedError;
  DateTime? get lastSeen => throw _privateConstructorUsedError;
  String? get fcmToken => throw _privateConstructorUsedError;
  DateTime? get tokenUpdatedAt =>
      throw _privateConstructorUsedError; // Verification flags
  bool get isEmailVerified => throw _privateConstructorUsedError;
  bool get isDocumentsVerified =>
      throw _privateConstructorUsedError; // Driver rating fields (only for drivers)
  double get averageRating => throw _privateConstructorUsedError;
  double get averageCommunicationRating => throw _privateConstructorUsedError;
  double get averageVehicleRating => throw _privateConstructorUsedError;
  int get totalReviews => throw _privateConstructorUsedError;
  int get totalTrips => throw _privateConstructorUsedError; // Timestamps
  DateTime? get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSignupModelCopyWith<UserSignupModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSignupModelCopyWith<$Res> {
  factory $UserSignupModelCopyWith(
          UserSignupModel value, $Res Function(UserSignupModel) then) =
      _$UserSignupModelCopyWithImpl<$Res, UserSignupModel>;
  @useResult
  $Res call(
      {String? id,
      String name,
      String email,
      String phoneNumber,
      String password,
      bool isDriver,
      String? gender,
      String? role,
      String? vehicleMake,
      String? vehicleModel,
      String? vehicleYear,
      String? region,
      String? city,
      String? district,
      String? serviceType,
      String? profilePicture,
      String? IdImage,
      String? drivingLicenseImage,
      String? vehicleRegistrationImage,
      String? vehiclePhotoImage,
      List<String>? availableServices,
      Map<String, dynamic>? currentLocation,
      bool isOnline,
      DateTime? lastSeen,
      String? fcmToken,
      DateTime? tokenUpdatedAt,
      bool isEmailVerified,
      bool isDocumentsVerified,
      double averageRating,
      double averageCommunicationRating,
      double averageVehicleRating,
      int totalReviews,
      int totalTrips,
      DateTime? createdAt});
}

/// @nodoc
class _$UserSignupModelCopyWithImpl<$Res, $Val extends UserSignupModel>
    implements $UserSignupModelCopyWith<$Res> {
  _$UserSignupModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? password = null,
    Object? isDriver = null,
    Object? gender = freezed,
    Object? role = freezed,
    Object? vehicleMake = freezed,
    Object? vehicleModel = freezed,
    Object? vehicleYear = freezed,
    Object? region = freezed,
    Object? city = freezed,
    Object? district = freezed,
    Object? serviceType = freezed,
    Object? profilePicture = freezed,
    Object? IdImage = freezed,
    Object? drivingLicenseImage = freezed,
    Object? vehicleRegistrationImage = freezed,
    Object? vehiclePhotoImage = freezed,
    Object? availableServices = freezed,
    Object? currentLocation = freezed,
    Object? isOnline = null,
    Object? lastSeen = freezed,
    Object? fcmToken = freezed,
    Object? tokenUpdatedAt = freezed,
    Object? isEmailVerified = null,
    Object? isDocumentsVerified = null,
    Object? averageRating = null,
    Object? averageCommunicationRating = null,
    Object? averageVehicleRating = null,
    Object? totalReviews = null,
    Object? totalTrips = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      isDriver: null == isDriver
          ? _value.isDriver
          : isDriver // ignore: cast_nullable_to_non_nullable
              as bool,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleMake: freezed == vehicleMake
          ? _value.vehicleMake
          : vehicleMake // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleModel: freezed == vehicleModel
          ? _value.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleYear: freezed == vehicleYear
          ? _value.vehicleYear
          : vehicleYear // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      district: freezed == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceType: freezed == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      IdImage: freezed == IdImage
          ? _value.IdImage
          : IdImage // ignore: cast_nullable_to_non_nullable
              as String?,
      drivingLicenseImage: freezed == drivingLicenseImage
          ? _value.drivingLicenseImage
          : drivingLicenseImage // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleRegistrationImage: freezed == vehicleRegistrationImage
          ? _value.vehicleRegistrationImage
          : vehicleRegistrationImage // ignore: cast_nullable_to_non_nullable
              as String?,
      vehiclePhotoImage: freezed == vehiclePhotoImage
          ? _value.vehiclePhotoImage
          : vehiclePhotoImage // ignore: cast_nullable_to_non_nullable
              as String?,
      availableServices: freezed == availableServices
          ? _value.availableServices
          : availableServices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      currentLocation: freezed == currentLocation
          ? _value.currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenUpdatedAt: freezed == tokenUpdatedAt
          ? _value.tokenUpdatedAt
          : tokenUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isDocumentsVerified: null == isDocumentsVerified
          ? _value.isDocumentsVerified
          : isDocumentsVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      averageCommunicationRating: null == averageCommunicationRating
          ? _value.averageCommunicationRating
          : averageCommunicationRating // ignore: cast_nullable_to_non_nullable
              as double,
      averageVehicleRating: null == averageVehicleRating
          ? _value.averageVehicleRating
          : averageVehicleRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalTrips: null == totalTrips
          ? _value.totalTrips
          : totalTrips // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSignupModelImplCopyWith<$Res>
    implements $UserSignupModelCopyWith<$Res> {
  factory _$$UserSignupModelImplCopyWith(_$UserSignupModelImpl value,
          $Res Function(_$UserSignupModelImpl) then) =
      __$$UserSignupModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String name,
      String email,
      String phoneNumber,
      String password,
      bool isDriver,
      String? gender,
      String? role,
      String? vehicleMake,
      String? vehicleModel,
      String? vehicleYear,
      String? region,
      String? city,
      String? district,
      String? serviceType,
      String? profilePicture,
      String? IdImage,
      String? drivingLicenseImage,
      String? vehicleRegistrationImage,
      String? vehiclePhotoImage,
      List<String>? availableServices,
      Map<String, dynamic>? currentLocation,
      bool isOnline,
      DateTime? lastSeen,
      String? fcmToken,
      DateTime? tokenUpdatedAt,
      bool isEmailVerified,
      bool isDocumentsVerified,
      double averageRating,
      double averageCommunicationRating,
      double averageVehicleRating,
      int totalReviews,
      int totalTrips,
      DateTime? createdAt});
}

/// @nodoc
class __$$UserSignupModelImplCopyWithImpl<$Res>
    extends _$UserSignupModelCopyWithImpl<$Res, _$UserSignupModelImpl>
    implements _$$UserSignupModelImplCopyWith<$Res> {
  __$$UserSignupModelImplCopyWithImpl(
      _$UserSignupModelImpl _value, $Res Function(_$UserSignupModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? password = null,
    Object? isDriver = null,
    Object? gender = freezed,
    Object? role = freezed,
    Object? vehicleMake = freezed,
    Object? vehicleModel = freezed,
    Object? vehicleYear = freezed,
    Object? region = freezed,
    Object? city = freezed,
    Object? district = freezed,
    Object? serviceType = freezed,
    Object? profilePicture = freezed,
    Object? IdImage = freezed,
    Object? drivingLicenseImage = freezed,
    Object? vehicleRegistrationImage = freezed,
    Object? vehiclePhotoImage = freezed,
    Object? availableServices = freezed,
    Object? currentLocation = freezed,
    Object? isOnline = null,
    Object? lastSeen = freezed,
    Object? fcmToken = freezed,
    Object? tokenUpdatedAt = freezed,
    Object? isEmailVerified = null,
    Object? isDocumentsVerified = null,
    Object? averageRating = null,
    Object? averageCommunicationRating = null,
    Object? averageVehicleRating = null,
    Object? totalReviews = null,
    Object? totalTrips = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$UserSignupModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      isDriver: null == isDriver
          ? _value.isDriver
          : isDriver // ignore: cast_nullable_to_non_nullable
              as bool,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      role: freezed == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleMake: freezed == vehicleMake
          ? _value.vehicleMake
          : vehicleMake // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleModel: freezed == vehicleModel
          ? _value.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleYear: freezed == vehicleYear
          ? _value.vehicleYear
          : vehicleYear // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      district: freezed == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceType: freezed == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String?,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      IdImage: freezed == IdImage
          ? _value.IdImage
          : IdImage // ignore: cast_nullable_to_non_nullable
              as String?,
      drivingLicenseImage: freezed == drivingLicenseImage
          ? _value.drivingLicenseImage
          : drivingLicenseImage // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleRegistrationImage: freezed == vehicleRegistrationImage
          ? _value.vehicleRegistrationImage
          : vehicleRegistrationImage // ignore: cast_nullable_to_non_nullable
              as String?,
      vehiclePhotoImage: freezed == vehiclePhotoImage
          ? _value.vehiclePhotoImage
          : vehiclePhotoImage // ignore: cast_nullable_to_non_nullable
              as String?,
      availableServices: freezed == availableServices
          ? _value._availableServices
          : availableServices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      currentLocation: freezed == currentLocation
          ? _value._currentLocation
          : currentLocation // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      fcmToken: freezed == fcmToken
          ? _value.fcmToken
          : fcmToken // ignore: cast_nullable_to_non_nullable
              as String?,
      tokenUpdatedAt: freezed == tokenUpdatedAt
          ? _value.tokenUpdatedAt
          : tokenUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isDocumentsVerified: null == isDocumentsVerified
          ? _value.isDocumentsVerified
          : isDocumentsVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      averageCommunicationRating: null == averageCommunicationRating
          ? _value.averageCommunicationRating
          : averageCommunicationRating // ignore: cast_nullable_to_non_nullable
              as double,
      averageVehicleRating: null == averageVehicleRating
          ? _value.averageVehicleRating
          : averageVehicleRating // ignore: cast_nullable_to_non_nullable
              as double,
      totalReviews: null == totalReviews
          ? _value.totalReviews
          : totalReviews // ignore: cast_nullable_to_non_nullable
              as int,
      totalTrips: null == totalTrips
          ? _value.totalTrips
          : totalTrips // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSignupModelImpl extends _UserSignupModel {
  const _$UserSignupModelImpl(
      {this.id,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.password,
      required this.isDriver,
      this.gender,
      this.role,
      this.vehicleMake,
      this.vehicleModel,
      this.vehicleYear,
      this.region,
      this.city,
      this.district,
      this.serviceType,
      this.profilePicture,
      this.IdImage,
      this.drivingLicenseImage,
      this.vehicleRegistrationImage,
      this.vehiclePhotoImage,
      final List<String>? availableServices,
      final Map<String, dynamic>? currentLocation,
      this.isOnline = false,
      this.lastSeen,
      this.fcmToken,
      this.tokenUpdatedAt,
      this.isEmailVerified = false,
      this.isDocumentsVerified = false,
      this.averageRating = 0.0,
      this.averageCommunicationRating = 0.0,
      this.averageVehicleRating = 0.0,
      this.totalReviews = 0,
      this.totalTrips = 0,
      this.createdAt})
      : _availableServices = availableServices,
        _currentLocation = currentLocation,
        super._();

  factory _$UserSignupModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSignupModelImplFromJson(json);

  @override
  final String? id;
// Document ID from Firestore
  @override
  final String name;
  @override
  final String email;
  @override
  final String phoneNumber;
  @override
  final String password;
  @override
  final bool isDriver;
// For students only
  @override
  final String? gender;
  @override
  final String? role;
// Student, Teacher, Employee
// For drivers only
  @override
  final String? vehicleMake;
  @override
  final String? vehicleModel;
  @override
  final String? vehicleYear;
// Location fields (cascading dropdowns)
  @override
  final String? region;
  @override
  final String? city;
  @override
  final String? district;
  @override
  final String? serviceType;
// Profile and documents
  @override
  final String? profilePicture;
  @override
  final String? IdImage;
// Driver documents (only for drivers)
  @override
  final String? drivingLicenseImage;
  @override
  final String? vehicleRegistrationImage;
  @override
  final String? vehiclePhotoImage;
// Available services for drivers
  final List<String>? _availableServices;
// Available services for drivers
  @override
  List<String>? get availableServices {
    final value = _availableServices;
    if (value == null) return null;
    if (_availableServices is EqualUnmodifiableListView)
      return _availableServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Location data for drivers
  final Map<String, dynamic>? _currentLocation;
// Location data for drivers
  @override
  Map<String, dynamic>? get currentLocation {
    final value = _currentLocation;
    if (value == null) return null;
    if (_currentLocation is EqualUnmodifiableMapView) return _currentLocation;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Driver status and activity
  @override
  @JsonKey()
  final bool isOnline;
  @override
  final DateTime? lastSeen;
  @override
  final String? fcmToken;
  @override
  final DateTime? tokenUpdatedAt;
// Verification flags
  @override
  @JsonKey()
  final bool isEmailVerified;
  @override
  @JsonKey()
  final bool isDocumentsVerified;
// Driver rating fields (only for drivers)
  @override
  @JsonKey()
  final double averageRating;
  @override
  @JsonKey()
  final double averageCommunicationRating;
  @override
  @JsonKey()
  final double averageVehicleRating;
  @override
  @JsonKey()
  final int totalReviews;
  @override
  @JsonKey()
  final int totalTrips;
// Timestamps
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'UserSignupModel(id: $id, name: $name, email: $email, phoneNumber: $phoneNumber, password: $password, isDriver: $isDriver, gender: $gender, role: $role, vehicleMake: $vehicleMake, vehicleModel: $vehicleModel, vehicleYear: $vehicleYear, region: $region, city: $city, district: $district, serviceType: $serviceType, profilePicture: $profilePicture, IdImage: $IdImage, drivingLicenseImage: $drivingLicenseImage, vehicleRegistrationImage: $vehicleRegistrationImage, vehiclePhotoImage: $vehiclePhotoImage, availableServices: $availableServices, currentLocation: $currentLocation, isOnline: $isOnline, lastSeen: $lastSeen, fcmToken: $fcmToken, tokenUpdatedAt: $tokenUpdatedAt, isEmailVerified: $isEmailVerified, isDocumentsVerified: $isDocumentsVerified, averageRating: $averageRating, averageCommunicationRating: $averageCommunicationRating, averageVehicleRating: $averageVehicleRating, totalReviews: $totalReviews, totalTrips: $totalTrips, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSignupModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.isDriver, isDriver) ||
                other.isDriver == isDriver) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.vehicleMake, vehicleMake) ||
                other.vehicleMake == vehicleMake) &&
            (identical(other.vehicleModel, vehicleModel) ||
                other.vehicleModel == vehicleModel) &&
            (identical(other.vehicleYear, vehicleYear) ||
                other.vehicleYear == vehicleYear) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.district, district) ||
                other.district == district) &&
            (identical(other.serviceType, serviceType) ||
                other.serviceType == serviceType) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.IdImage, IdImage) || other.IdImage == IdImage) &&
            (identical(other.drivingLicenseImage, drivingLicenseImage) ||
                other.drivingLicenseImage == drivingLicenseImage) &&
            (identical(
                    other.vehicleRegistrationImage, vehicleRegistrationImage) ||
                other.vehicleRegistrationImage == vehicleRegistrationImage) &&
            (identical(other.vehiclePhotoImage, vehiclePhotoImage) ||
                other.vehiclePhotoImage == vehiclePhotoImage) &&
            const DeepCollectionEquality()
                .equals(other._availableServices, _availableServices) &&
            const DeepCollectionEquality()
                .equals(other._currentLocation, _currentLocation) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen) &&
            (identical(other.fcmToken, fcmToken) ||
                other.fcmToken == fcmToken) &&
            (identical(other.tokenUpdatedAt, tokenUpdatedAt) ||
                other.tokenUpdatedAt == tokenUpdatedAt) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.isDocumentsVerified, isDocumentsVerified) ||
                other.isDocumentsVerified == isDocumentsVerified) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.averageCommunicationRating,
                    averageCommunicationRating) ||
                other.averageCommunicationRating ==
                    averageCommunicationRating) &&
            (identical(other.averageVehicleRating, averageVehicleRating) ||
                other.averageVehicleRating == averageVehicleRating) &&
            (identical(other.totalReviews, totalReviews) ||
                other.totalReviews == totalReviews) &&
            (identical(other.totalTrips, totalTrips) ||
                other.totalTrips == totalTrips) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        email,
        phoneNumber,
        password,
        isDriver,
        gender,
        role,
        vehicleMake,
        vehicleModel,
        vehicleYear,
        region,
        city,
        district,
        serviceType,
        profilePicture,
        IdImage,
        drivingLicenseImage,
        vehicleRegistrationImage,
        vehiclePhotoImage,
        const DeepCollectionEquality().hash(_availableServices),
        const DeepCollectionEquality().hash(_currentLocation),
        isOnline,
        lastSeen,
        fcmToken,
        tokenUpdatedAt,
        isEmailVerified,
        isDocumentsVerified,
        averageRating,
        averageCommunicationRating,
        averageVehicleRating,
        totalReviews,
        totalTrips,
        createdAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSignupModelImplCopyWith<_$UserSignupModelImpl> get copyWith =>
      __$$UserSignupModelImplCopyWithImpl<_$UserSignupModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSignupModelImplToJson(
      this,
    );
  }
}

abstract class _UserSignupModel extends UserSignupModel {
  const factory _UserSignupModel(
      {final String? id,
      required final String name,
      required final String email,
      required final String phoneNumber,
      required final String password,
      required final bool isDriver,
      final String? gender,
      final String? role,
      final String? vehicleMake,
      final String? vehicleModel,
      final String? vehicleYear,
      final String? region,
      final String? city,
      final String? district,
      final String? serviceType,
      final String? profilePicture,
      final String? IdImage,
      final String? drivingLicenseImage,
      final String? vehicleRegistrationImage,
      final String? vehiclePhotoImage,
      final List<String>? availableServices,
      final Map<String, dynamic>? currentLocation,
      final bool isOnline,
      final DateTime? lastSeen,
      final String? fcmToken,
      final DateTime? tokenUpdatedAt,
      final bool isEmailVerified,
      final bool isDocumentsVerified,
      final double averageRating,
      final double averageCommunicationRating,
      final double averageVehicleRating,
      final int totalReviews,
      final int totalTrips,
      final DateTime? createdAt}) = _$UserSignupModelImpl;
  const _UserSignupModel._() : super._();

  factory _UserSignupModel.fromJson(Map<String, dynamic> json) =
      _$UserSignupModelImpl.fromJson;

  @override
  String? get id;
  @override // Document ID from Firestore
  String get name;
  @override
  String get email;
  @override
  String get phoneNumber;
  @override
  String get password;
  @override
  bool get isDriver;
  @override // For students only
  String? get gender;
  @override
  String? get role;
  @override // Student, Teacher, Employee
// For drivers only
  String? get vehicleMake;
  @override
  String? get vehicleModel;
  @override
  String? get vehicleYear;
  @override // Location fields (cascading dropdowns)
  String? get region;
  @override
  String? get city;
  @override
  String? get district;
  @override
  String? get serviceType;
  @override // Profile and documents
  String? get profilePicture;
  @override
  String? get IdImage;
  @override // Driver documents (only for drivers)
  String? get drivingLicenseImage;
  @override
  String? get vehicleRegistrationImage;
  @override
  String? get vehiclePhotoImage;
  @override // Available services for drivers
  List<String>? get availableServices;
  @override // Location data for drivers
  Map<String, dynamic>? get currentLocation;
  @override // Driver status and activity
  bool get isOnline;
  @override
  DateTime? get lastSeen;
  @override
  String? get fcmToken;
  @override
  DateTime? get tokenUpdatedAt;
  @override // Verification flags
  bool get isEmailVerified;
  @override
  bool get isDocumentsVerified;
  @override // Driver rating fields (only for drivers)
  double get averageRating;
  @override
  double get averageCommunicationRating;
  @override
  double get averageVehicleRating;
  @override
  int get totalReviews;
  @override
  int get totalTrips;
  @override // Timestamps
  DateTime? get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$UserSignupModelImplCopyWith<_$UserSignupModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
