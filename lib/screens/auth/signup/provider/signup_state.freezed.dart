// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SignupState {
// Basic info
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get confirmPassword => throw _privateConstructorUsedError;
  bool get isDriver =>
      throw _privateConstructorUsedError; // Student-specific fields
  String get gender => throw _privateConstructorUsedError;
  String get role =>
      throw _privateConstructorUsedError; // Driver-specific fields
  String get vehicleMake => throw _privateConstructorUsedError;
  String get vehicleModel => throw _privateConstructorUsedError;
  String get vehicleYear =>
      throw _privateConstructorUsedError; // Location fields (cascading dropdowns)
  String get region => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get district => throw _privateConstructorUsedError;
  String get serviceType =>
      throw _privateConstructorUsedError; // Keep for backwards compatibility
  Set<TransportationServiceType> get selectedServiceTypes =>
      throw _privateConstructorUsedError; // Document images
  String? get profilePicture => throw _privateConstructorUsedError;
  String? get idImage => throw _privateConstructorUsedError;
  String? get drivingLicenseImage => throw _privateConstructorUsedError;
  String? get vehicleRegistrationImage => throw _privateConstructorUsedError;
  String? get vehiclePhotoImage =>
      throw _privateConstructorUsedError; // Validation errors
  String? get nameError => throw _privateConstructorUsedError;
  String? get emailError => throw _privateConstructorUsedError;
  String? get phoneError => throw _privateConstructorUsedError;
  String? get passwordError => throw _privateConstructorUsedError;
  String? get confirmPasswordError => throw _privateConstructorUsedError;
  String? get genderError => throw _privateConstructorUsedError;
  String? get roleError => throw _privateConstructorUsedError;
  String? get vehicleMakeError => throw _privateConstructorUsedError;
  String? get vehicleModelError => throw _privateConstructorUsedError;
  String? get vehicleYearError => throw _privateConstructorUsedError;
  String? get regionError => throw _privateConstructorUsedError;
  String? get cityError => throw _privateConstructorUsedError;
  String? get districtError => throw _privateConstructorUsedError;
  String? get serviceTypeError =>
      throw _privateConstructorUsedError; // Loading state
  bool get isLoading => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SignupStateCopyWith<SignupState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SignupStateCopyWith<$Res> {
  factory $SignupStateCopyWith(
          SignupState value, $Res Function(SignupState) then) =
      _$SignupStateCopyWithImpl<$Res, SignupState>;
  @useResult
  $Res call(
      {String name,
      String email,
      String phoneNumber,
      String password,
      String confirmPassword,
      bool isDriver,
      String gender,
      String role,
      String vehicleMake,
      String vehicleModel,
      String vehicleYear,
      String region,
      String city,
      String district,
      String serviceType,
      Set<TransportationServiceType> selectedServiceTypes,
      String? profilePicture,
      String? idImage,
      String? drivingLicenseImage,
      String? vehicleRegistrationImage,
      String? vehiclePhotoImage,
      String? nameError,
      String? emailError,
      String? phoneError,
      String? passwordError,
      String? confirmPasswordError,
      String? genderError,
      String? roleError,
      String? vehicleMakeError,
      String? vehicleModelError,
      String? vehicleYearError,
      String? regionError,
      String? cityError,
      String? districtError,
      String? serviceTypeError,
      bool isLoading});
}

