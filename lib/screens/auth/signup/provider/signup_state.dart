import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';

part 'signup_state.freezed.dart';

@freezed
class SignupState with _$SignupState {
  const factory SignupState({
    // Basic info
    @Default('') String name,
    @Default('') String email,
    @Default('') String phoneNumber,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool isDriver,

    // Student-specific fields
    @Default('') String gender,
    @Default('Student') String role,

    // Driver-specific fields
    @Default('') String vehicleMake,
    @Default('') String vehicleModel,
    @Default('') String vehicleYear,

    // Location fields (cascading dropdowns)
    @Default('') String region,
    @Default('') String city,
    @Default('') String district,
    @Default('') String serviceType, // Keep for backwards compatibility
    @Default(<TransportationServiceType>{})
    Set<TransportationServiceType> selectedServiceTypes,

    // Document images
    @Default(null) String? profilePicture,
    @Default(null) String? idImage,
    @Default(null) String? drivingLicenseImage,
    @Default(null) String? vehicleRegistrationImage,
    @Default(null) String? vehiclePhotoImage,

    // Validation errors
    @Default(null) String? nameError,
    @Default(null) String? emailError,
    @Default(null) String? phoneError,
    @Default(null) String? passwordError,
    @Default(null) String? confirmPasswordError,
    @Default(null) String? genderError,
    @Default(null) String? roleError,
    @Default(null) String? vehicleMakeError,
    @Default(null) String? vehicleModelError,
    @Default(null) String? vehicleYearError,
    @Default(null) String? regionError,
    @Default(null) String? cityError,
    @Default(null) String? districtError,
    @Default(null) String? serviceTypeError,

    // Loading state
    @Default(false) bool isLoading,
  }) = _SignupState;
}
