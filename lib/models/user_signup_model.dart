import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_signup_model.freezed.dart';
part 'user_signup_model.g.dart';

@freezed
class UserSignupModel with _$UserSignupModel {
  const UserSignupModel._();

  const factory UserSignupModel({
    String? id, // Document ID from Firestore
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
    required bool isDriver,

    // For students only
    String? gender,
    String? role, // Student, Teacher, Employee

    // For drivers only
    String? vehicleMake,
    String? vehicleModel,
    String? vehicleYear,

    // Location fields (cascading dropdowns)
    String? region,
    String? city,
    String? district,
    String? serviceType,

    // Profile and documents
    String? profilePicture,
    String? IdImage,

    // Driver documents (only for drivers)
    String? drivingLicenseImage,
    String? vehicleRegistrationImage,
    String? vehiclePhotoImage,

    // Available services for drivers
    List<String>? availableServices,

    // Location data for drivers
    Map<String, dynamic>? currentLocation,

    // Driver status and activity
    @Default(false) bool isOnline,
    DateTime? lastSeen,
    String? fcmToken,
    DateTime? tokenUpdatedAt,

    // Verification flags
    @Default(false) bool isEmailVerified,
    @Default(false) bool isDocumentsVerified,

    // Driver rating fields (only for drivers)
    @Default(0.0) double averageRating,
    @Default(0.0) double averageCommunicationRating,
    @Default(0.0) double averageVehicleRating,
    @Default(0) int totalReviews,
    @Default(0) int totalTrips,

    // Timestamps
    DateTime? createdAt,
  }) = _UserSignupModel;

  factory UserSignupModel.fromJson(Map<String, dynamic> json) =>
      _$UserSignupModelFromJson(json);

  // Helper method to get full vehicle description
  String get fullVehicleName {
    final parts = <String>[];
    if (vehicleMake?.isNotEmpty == true) parts.add(vehicleMake!);
    if (vehicleModel?.isNotEmpty == true) parts.add(vehicleModel!);
    if (vehicleYear?.isNotEmpty == true) parts.add(vehicleYear!);
    return parts.isEmpty ? 'Unknown Vehicle' : parts.join(' ');
  }
}
