import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/address_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';

// Provider for managing the current booking request
final requestBookingProvider =
    StateNotifierProvider<RequestBookingNotifier, RequestBookingModel>((ref) {
  return RequestBookingNotifier();
});

class RequestBookingNotifier extends StateNotifier<RequestBookingModel> {
  RequestBookingNotifier()
      : super(const RequestBookingModel(
          serviceType: TransportationServiceType.student,
          status: BookingStatus.draft,
        ));

  // Initialize booking with service type
  void initializeBooking(TransportationServiceType serviceType) {
    state = RequestBookingModel(
      serviceType: serviceType,
      status: BookingStatus.draft,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Update address information with full address details
  void updateAddressInfo({
    String? addressType,
    String? city,
    String? schoolName,
    String? neighborhood,
    String? areaDistrict,
    String? detailedAddress,
    String? selectedDate,
    String? startTime,
    String? endTime,
    AddressModel? pickupAddress,
    AddressModel? dropOffAddress,
  }) {
    state = state.copyWith(
      addressType: addressType,
      city: city,
      schoolName: schoolName,
      neighborhood: neighborhood,
      areaDistrict: areaDistrict,
      detailedAddress: detailedAddress,
      selectedDate: selectedDate,
      startTime: startTime,
      endTime: endTime,
      pickupAddress: pickupAddress,
      dropOffAddress: dropOffAddress,
      updatedAt: DateTime.now(),
    );
  }

  // Update driver information with driver ID
  void updateDriverInfo({
    String? selectedDriverID,
  }) {
    state = state.copyWith(
      driverId: selectedDriverID,
      updatedAt: DateTime.now(),
    );
  }

  // Update student transport specific info
  void updateStudentTransportInfo({
    String? selectedVehicleType,
    String? selectedServiceType,
    String? selectedTripType,
    String? transportStartDate,
    String? transportStartTime,
    String? transportEndTime,
  }) {
    state = state.copyWith(
      selectedVehicleType: selectedVehicleType,
      selectedServiceType: selectedServiceType,
      selectedTripType: selectedTripType,
      transportStartDate: transportStartDate,
      transportStartTime: transportStartTime,
      transportEndTime: transportEndTime,
      updatedAt: DateTime.now(),
    );
  }

  // Update teacher/employee transport specific info
  void updateTeacherEmployeeTransportInfo({
    String? selectedDriverGender,
    String? selectedSubscriptionPlan,
    String? selectedWorkSchedule,
    String? selectedTripType,
  }) {
    state = state.copyWith(
      selectedDriverGender: selectedDriverGender,
      selectedSubscriptionPlan: selectedSubscriptionPlan,
      selectedWorkSchedule: selectedWorkSchedule,
      selectedTripType: selectedTripType,
      updatedAt: DateTime.now(),
    );
  }

  // Update pricing information
  void updatePricing({
    double? basePrice,
    double? finalPrice,
    String? priceUnit,
    double? numberOfHours,
    double? pricePerHour,
  }) {
    state = state.copyWith(
      basePrice: basePrice,
      finalPrice: finalPrice,
      priceUnit: priceUnit,
      numberOfHours: numberOfHours,
      pricePerHour: pricePerHour,
      updatedAt: DateTime.now(),
    );
  }

  // Update booking status
  void updateStatus(BookingStatus status) {
    state = state.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
  }

  // Clear booking data
  void clearBooking() {
    state = const RequestBookingModel(
      serviceType: TransportationServiceType.student,
      status: BookingStatus.draft,
    );
  }

  // Calculate pricing based on selections
  void calculatePricing() {
    double? calculatedPrice;
    String? unit;

    switch (state.serviceType) {
      case TransportationServiceType.student:
        // Student pricing based on vehicle type
        switch (state.selectedVehicleType) {
          case 'Sedan Car':
            calculatedPrice = 800.0;
            unit = 'Riyal/Month';
            break;
          case 'Small Van':
            calculatedPrice = 600.0;
            unit = 'Riyal/Month';
            break;
          case 'Small Bus':
            calculatedPrice = 400.0;
            unit = 'Riyal/Month';
            break;
          case 'Bus (Large)':
            calculatedPrice = 300.0;
            unit = 'Riyal/Month';
            break;
          default:
            calculatedPrice = 800.0;
            unit = 'Riyal/Month';
        }
        break;

      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        // Teacher/Employee fixed pricing
        calculatedPrice = 1500.0;
        unit = 'Riyal';
        break;

      case TransportationServiceType.daily:
        // Daily transport pricing
        final hours = state.numberOfHours ?? 8.0;
        final pricePerHour = state.pricePerHour ?? 40.0;
        calculatedPrice = hours * pricePerHour;
        unit = 'Riyal';
        break;
    }

    state = state.copyWith(
      basePrice: calculatedPrice,
      finalPrice: calculatedPrice,
      priceUnit: unit,
      updatedAt: DateTime.now(),
    );
  }

  // Get formatted booking summary
  Map<String, dynamic> getBookingSummary() {
    return {
      'serviceType': state.formattedServiceType,
      'location': state.formattedLocation,
      'schedule': state.formattedSchedule,
      'price': state.formattedPrice,
      'driver': state.driverId ?? 'Not selected',
      'isComplete': state.isComplete,
    };
  }

  // Validation methods for the booking flow
  bool validateAddressDetails() {
    return state.isAddressDetailsValid;
  }

  bool validateDriverSelection() {
    return state.isDriverSelectionValid;
  }

  bool validateAdditionalDetails() {
    return state.isAdditionalDetailsValid;
  }

  List<String> getValidationErrors() {
    return state.validationErrors;
  }
}
