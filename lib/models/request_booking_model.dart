import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/models/address_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';

part 'request_booking_model.freezed.dart';
part 'request_booking_model.g.dart';

@freezed
class RequestBookingModel with _$RequestBookingModel {
  const factory RequestBookingModel({
    // Service Type

    required TransportationServiceType serviceType,
    String? id,
    // Address Information
    String? addressType, // 'School', 'University', 'Others'
    String? city,
    String? schoolName,
    String? neighborhood,
    String? areaDistrict,
    String? detailedAddress,
    String? userId,

    // Pickup and Drop-off Addresses with full details
    AddressModel? pickupAddress,
    AddressModel? dropOffAddress,

    // Daily Transport specific
    String? selectedDate,
    String? startTime,
    String? endTime,

    // Student Transport specific
    String?
        selectedVehicleType, // 'Sedan Car', 'Small Van', 'Small Bus', 'Bus (Large)'
    String? selectedServiceType, // 'Private Transport', 'Group Transport'
    String? selectedTripType, // 'One Way', 'Round Trip'
    String? transportStartDate,
    String? transportStartTime,
    String? transportEndTime,

    // Teacher/Employee Transport specific
    String? selectedDriverGender, // 'Male', 'Female', 'Any'
    String? selectedSubscriptionPlan, // 'Monthly', 'Quarterly', 'Yearly'
    String? selectedWorkSchedule, // 'Morning', 'Evening', 'Flexible'

    // Pricing
    double? basePrice,
    double? finalPrice,
    String? priceUnit, // 'Riyal', 'Riyal/Month', 'Riyal/Hour'

    // Additional information
    double? numberOfHours, // For daily transport
    double? pricePerHour, // For daily transport

    // Trip tracking
    String? driverId, // Driver who accepted the booking
    bool? isTripStarted, // Whether driver has started the trip
    DateTime? tripStartedAt, // When the trip was started
    DateTime? tripEndedAt, // When the trip was completed
    bool? isDriverComing, // Whether driver has clicked "I'm Coming"
    DateTime? driverComingAt, // When the driver clicked "I'm Coming"

    // Booking status
    DateTime? createdAt,
    DateTime? updatedAt,
    @JsonKey(
      fromJson: _statusFromJson,
      toJson: _statusToJson,
    )
    BookingStatus? status, // BookingStatus enum instead of string
  }) = _RequestBookingModel;

  factory RequestBookingModel.fromJson(Map<String, dynamic> json) =>
      _$RequestBookingModelFromJson(json);
}

// Helper functions for BookingStatus JSON serialization
BookingStatus? _statusFromJson(String? value) {
  if (value == null) return null;
  return BookingStatus.fromString(value);
}

String? _statusToJson(BookingStatus? status) {
  return status?.value;
}

// Helper class for display formatting
extension RequestBookingModelExtension on RequestBookingModel {
  String get formattedServiceType {
    switch (serviceType) {
      case TransportationServiceType.student:
        return 'Student Transportation';
      case TransportationServiceType.teacher:
        return 'Teacher Transportation';
      case TransportationServiceType.employee:
        return 'Employee Transportation';
      case TransportationServiceType.daily:
        return 'Daily Transportation';
    }
  }

  String get formattedAddressType {
    if (addressType == null) return 'Not specified';
    return addressType!;
  }

  String get formattedLocation {
    if (serviceType == TransportationServiceType.daily) {
      return '$city, $areaDistrict';
    } else {
      return '$schoolName, $neighborhood, $city';
    }
  }

  String get formattedPrice {
    if (finalPrice == null) return 'Price not calculated';
    return '${finalPrice!.toStringAsFixed(1)} ${priceUnit ?? 'Riyal'}';
  }

  String get formattedSchedule {
    if (serviceType == TransportationServiceType.daily) {
      return '$selectedDate: $startTime - $endTime';
    } else if (serviceType == TransportationServiceType.student) {
      if (selectedTripType == 'Round Trip') {
        return '$transportStartDate: $transportStartTime - $transportEndTime';
      } else {
        return '$transportStartDate: $transportStartTime';
      }
    } else {
      return selectedWorkSchedule ?? 'Not specified';
    }
  }

  bool get isComplete {
    // Check if all required fields are filled based on service type
    bool baseComplete = city != null &&
        driverId != null &&
        pickupAddress != null &&
        dropOffAddress != null;

    switch (serviceType) {
      case TransportationServiceType.student:
        return baseComplete &&
            selectedVehicleType != null &&
            selectedServiceType != null &&
            selectedTripType != null &&
            transportStartDate != null &&
            transportStartTime != null;

      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return baseComplete &&
            selectedDriverGender != null &&
            selectedSubscriptionPlan != null &&
            selectedWorkSchedule != null;

      case TransportationServiceType.daily:
        return baseComplete &&
            areaDistrict != null &&
            selectedDate != null &&
            startTime != null &&
            endTime != null;
    }
  }

  // Validation methods for each step
  bool get isAddressDetailsValid {
    bool basicAddressValid = city != null &&
        addressType != null &&
        pickupAddress != null &&
        dropOffAddress != null;

    if (serviceType == TransportationServiceType.daily) {
      return basicAddressValid &&
          areaDistrict != null &&
          selectedDate != null &&
          startTime != null &&
          endTime != null;
    } else {
      return basicAddressValid && schoolName != null;
    }
  }

  bool get isDriverSelectionValid {
    return driverId != null;
  }

  bool get isAdditionalDetailsValid {
    switch (serviceType) {
      case TransportationServiceType.student:
        return selectedVehicleType != null &&
            selectedServiceType != null &&
            selectedTripType != null &&
            transportStartDate != null &&
            transportStartTime != null;

      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return selectedDriverGender != null &&
            selectedSubscriptionPlan != null &&
            selectedWorkSchedule != null;

      case TransportationServiceType.daily:
        return true; // All details captured in address step
    }
  }

  // Validation error messages
  List<String> get validationErrors {
    List<String> errors = [];

    if (city == null) errors.add('City is required');
    if (pickupAddress == null) errors.add('Pickup address is required');
    if (dropOffAddress == null) errors.add('Drop-off address is required');
    if (driverId == null) errors.add('Driver selection is required');

    switch (serviceType) {
      case TransportationServiceType.student:
        if (schoolName == null) errors.add('School name is required');
        if (selectedVehicleType == null) errors.add('Vehicle type is required');
        if (selectedServiceType == null) errors.add('Service type is required');
        if (selectedTripType == null) errors.add('Trip type is required');
        if (transportStartDate == null) {
          errors.add('Transport start date is required');
        }
        if (transportStartTime == null) {
          errors.add('Transport start time is required');
        }
        break;

      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        if (schoolName == null) errors.add('Institution name is required');
        if (selectedDriverGender == null) {
          errors.add('Driver gender preference is required');
        }
        if (selectedSubscriptionPlan == null) {
          errors.add('Subscription plan is required');
        }
        if (selectedWorkSchedule == null) {
          errors.add('Work schedule is required');
        }
        break;

      case TransportationServiceType.daily:
        if (areaDistrict == null) errors.add('Area/District is required');
        if (selectedDate == null) errors.add('Date is required');
        if (startTime == null) errors.add('Start time is required');
        if (endTime == null) errors.add('End time is required');
        break;
    }

    return errors;
  }
}
