import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:semester_student_ride_app/models/address_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// State class for address details form
class AddressDetailsState {
  final String addressType;
  final String city;
  final String schoolName;
  final String areaDistrict;
  final String selectedDate;
  final String startTime;
  final String endTime;
  final AddressModel? pickupAddress;
  final AddressModel? dropOffAddress;
  final List<String> validationErrors;
  final bool isLoading;

  const AddressDetailsState({
    this.addressType = '',
    this.city = '',
    this.schoolName = '',
    this.areaDistrict = '',
    this.selectedDate = '',
    this.startTime = '',
    this.endTime = '',
    this.pickupAddress,
    this.dropOffAddress,
    this.validationErrors = const [],
    this.isLoading = false,
  });

  AddressDetailsState copyWith({
    String? addressType,
    String? city,
    String? schoolName,
    String? areaDistrict,
    String? selectedDate,
    String? startTime,
    String? endTime,
    AddressModel? pickupAddress,
    AddressModel? dropOffAddress,
    List<String>? validationErrors,
    bool? isLoading,
  }) {
    return AddressDetailsState(
      addressType: addressType ?? this.addressType,
      city: city ?? this.city,
      schoolName: schoolName ?? this.schoolName,
      areaDistrict: areaDistrict ?? this.areaDistrict,
      selectedDate: selectedDate ?? this.selectedDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropOffAddress: dropOffAddress ?? this.dropOffAddress,
      validationErrors: validationErrors ?? this.validationErrors,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// Provider for address details form state
final addressDetailsProvider =
    StateNotifierProvider<AddressDetailsNotifier, AddressDetailsState>((ref) {
  return AddressDetailsNotifier();
});

class AddressDetailsNotifier extends StateNotifier<AddressDetailsState> {
  AddressDetailsNotifier() : super(const AddressDetailsState());

  // Update address type
  void updateAddressType(String addressType) {
    state = state.copyWith(
      addressType: addressType,
      validationErrors: [], // Clear errors when user makes changes
    );
  }

  // Update city
  void updateCity(String city) {
    state = state.copyWith(
      city: city,
      validationErrors: [],
    );
  }

  // Update school name
  void updateSchoolName(String schoolName) {
    state = state.copyWith(
      schoolName: schoolName,
      validationErrors: [],
    );
  }

  // Update area district
  void updateAreaDistrict(String areaDistrict) {
    state = state.copyWith(
      areaDistrict: areaDistrict,
      validationErrors: [],
    );
  }

  // Update selected date
  void updateSelectedDate(String selectedDate) {
    state = state.copyWith(
      selectedDate: selectedDate,
      validationErrors: [],
    );
  }

  // Update start time
  void updateStartTime(String startTime) {
    state = state.copyWith(
      startTime: startTime,
      validationErrors: [],
    );
  }

  // Update end time
  void updateEndTime(String endTime) {
    state = state.copyWith(
      endTime: endTime,
      validationErrors: [],
    );
  }

  // Update pickup address
  void updatePickupAddress(String address, String city, String state,
      String zip, double lat, double lng) {
    final pickupAddress = AddressModel(
      address: address,
      city: city,
      state: state,
      zipCode: zip,
      coordinates: LatLng(lat, lng),
    );

    this.state = this.state.copyWith(
      pickupAddress: pickupAddress,
      validationErrors: [],
    );
  }

  // Update drop-off address
  void updateDropOffAddress(String address, String city, String state,
      String zip, double lat, double lng) {
    final dropOffAddress = AddressModel(
      address: address,
      city: city,
      state: state,
      zipCode: zip,
      coordinates: LatLng(lat, lng),
    );

    this.state = this.state.copyWith(
      dropOffAddress: dropOffAddress,
      validationErrors: [],
    );
  }

  // Clear all errors
  void clearErrors() {
    state = state.copyWith(validationErrors: []);
  }

  // Initialize form with default address type
  void initializeForm(String defaultAddressType) {
    state =
        const AddressDetailsState().copyWith(addressType: defaultAddressType);
  }

  // Validate all fields based on service type
  bool validateFields(
      TransportationServiceType serviceType, AppLocalizations l10n) {
    List<String> errors = [];

    // Common validations
    if (state.city.trim().isEmpty) {
      errors.add('${l10n.city} is required');
    }

    if (state.pickupAddress == null) {
      errors.add('Pick up location is required');
    }

    if (state.dropOffAddress == null) {
      errors.add('Drop off location is required');
    }

    // Service type specific validations
    if (serviceType != TransportationServiceType.daily) {
      if (state.schoolName.trim().isEmpty) {
        final institutionName = state.addressType == l10n.university
            ? l10n.universityName
            : state.addressType == l10n.school
                ? l10n.schoolName
                : l10n.institutionName;
        errors.add('$institutionName is required');
      }
    } else {
      // Daily transport specific validations
      if (state.areaDistrict.trim().isEmpty) {
        errors.add('${l10n.areaDistrict} is required');
      }
      if (state.selectedDate.trim().isEmpty) {
        errors.add('${l10n.selectDate} is required');
      }
      if (state.startTime.trim().isEmpty) {
        errors.add('${l10n.startTime} is required');
      }
      if (state.endTime.trim().isEmpty) {
        errors.add('${l10n.endTime} is required');
      }
    }

    state = state.copyWith(validationErrors: errors);
    return errors.isEmpty;
  }

  // Get validation status
  bool get isValid => state.validationErrors.isEmpty;

  // Get validation errors
  List<String> get validationErrors => state.validationErrors;

  // Check if form has required data for specific service type
  bool isCompleteForServiceType(TransportationServiceType serviceType) {
    bool hasBasicInfo = state.city.isNotEmpty &&
        state.pickupAddress != null &&
        state.dropOffAddress != null;

    switch (serviceType) {
      case TransportationServiceType.daily:
        return hasBasicInfo &&
            state.areaDistrict.isNotEmpty &&
            state.selectedDate.isNotEmpty &&
            state.startTime.isNotEmpty &&
            state.endTime.isNotEmpty;

      case TransportationServiceType.student:
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return hasBasicInfo && state.schoolName.isNotEmpty;
    }
  }

  // Reset form
  void resetForm() {
    state = const AddressDetailsState();
  }

  // Set loading state
  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}