/// @nodoc
class _$SignupStateCopyWithImpl<$Res, $Val extends SignupState>
    implements $SignupStateCopyWith<$Res> {
  _$SignupStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? isDriver = null,
    Object? gender = null,
    Object? role = null,
    Object? vehicleMake = null,
    Object? vehicleModel = null,
    Object? vehicleYear = null,
    Object? region = null,
    Object? city = null,
    Object? district = null,
    Object? serviceType = null,
    Object? selectedServiceTypes = null,
    Object? profilePicture = freezed,
    Object? idImage = freezed,
    Object? drivingLicenseImage = freezed,
    Object? vehicleRegistrationImage = freezed,
    Object? vehiclePhotoImage = freezed,
    Object? nameError = freezed,
    Object? emailError = freezed,
    Object? phoneError = freezed,
    Object? passwordError = freezed,
    Object? confirmPasswordError = freezed,
    Object? genderError = freezed,
    Object? roleError = freezed,
    Object? vehicleMakeError = freezed,
    Object? vehicleModelError = freezed,
    Object? vehicleYearError = freezed,
    Object? regionError = freezed,
    Object? cityError = freezed,
    Object? districtError = freezed,
    Object? serviceTypeError = freezed,
    Object? isLoading = null,
  }) {
    return _then(_value.copyWith(
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
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      isDriver: null == isDriver
          ? _value.isDriver
          : isDriver // ignore: cast_nullable_to_non_nullable
              as bool,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleMake: null == vehicleMake
          ? _value.vehicleMake
          : vehicleMake // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleModel: null == vehicleModel
          ? _value.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleYear: null == vehicleYear
          ? _value.vehicleYear
          : vehicleYear // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      selectedServiceTypes: null == selectedServiceTypes
          ? _value.selectedServiceTypes
          : selectedServiceTypes // ignore: cast_nullable_to_non_nullable
              as Set<TransportationServiceType>,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      idImage: freezed == idImage
          ? _value.idImage
          : idImage // ignore: cast_nullable_to_non_nullable
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
      nameError: freezed == nameError
          ? _value.nameError
          : nameError // ignore: cast_nullable_to_non_nullable
              as String?,
      emailError: freezed == emailError
          ? _value.emailError
          : emailError // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneError: freezed == phoneError
          ? _value.phoneError
          : phoneError // ignore: cast_nullable_to_non_nullable
              as String?,
      passwordError: freezed == passwordError
          ? _value.passwordError
          : passwordError // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmPasswordError: freezed == confirmPasswordError
          ? _value.confirmPasswordError
          : confirmPasswordError // ignore: cast_nullable_to_non_nullable
              as String?,
      genderError: freezed == genderError
          ? _value.genderError
          : genderError // ignore: cast_nullable_to_non_nullable
              as String?,
      roleError: freezed == roleError
          ? _value.roleError
          : roleError // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleMakeError: freezed == vehicleMakeError
          ? _value.vehicleMakeError
          : vehicleMakeError // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleModelError: freezed == vehicleModelError
          ? _value.vehicleModelError
          : vehicleModelError // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleYearError: freezed == vehicleYearError
          ? _value.vehicleYearError
          : vehicleYearError // ignore: cast_nullable_to_non_nullable
              as String?,
      regionError: freezed == regionError
          ? _value.regionError
          : regionError // ignore: cast_nullable_to_non_nullable
              as String?,
      cityError: freezed == cityError
          ? _value.cityError
          : cityError // ignore: cast_nullable_to_non_nullable
              as String?,
      districtError: freezed == districtError
          ? _value.districtError
          : districtError // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceTypeError: freezed == serviceTypeError
          ? _value.serviceTypeError
          : serviceTypeError // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SignupStateImplCopyWith<$Res>
    implements $SignupStateCopyWith<$Res> {
  factory _$$SignupStateImplCopyWith(
          _$SignupStateImpl value, $Res Function(_$SignupStateImpl) then) =
      __$$SignupStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String email,
      String phoneNumber,
      String password,
      String confirmPassword,
      bool isDriver,
      String gender,
      String role,
      String vehicleMake,
      String vehicleModel,
      String vehicleYear,
      String region,
      String city,
      String district,
      String serviceType,
      Set<TransportationServiceType> selectedServiceTypes,
      String? profilePicture,
      String? idImage,
      String? drivingLicenseImage,
      String? vehicleRegistrationImage,
      String? vehiclePhotoImage,
      String? nameError,
      String? emailError,
      String? phoneError,
      String? passwordError,
      String? confirmPasswordError,
      String? genderError,
      String? roleError,
      String? vehicleMakeError,
      String? vehicleModelError,
      String? vehicleYearError,
      String? regionError,
      String? cityError,
      String? districtError,
      String? serviceTypeError,
      bool isLoading});
}

/// @nodoc
class __$$SignupStateImplCopyWithImpl<$Res>
    extends _$SignupStateCopyWithImpl<$Res, _$SignupStateImpl>
    implements _$$SignupStateImplCopyWith<$Res> {
  __$$SignupStateImplCopyWithImpl(
      _$SignupStateImpl _value, $Res Function(_$SignupStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? email = null,
    Object? phoneNumber = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? isDriver = null,
    Object? gender = null,
    Object? role = null,
    Object? vehicleMake = null,
    Object? vehicleModel = null,
    Object? vehicleYear = null,
    Object? region = null,
    Object? city = null,
    Object? district = null,
    Object? serviceType = null,
    Object? selectedServiceTypes = null,
    Object? profilePicture = freezed,
    Object? idImage = freezed,
    Object? drivingLicenseImage = freezed,
    Object? vehicleRegistrationImage = freezed,
    Object? vehiclePhotoImage = freezed,
    Object? nameError = freezed,
    Object? emailError = freezed,
    Object? phoneError = freezed,
    Object? passwordError = freezed,
    Object? confirmPasswordError = freezed,
    Object? genderError = freezed,
    Object? roleError = freezed,
    Object? vehicleMakeError = freezed,
    Object? vehicleModelError = freezed,
    Object? vehicleYearError = freezed,
    Object? regionError = freezed,
    Object? cityError = freezed,
    Object? districtError = freezed,
    Object? serviceTypeError = freezed,
    Object? isLoading = null,
  }) {
    return _then(_$SignupStateImpl(
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
      confirmPassword: null == confirmPassword
          ? _value.confirmPassword
          : confirmPassword // ignore: cast_nullable_to_non_nullable
              as String,
      isDriver: null == isDriver
          ? _value.isDriver
          : isDriver // ignore: cast_nullable_to_non_nullable
              as bool,
      gender: null == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleMake: null == vehicleMake
          ? _value.vehicleMake
          : vehicleMake // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleModel: null == vehicleModel
          ? _value.vehicleModel
          : vehicleModel // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleYear: null == vehicleYear
          ? _value.vehicleYear
          : vehicleYear // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      district: null == district
          ? _value.district
          : district // ignore: cast_nullable_to_non_nullable
              as String,
      serviceType: null == serviceType
          ? _value.serviceType
          : serviceType // ignore: cast_nullable_to_non_nullable
              as String,
      selectedServiceTypes: null == selectedServiceTypes
          ? _value._selectedServiceTypes
          : selectedServiceTypes // ignore: cast_nullable_to_non_nullable
              as Set<TransportationServiceType>,
      profilePicture: freezed == profilePicture
          ? _value.profilePicture
          : profilePicture // ignore: cast_nullable_to_non_nullable
              as String?,
      idImage: freezed == idImage
          ? _value.idImage
          : idImage // ignore: cast_nullable_to_non_nullable
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
      nameError: freezed == nameError
          ? _value.nameError
          : nameError // ignore: cast_nullable_to_non_nullable
              as String?,
      emailError: freezed == emailError
          ? _value.emailError
          : emailError // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneError: freezed == phoneError
          ? _value.phoneError
          : phoneError // ignore: cast_nullable_to_non_nullable
              as String?,
      passwordError: freezed == passwordError
          ? _value.passwordError
          : passwordError // ignore: cast_nullable_to_non_nullable
              as String?,
      confirmPasswordError: freezed == confirmPasswordError
          ? _value.confirmPasswordError
          : confirmPasswordError // ignore: cast_nullable_to_non_nullable
              as String?,
      genderError: freezed == genderError
          ? _value.genderError
          : genderError // ignore: cast_nullable_to_non_nullable
              as String?,
      roleError: freezed == roleError
          ? _value.roleError
          : roleError // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleMakeError: freezed == vehicleMakeError
          ? _value.vehicleMakeError
          : vehicleMakeError // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleModelError: freezed == vehicleModelError
          ? _value.vehicleModelError
          : vehicleModelError // ignore: cast_nullable_to_non_nullable
              as String?,
      vehicleYearError: freezed == vehicleYearError
          ? _value.vehicleYearError
          : vehicleYearError // ignore: cast_nullable_to_non_nullable
              as String?,
      regionError: freezed == regionError
          ? _value.regionError
          : regionError // ignore: cast_nullable_to_non_nullable
              as String?,
      cityError: freezed == cityError
          ? _value.cityError
          : cityError // ignore: cast_nullable_to_non_nullable
              as String?,
      districtError: freezed == districtError
          ? _value.districtError
          : districtError // ignore: cast_nullable_to_non_nullable
              as String?,
      serviceTypeError: freezed == serviceTypeError
          ? _value.serviceTypeError
          : serviceTypeError // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SignupStateImpl implements _SignupState {
  const _$SignupStateImpl(
      {this.name = '',
      this.email = '',
      this.phoneNumber = '',
      this.password = '',
      this.confirmPassword = '',
      this.isDriver = false,
      this.gender = '',
      this.role = 'Student',
      this.vehicleMake = '',
      this.vehicleModel = '',
      this.vehicleYear = '',
      this.region = '',
      this.city = '',
      this.district = '',
      this.serviceType = '',
      final Set<TransportationServiceType> selectedServiceTypes =
          const <TransportationServiceType>{},
      this.profilePicture = null,
      this.idImage = null,
      this.drivingLicenseImage = null,
      this.vehicleRegistrationImage = null,
      this.vehiclePhotoImage = null,
      this.nameError = null,
      this.emailError = null,
      this.phoneError = null,
      this.passwordError = null,
      this.confirmPasswordError = null,
      this.genderError = null,
      this.roleError = null,
      this.vehicleMakeError = null,
      this.vehicleModelError = null,
      this.vehicleYearError = null,
      this.regionError = null,
      this.cityError = null,
      this.districtError = null,
      this.serviceTypeError = null,
      this.isLoading = false})
      : _selectedServiceTypes = selectedServiceTypes;

// Basic info
  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String phoneNumber;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String confirmPassword;
  @override
  @JsonKey()
  final bool isDriver;
// Student-specific fields
  @override
  @JsonKey()
  final String gender;
  @override
  @JsonKey()
  final String role;
// Driver-specific fields
  @override
  @JsonKey()
  final String vehicleMake;
  @override
  @JsonKey()
  final String vehicleModel;
  @override
  @JsonKey()
  final String vehicleYear;
// Location fields (cascading dropdowns)
  @override
  @JsonKey()
  final String region;
  @override
  @JsonKey()
  final String city;
  @override
  @JsonKey()
  final String district;
  @override
  @JsonKey()
  final String serviceType;
// Keep for backwards compatibility
  final Set<TransportationServiceType> _selectedServiceTypes;
// Keep for backwards compatibility
  @override
  @JsonKey()
  Set<TransportationServiceType> get selectedServiceTypes {
    if (_selectedServiceTypes is EqualUnmodifiableSetView)
      return _selectedServiceTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_selectedServiceTypes);
  }

// Document images
  @override
  @JsonKey()
  final String? profilePicture;
  @override
  @JsonKey()
  final String? idImage;
  @override
  @JsonKey()
  final String? drivingLicenseImage;
  @override
  @JsonKey()
  final String? vehicleRegistrationImage;
  @override
  @JsonKey()
  final String? vehiclePhotoImage;
// Validation errors
  @override
  @JsonKey()
  final String? nameError;
  @override
  @JsonKey()
  final String? emailError;
  @override
  @JsonKey()
  final String? phoneError;
  @override
  @JsonKey()
  final String? passwordError;
  @override
  @JsonKey()
  final String? confirmPasswordError;
  @override
  @JsonKey()
  final String? genderError;
  @override
  @JsonKey()
  final String? roleError;
  @override
  @JsonKey()
  final String? vehicleMakeError;
  @override
  @JsonKey()
  final String? vehicleModelError;
  @override
  @JsonKey()
  final String? vehicleYearError;
  @override
  @JsonKey()
  final String? regionError;
  @override
  @JsonKey()
  final String? cityError;
  @override
  @JsonKey()
  final String? districtError;
  @override
  @JsonKey()
  final String? serviceTypeError;
// Loading state
  @override
  @JsonKey()
  final bool isLoading;

  @override
  String toString() {
    return 'SignupState(name: $name, email: $email, phoneNumber: $phoneNumber, password: $password, confirmPassword: $confirmPassword, isDriver: $isDriver, gender: $gender, role: $role, vehicleMake: $vehicleMake, vehicleModel: $vehicleModel, vehicleYear: $vehicleYear, region: $region, city: $city, district: $district, serviceType: $serviceType, selectedServiceTypes: $selectedServiceTypes, profilePicture: $profilePicture, idImage: $idImage, drivingLicenseImage: $drivingLicenseImage, vehicleRegistrationImage: $vehicleRegistrationImage, vehiclePhotoImage: $vehiclePhotoImage, nameError: $nameError, emailError: $emailError, phoneError: $phoneError, passwordError: $passwordError, confirmPasswordError: $confirmPasswordError, genderError: $genderError, roleError: $roleError, vehicleMakeError: $vehicleMakeError, vehicleModelError: $vehicleModelError, vehicleYearError: $vehicleYearError, regionError: $regionError, cityError: $cityError, districtError: $districtError, serviceTypeError: $serviceTypeError, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SignupStateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
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
            const DeepCollectionEquality()
                .equals(other._selectedServiceTypes, _selectedServiceTypes) &&
            (identical(other.profilePicture, profilePicture) ||
                other.profilePicture == profilePicture) &&
            (identical(other.idImage, idImage) || other.idImage == idImage) &&
            (identical(other.drivingLicenseImage, drivingLicenseImage) ||
                other.drivingLicenseImage == drivingLicenseImage) &&
            (identical(
                    other.vehicleRegistrationImage, vehicleRegistrationImage) ||
                other.vehicleRegistrationImage == vehicleRegistrationImage) &&
            (identical(other.vehiclePhotoImage, vehiclePhotoImage) ||
                other.vehiclePhotoImage == vehiclePhotoImage) &&
            (identical(other.nameError, nameError) ||
                other.nameError == nameError) &&
            (identical(other.emailError, emailError) ||
                other.emailError == emailError) &&
            (identical(other.phoneError, phoneError) ||
                other.phoneError == phoneError) &&
            (identical(other.passwordError, passwordError) ||
                other.passwordError == passwordError) &&
            (identical(other.confirmPasswordError, confirmPasswordError) ||
                other.confirmPasswordError == confirmPasswordError) &&
            (identical(other.genderError, genderError) ||
                other.genderError == genderError) &&
            (identical(other.roleError, roleError) ||
                other.roleError == roleError) &&
            (identical(other.vehicleMakeError, vehicleMakeError) ||
                other.vehicleMakeError == vehicleMakeError) &&
            (identical(other.vehicleModelError, vehicleModelError) ||
                other.vehicleModelError == vehicleModelError) &&
            (identical(other.vehicleYearError, vehicleYearError) ||
                other.vehicleYearError == vehicleYearError) &&
            (identical(other.regionError, regionError) ||
                other.regionError == regionError) &&
            (identical(other.cityError, cityError) ||
                other.cityError == cityError) &&
            (identical(other.districtError, districtError) ||
                other.districtError == districtError) &&
            (identical(other.serviceTypeError, serviceTypeError) ||
                other.serviceTypeError == serviceTypeError) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        name,
        email,
        phoneNumber,
        password,
        confirmPassword,
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
        const DeepCollectionEquality().hash(_selectedServiceTypes),
        profilePicture,
        idImage,
        drivingLicenseImage,
        vehicleRegistrationImage,
        vehiclePhotoImage,
        nameError,
        emailError,
        phoneError,
        passwordError,
        confirmPasswordError,
        genderError,
        roleError,
        vehicleMakeError,
        vehicleModelError,
        vehicleYearError,
        regionError,
        cityError,
        districtError,
        serviceTypeError,
        isLoading
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SignupStateImplCopyWith<_$SignupStateImpl> get copyWith =>
      __$$SignupStateImplCopyWithImpl<_$SignupStateImpl>(this, _$identity);
}

abstract class _SignupState implements SignupState {
  const factory _SignupState(
      {final String name,
      final String email,
      final String phoneNumber,
      final String password,
      final String confirmPassword,
      final bool isDriver,
      final String gender,
      final String role,
      final String vehicleMake,
      final String vehicleModel,
      final String vehicleYear,
      final String region,
      final String city,
      final String district,
      final String serviceType,
      final Set<TransportationServiceType> selectedServiceTypes,
      final String? profilePicture,
      final String? idImage,
      final String? drivingLicenseImage,
      final String? vehicleRegistrationImage,
      final String? vehiclePhotoImage,
      final String? nameError,
      final String? emailError,
      final String? phoneError,
      final String? passwordError,
      final String? confirmPasswordError,
      final String? genderError,
      final String? roleError,
      final String? vehicleMakeError,
      final String? vehicleModelError,
      final String? vehicleYearError,
      final String? regionError,
      final String? cityError,
      final String? districtError,
      final String? serviceTypeError,
      final bool isLoading}) = _$SignupStateImpl;

  @override // Basic info
  String get name;
  @override
  String get email;
  @override
  String get phoneNumber;
  @override
  String get password;
  @override
  String get confirmPassword;
  @override
  bool get isDriver;
  @override // Student-specific fields
  String get gender;
  @override
  String get role;
  @override // Driver-specific fields
  String get vehicleMake;
  @override
  String get vehicleModel;
  @override
  String get vehicleYear;
  @override // Location fields (cascading dropdowns)
  String get region;
  @override
  String get city;
  @override
  String get district;
  @override
  String get serviceType;
  @override // Keep for backwards compatibility
  Set<TransportationServiceType> get selectedServiceTypes;
  @override // Document images
  String? get profilePicture;
  @override
  String? get idImage;
  @override
  String? get drivingLicenseImage;
  @override
  String? get vehicleRegistrationImage;
  @override
  String? get vehiclePhotoImage;
  @override // Validation errors
  String? get nameError;
  @override
  String? get emailError;
  @override
  String? get phoneError;
  @override
  String? get passwordError;
  @override
  String? get confirmPasswordError;
  @override
  String? get genderError;
  @override
  String? get roleError;
  @override
  String? get vehicleMakeError;
  @override
  String? get vehicleModelError;
  @override
  String? get vehicleYearError;
  @override
  String? get regionError;
  @override
  String? get cityError;
  @override
  String? get districtError;
  @override
  String? get serviceTypeError;
  @override // Loading state
  bool get isLoading;
  @override
  @JsonKey(ignore: true)
  _$$SignupStateImplCopyWith<_$SignupStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
