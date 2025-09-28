// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_signup_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSignupModelImpl _$$UserSignupModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSignupModelImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      isDriver: json['isDriver'] as bool,
      gender: json['gender'] as String?,
      role: json['role'] as String?,
      vehicleMake: json['vehicleMake'] as String?,
      vehicleModel: json['vehicleModel'] as String?,
      vehicleYear: json['vehicleYear'] as String?,
      region: json['region'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      serviceType: json['serviceType'] as String?,
      profilePicture: json['profilePicture'] as String?,
      IdImage: json['IdImage'] as String?,
      drivingLicenseImage: json['drivingLicenseImage'] as String?,
      vehicleRegistrationImage: json['vehicleRegistrationImage'] as String?,
      vehiclePhotoImage: json['vehiclePhotoImage'] as String?,
      availableServices: (json['availableServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      currentLocation: json['currentLocation'] as Map<String, dynamic>?,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
      fcmToken: json['fcmToken'] as String?,
      tokenUpdatedAt: json['tokenUpdatedAt'] == null
          ? null
          : DateTime.parse(json['tokenUpdatedAt'] as String),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isDocumentsVerified: json['isDocumentsVerified'] as bool? ?? false,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      averageCommunicationRating:
          (json['averageCommunicationRating'] as num?)?.toDouble() ?? 0.0,
      averageVehicleRating:
          (json['averageVehicleRating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: (json['totalReviews'] as num?)?.toInt() ?? 0,
      totalTrips: (json['totalTrips'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserSignupModelImplToJson(
        _$UserSignupModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
      'isDriver': instance.isDriver,
      'gender': instance.gender,
      'role': instance.role,
      'vehicleMake': instance.vehicleMake,
      'vehicleModel': instance.vehicleModel,
      'vehicleYear': instance.vehicleYear,
      'region': instance.region,
      'city': instance.city,
      'district': instance.district,
      'serviceType': instance.serviceType,
      'profilePicture': instance.profilePicture,
      'IdImage': instance.IdImage,
      'drivingLicenseImage': instance.drivingLicenseImage,
      'vehicleRegistrationImage': instance.vehicleRegistrationImage,
      'vehiclePhotoImage': instance.vehiclePhotoImage,
      'availableServices': instance.availableServices,
      'currentLocation': instance.currentLocation,
      'isOnline': instance.isOnline,
      'lastSeen': instance.lastSeen?.toIso8601String(),
      'fcmToken': instance.fcmToken,
      'tokenUpdatedAt': instance.tokenUpdatedAt?.toIso8601String(),
      'isEmailVerified': instance.isEmailVerified,
      'isDocumentsVerified': instance.isDocumentsVerified,
      'averageRating': instance.averageRating,
      'averageCommunicationRating': instance.averageCommunicationRating,
      'averageVehicleRating': instance.averageVehicleRating,
      'totalReviews': instance.totalReviews,
      'totalTrips': instance.totalTrips,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
