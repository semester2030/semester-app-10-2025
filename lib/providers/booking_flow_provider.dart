import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:semester_student_ride_app/models/address_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:semester_student_ride_app/services/driver_service.dart';

// Comprehensive state class for the entire booking flow
class BookingFlowState {
  // Current step in the booking process
  final int currentStep;
  final bool isLoading;

  // Step 1: Address Details
  final String addressType;
  final String city;
  final String schoolName;
  final String areaDistrict;
  final String selectedDate;
  final String startTime;
  final String endTime;
  final AddressModel? pickupAddress;
  final AddressModel? dropOffAddress;

  // Step 2: Driver Selection
  final UserSignupModel? selectedDriver;
  final List<UserSignupModel> availableDrivers;
  final double searchRadius;
  final String? originalDriverID; // Store original driver ID for editing

  // Step 3: Additional Details (Service Type Specific)
  // Student Transport
  final String selectedVehicleType;
  final String selectedServiceType;
  final String selectedTripType;
  final String transportStartDate;
  final String transportStartTime;
  final String transportEndTime;

  // Teacher/Employee Transport
  final String selectedDriverGender;
  final String selectedWorkSchedule;

  // Pricing
  final double? basePrice;
  final double? finalPrice;
  final String priceUnit;
  final double? numberOfHours;
  final double? pricePerHour;
  
  // New pricing system
  final String selectedPaymentMethod; // 'mada', 'visa', 'apple_pay', 'wallet'
  final double? distanceMultiplier;
  final double? timeMultiplier;
  final double? demandMultiplier;
  final double? discountPercentage;
  final String? promoCode;

  // Validation
  final List<String> validationErrors;
  final TransportationServiceType serviceType;

  const BookingFlowState({
    this.currentStep = 1,
    this.isLoading = false,

    // Address Details
    this.addressType = '',
    this.city = '',
    this.schoolName = '',
    this.areaDistrict = '',
    this.selectedDate = '',
    this.startTime = '',
    this.endTime = '',
    this.pickupAddress,
    this.dropOffAddress,

    // Driver Selection
    this.selectedDriver,
    this.availableDrivers = const [],
    this.searchRadius = 5.0,
    this.originalDriverID,

    // Additional Details
    this.selectedVehicleType = '',
    this.selectedServiceType = '',
    this.selectedTripType = '',
    this.transportStartDate = '',
    this.transportStartTime = '',
    this.transportEndTime = '',
    this.selectedDriverGender = '',
    this.selectedWorkSchedule = '',

    // Pricing
    this.basePrice,
    this.finalPrice,
    this.priceUnit = 'Riyal',
    this.numberOfHours,
    this.pricePerHour,
    
    // New pricing system
    this.selectedPaymentMethod = 'mada',
    this.distanceMultiplier,
    this.timeMultiplier,
    this.demandMultiplier,
    this.discountPercentage,
    this.promoCode,

    // Validation
    this.validationErrors = const [],
    required this.serviceType,
  });

  BookingFlowState copyWith({
    int? currentStep,
    bool? isLoading,
    String? addressType,
    String? city,
    String? schoolName,
    String? areaDistrict,
    String? selectedDate,
    String? startTime,
    String? endTime,
    AddressModel? pickupAddress,
    AddressModel? dropOffAddress,
    UserSignupModel? selectedDriver,
    List<UserSignupModel>? availableDrivers,
    double? searchRadius,
    String? originalDriverID,
    String? selectedVehicleType,
    String? selectedServiceType,
    String? selectedTripType,
    String? transportStartDate,
    String? transportStartTime,
    String? transportEndTime,
    String? selectedDriverGender,
    String? selectedWorkSchedule,
    double? basePrice,
    double? finalPrice,
    String? priceUnit,
    double? numberOfHours,
    double? pricePerHour,
    String? selectedPaymentMethod,
    double? distanceMultiplier,
    double? timeMultiplier,
    double? demandMultiplier,
    double? discountPercentage,
    String? promoCode,
    List<String>? validationErrors,
    TransportationServiceType? serviceType,
  }) {
    return BookingFlowState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      addressType: addressType ?? this.addressType,
      city: city ?? this.city,
      schoolName: schoolName ?? this.schoolName,
      areaDistrict: areaDistrict ?? this.areaDistrict,
      selectedDate: selectedDate ?? this.selectedDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      pickupAddress: pickupAddress ?? this.pickupAddress,
      dropOffAddress: dropOffAddress ?? this.dropOffAddress,
      selectedDriver: selectedDriver ?? this.selectedDriver,
      availableDrivers: availableDrivers ?? this.availableDrivers,
      searchRadius: searchRadius ?? this.searchRadius,
      originalDriverID: originalDriverID ?? this.originalDriverID,
      selectedVehicleType: selectedVehicleType ?? this.selectedVehicleType,
      selectedServiceType: selectedServiceType ?? this.selectedServiceType,
      selectedTripType: selectedTripType ?? this.selectedTripType,
      transportStartDate: transportStartDate ?? this.transportStartDate,
      transportStartTime: transportStartTime ?? this.transportStartTime,
      transportEndTime: transportEndTime ?? this.transportEndTime,
      selectedDriverGender: selectedDriverGender ?? this.selectedDriverGender,
      selectedWorkSchedule: selectedWorkSchedule ?? this.selectedWorkSchedule,
      basePrice: basePrice ?? this.basePrice,
      finalPrice: finalPrice ?? this.finalPrice,
      priceUnit: priceUnit ?? this.priceUnit,
      numberOfHours: numberOfHours ?? this.numberOfHours,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      distanceMultiplier: distanceMultiplier ?? this.distanceMultiplier,
      timeMultiplier: timeMultiplier ?? this.timeMultiplier,
      demandMultiplier: demandMultiplier ?? this.demandMultiplier,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      promoCode: promoCode ?? this.promoCode,
      validationErrors: validationErrors ?? this.validationErrors,
      serviceType: serviceType ?? this.serviceType,
    );
  }

  // Validation methods for each step
  bool get isStep1Valid {
    bool hasBasicInfo =
        city.isNotEmpty && pickupAddress != null && dropOffAddress != null;

    switch (serviceType) {
      case TransportationServiceType.daily:
        return hasBasicInfo &&
            areaDistrict.isNotEmpty &&
            selectedDate.isNotEmpty &&
            startTime.isNotEmpty &&
            endTime.isNotEmpty;

      case TransportationServiceType.student:
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return hasBasicInfo && schoolName.isNotEmpty;
    }
  }

  bool get isStep2Valid {
    return selectedDriver != null;
  }

  bool get isStep3Valid {
    switch (serviceType) {
      case TransportationServiceType.student:
        return selectedVehicleType.isNotEmpty &&
            selectedServiceType.isNotEmpty &&
            selectedTripType.isNotEmpty &&
            transportStartDate.isNotEmpty &&
            transportStartTime.isNotEmpty;

      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return selectedDriverGender.isNotEmpty &&
            selectedWorkSchedule.isNotEmpty;

      case TransportationServiceType.daily:
        return true; // All details captured in step 1
    }
  }

  bool get isBookingComplete {
    return isStep1Valid && isStep2Valid && isStep3Valid;
  }

  // Get formatted price
  String get formattedPrice {
    if (finalPrice == null) return 'Price not calculated';
    return '${finalPrice!.toStringAsFixed(1)} $priceUnit';
  }

  // Get formatted base price
  String get formattedBasePrice {
    if (basePrice == null) return 'Price not calculated';
    return '${basePrice!.toStringAsFixed(1)} $priceUnit';
  }

  // Get formatted schedule
  String get formattedSchedule {
    switch (serviceType) {
      case TransportationServiceType.daily:
        return '$selectedDate: $startTime - $endTime';
      case TransportationServiceType.student:
        if (selectedTripType == 'Round Trip') {
          return '$transportStartDate: $transportStartTime - $transportEndTime';
        } else {
          return '$transportStartDate: $transportStartTime';
        }
      default:
        return selectedWorkSchedule.isNotEmpty
            ? selectedWorkSchedule
            : 'Not specified';
    }
  }
}

// Provider for the complete booking flow
final bookingFlowProvider =
    StateNotifierProvider<BookingFlowNotifier, BookingFlowState>((ref) {
  return BookingFlowNotifier();
});

class BookingFlowNotifier extends StateNotifier<BookingFlowState> {
  BookingFlowNotifier()
      : super(const BookingFlowState(
            serviceType: TransportationServiceType.student));

  // Initialize booking with service type
  void initializeBooking(TransportationServiceType serviceType) {
    state = BookingFlowState(
      serviceType: serviceType,
      currentStep: 1,
      addressType: 'School', // Default
      originalDriverID: null, // No original driver for new bookings
      // Set default values for student transport
      selectedVehicleType: serviceType == TransportationServiceType.student ? 'Sedan Car' : '',
      selectedServiceType: serviceType == TransportationServiceType.student ? 'Private Transport' : '',
      selectedTripType: serviceType == TransportationServiceType.student ? 'One Way' : '',
      transportStartDate: serviceType == TransportationServiceType.student ? DateTime.now().add(Duration(days: 1)).toIso8601String().split('T')[0] : '',
      transportStartTime: serviceType == TransportationServiceType.student ? '08:00' : '',
    );
  }

  // Initialize booking with a pre-selected driver
  void initializeBookingWithDriver(
      TransportationServiceType serviceType, UserSignupModel driver) {
    state = BookingFlowState(
      serviceType: serviceType,
      currentStep: 1,
      addressType: 'School', // Default
      selectedDriver: driver, // Pre-select the driver
      originalDriverID: null, // No original driver for new bookings
      // Set default values for student transport
      selectedVehicleType: serviceType == TransportationServiceType.student ? 'Sedan Car' : '',
      selectedServiceType: serviceType == TransportationServiceType.student ? 'Private Transport' : '',
      selectedTripType: serviceType == TransportationServiceType.student ? 'One Way' : '',
      transportStartDate: serviceType == TransportationServiceType.student ? DateTime.now().add(Duration(days: 1)).toIso8601String().split('T')[0] : '',
      transportStartTime: serviceType == TransportationServiceType.student ? '08:00' : '',
    );
  }

  // Navigation methods
  void goToStep(int step) {
    if (step >= 1 && step <= 3) {
      state = state.copyWith(currentStep: step);
    }
  }

  void nextStep() {
    if (state.currentStep < 3) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  // STEP 1: Address Details Methods
  void updateAddressType(String addressType) {
    state = state.copyWith(
      addressType: addressType,
      validationErrors: [],
    );
  }

  void updateCity(String city) {
    state = state.copyWith(
      city: city,
      validationErrors: [],
    );
  }

  void updateSchoolName(String schoolName) {
    state = state.copyWith(
      schoolName: schoolName,
      validationErrors: [],
    );
  }

  void updateAreaDistrict(String areaDistrict) {
    state = state.copyWith(
      areaDistrict: areaDistrict,
      validationErrors: [],
    );
  }

  void updateSelectedDate(String selectedDate) {
    state = state.copyWith(
      selectedDate: selectedDate,
      validationErrors: [],
    );
  }

  void updateStartTime(String startTime) {
    state = state.copyWith(
      startTime: startTime,
      validationErrors: [],
    );
  }

  void updateEndTime(String endTime) {
    state = state.copyWith(
      endTime: endTime,
      validationErrors: [],
    );
  }

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

  // STEP 2: Driver Selection Methods
  void updateAvailableDrivers(List<UserSignupModel> drivers) {
    state = state.copyWith(availableDrivers: drivers);
  }

  void selectDriver(UserSignupModel driver) {
    state = state.copyWith(
      selectedDriver: driver,
      validationErrors: [],
    );
  }

  // Select driver by ID (for editing existing bookings)
  Future<void> selectDriverByID(String driverID) async {
    try {
      // Fetch driver from service using the driver ID
      final driver = await DriverService.getDriverById(driverID);
      if (driver != null) {
        state = state.copyWith(selectedDriver: driver);
      }
    } catch (serviceError) {
      print('Error fetching driver by ID: $serviceError');
    }
  }

  void updateSearchRadius(double radius) {
    state = state.copyWith(searchRadius: radius);
    // Filter drivers based on new radius
    _filterDriversByRadius();
  }

  void _filterDriversByRadius() {
    // TODO: Implement actual distance filtering logic
    // For now, just keeping all drivers
  }

  // STEP 3: Additional Details Methods (Student Transport)
  void updateVehicleType(String vehicleType) {
    state = state.copyWith(
      selectedVehicleType: vehicleType,
      validationErrors: [],
    );
    _calculatePricing();
  }

  void updateServiceType(String serviceType) {
    state = state.copyWith(
      selectedServiceType: serviceType,
      validationErrors: [],
    );
  }

  void updateTripType(String tripType) {
    state = state.copyWith(
      selectedTripType: tripType,
      validationErrors: [],
    );
  }

  void updateTransportStartDate(String date) {
    state = state.copyWith(
      transportStartDate: date,
      validationErrors: [],
    );
  }

  void updateTransportStartTime(String time) {
    state = state.copyWith(
      transportStartTime: time,
      validationErrors: [],
    );
  }

  void updateTransportEndTime(String time) {
    state = state.copyWith(
      transportEndTime: time,
      validationErrors: [],
    );
  }

  // STEP 3: Additional Details Methods (Teacher/Employee Transport)
  void updateDriverGender(String gender) {
    state = state.copyWith(
      selectedDriverGender: gender,
      validationErrors: [],
    );
  }


  void updateWorkSchedule(String schedule) {
    state = state.copyWith(
      selectedWorkSchedule: schedule,
      validationErrors: [],
    );
  }

  // Pricing Methods
  void _calculatePricing() {
    double? calculatedPrice;
    String unit = 'Riyal';

    // Get base price based on service type and vehicle
    calculatedPrice = _getBasePrice();
    unit = _getPriceUnit();

    // Apply dynamic pricing multipliers
    double finalPrice = calculatedPrice;
    
    // Apply distance multiplier
    if (state.distanceMultiplier != null) {
      finalPrice *= state.distanceMultiplier!;
    }
    
    // Apply time multiplier (peak hours)
    if (state.timeMultiplier != null) {
      finalPrice *= state.timeMultiplier!;
    }
    
    // Apply demand multiplier
    if (state.demandMultiplier != null) {
      finalPrice *= state.demandMultiplier!;
    }
    
    // Apply subscription plan discount
    // finalPrice = _applySubscriptionDiscount(finalPrice, state.selectedSubscriptionPlan);
    
    // Apply payment method discount
    finalPrice = _applyPaymentMethodDiscount(finalPrice, state.selectedPaymentMethod);
    
    // Apply promo code discount
    if (state.promoCode != null && state.promoCode!.isNotEmpty) {
      finalPrice = _applyPromoCodeDiscount(finalPrice, state.promoCode!);
    }

    state = state.copyWith(
      basePrice: calculatedPrice,
      finalPrice: finalPrice,
      priceUnit: unit,
    );
  }

  double _getBasePrice() {
    switch (state.serviceType) {
      case TransportationServiceType.student:
        switch (state.selectedVehicleType) {
          case 'Sedan Car':
            return 800.0;
          case 'Small Van':
            return 600.0;
          case 'Small Bus':
            return 400.0;
          case 'Bus (Large)':
            return 300.0;
          default:
            return 800.0;
        }
      case TransportationServiceType.teacher:
        return 1200.0;
      case TransportationServiceType.employee:
        return 1500.0;
      case TransportationServiceType.daily:
        final hours = state.numberOfHours ?? 8.0;
        final pricePerHour = state.pricePerHour ?? 40.0;
        return hours * pricePerHour;
    }
  }

  String _getPriceUnit() {
    switch (state.serviceType) {
      case TransportationServiceType.student:
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return 'Riyal/Month';
      case TransportationServiceType.daily:
        return 'Riyal';
    }
  }

  // double _applySubscriptionDiscount(double price, String subscriptionPlan) {
  //   switch (subscriptionPlan) {
  //     case 'quarterly':
  //       return price * 0.9; // 10% discount
  //     case 'yearly':
  //       return price * 0.8; // 20% discount
  //     case 'monthly':
  //     default:
  //       return price;
  //   }
  // }

  double _applyPaymentMethodDiscount(double price, String paymentMethod) {
    switch (paymentMethod) {
      case 'mada':
        return price * 0.95; // 5% discount
      case 'apple_pay':
        return price * 0.97; // 3% discount
      case 'wallet':
        return price * 0.98; // 2% discount
      case 'visa':
      case 'mastercard':
      default:
        return price;
    }
  }

  double _applyPromoCodeDiscount(double price, String promoCode) {
    // Simple promo code system - can be enhanced with database lookup
    switch (promoCode.toUpperCase()) {
      case 'STUDENT20':
        return price * 0.8; // 20% discount for students
      case 'FAMILY15':
        return price * 0.85; // 15% discount for families
      case 'COMPANY25':
        return price * 0.75; // 25% discount for companies
      case 'WELCOME10':
        return price * 0.9; // 10% discount for new users
      default:
        return price;
    }
  }

  void updateDailyTransportPricing({
    double? numberOfHours,
    double? pricePerHour,
  }) {
    state = state.copyWith(
      numberOfHours: numberOfHours,
      pricePerHour: pricePerHour,
    );
    _calculatePricing();
  }

  // Initialize daily transport pricing with default values
  void initializeDailyPricing() {
    updateDailyTransportPricing(
      numberOfHours: 8.0,
      pricePerHour: 40.0,
    );
  }

  // Update subscription plan
  void updateSubscriptionPlan(String plan) {
    // state = state.copyWith(selectedSubscriptionPlan: plan);
    _calculatePricing();
  }

  // Update payment method
  void updatePaymentMethod(String method) {
    state = state.copyWith(selectedPaymentMethod: method);
    _calculatePricing();
  }

  // Update promo code
  void updatePromoCode(String? code) {
    state = state.copyWith(promoCode: code);
    _calculatePricing();
  }

  // Update dynamic pricing factors
  void updateDynamicPricing({
    double? distanceMultiplier,
    double? timeMultiplier,
    double? demandMultiplier,
  }) {
    state = state.copyWith(
      distanceMultiplier: distanceMultiplier,
      timeMultiplier: timeMultiplier,
      demandMultiplier: demandMultiplier,
    );
    _calculatePricing();
  }

  // Validation Methods
  bool validateStep1(AppLocalizations l10n) {
    List<String> errors = [];

    if (state.city.trim().isEmpty) {
      errors.add('${l10n.city} is required');
    }

    if (state.pickupAddress == null) {
      errors.add('Pick up location is required');
    }

    if (state.dropOffAddress == null) {
      errors.add('Drop off location is required');
    }

    if (state.serviceType != TransportationServiceType.daily) {
      if (state.schoolName.trim().isEmpty) {
        final institutionName = state.addressType == l10n.university
            ? l10n.universityName
            : state.addressType == l10n.school
                ? l10n.schoolName
                : l10n.institutionName;
        errors.add('$institutionName is required');
      }
    } else {
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

  bool validateStep2() {
    List<String> errors = [];

    if (state.selectedDriver == null) {
      errors.add('Driver selection is required');
    }

    state = state.copyWith(validationErrors: errors);
    return errors.isEmpty;
  }

  bool validateStep3(AppLocalizations l10n) {
    List<String> errors = [];

    switch (state.serviceType) {
      case TransportationServiceType.student:
        if (state.selectedVehicleType.isEmpty) {
          errors.add('Please select a vehicle type (Sedan Car, Small Van, etc.)');
        }
        if (state.selectedServiceType.isEmpty) {
          errors.add('Please select a service type (Private Transport or Group Transport)');
        }
        if (state.selectedTripType.isEmpty) {
          errors.add('Please select a trip type (One Way or Round Trip)');
        }
        if (state.transportStartDate.isEmpty) {
          errors.add('Please select a start date for your transport');
        }
        if (state.transportStartTime.isEmpty) {
          errors.add('Please select a start time for your transport');
        }
        break;

      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        if (state.selectedDriverGender.isEmpty) {
          errors.add('Please select your driver gender preference (Male/Female)');
        }
        // if (false) {
        //   errors.add('Please select a subscription plan (Monthly/Yearly)');
        // }
        if (state.selectedWorkSchedule.isEmpty) {
          errors.add('Please select your work schedule (Morning/Evening/Flexible)');
        }
        break;

      case TransportationServiceType.daily:
        // All details captured in step 1
        break;
    }

    state = state.copyWith(validationErrors: errors);
    return errors.isEmpty;
  }

  // Utility Methods
  void clearErrors() {
    state = state.copyWith(validationErrors: []);
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void resetBooking() {
    state = BookingFlowState(serviceType: state.serviceType);
  }

  // Initialize booking flow from existing RequestBookingModel for editing
  void initializeFromExistingBooking(RequestBookingModel booking) {
    state = BookingFlowState(
      serviceType: booking.serviceType,
      currentStep: 1,

      // Address Details
      addressType: booking.addressType ?? '',
      city: booking.city ?? '',
      schoolName: booking.schoolName ?? '',
      areaDistrict: booking.areaDistrict ?? '',
      selectedDate: booking.selectedDate ?? '',
      startTime: booking.startTime ?? '',
      endTime: booking.endTime ?? '',
      pickupAddress: booking.pickupAddress,
      dropOffAddress: booking.dropOffAddress,

      // Driver Selection - we'll need to find the driver from available list
      // Store the original driver ID for later lookup
      selectedDriver: null,
      availableDrivers: const [],
      searchRadius: 5.0,
      originalDriverID: booking.driverId,

      // Additional Details - Student Transport
      selectedVehicleType: booking.selectedVehicleType ?? '',
      selectedServiceType: booking.selectedServiceType ?? '',
      selectedTripType: booking.selectedTripType ?? '',
      transportStartDate: booking.transportStartDate ?? '',
      transportStartTime: booking.transportStartTime ?? '',
      transportEndTime: booking.transportEndTime ?? '',

      // Additional Details - Teacher/Employee Transport
      selectedDriverGender: booking.selectedDriverGender ?? '',
      selectedWorkSchedule: booking.selectedWorkSchedule ?? '',

      // Pricing
      basePrice: booking.basePrice,
      finalPrice: booking.finalPrice,
      priceUnit: booking.priceUnit ?? 'Riyal',
      numberOfHours: booking.numberOfHours,
      pricePerHour: booking.pricePerHour,

      // Clear validation errors
      validationErrors: const [],
    );
  }

  // Get booking summary
  Map<String, dynamic> getBookingSummary() {
    return {
      'serviceType': _getFormattedServiceType(),
      'location': _getFormattedLocation(),
      'schedule': state.formattedSchedule,
      'price': state.formattedPrice,
      'driver': state.selectedDriver?.name ?? 'Not selected',
      'isComplete': state.isBookingComplete,
      'currentStep': state.currentStep,
    };
  }

  String _getFormattedServiceType() {
    switch (state.serviceType) {
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

  String _getFormattedLocation() {
    if (state.serviceType == TransportationServiceType.daily) {
      return '${state.city}, ${state.areaDistrict}';
    } else {
      return '${state.schoolName}, ${state.city}';
    }
  }

  // Load drivers from Firestore users collection where isDriver is true
  Future<void> loadAvailableDrivers() async {
    try {
      setLoading(true);

      // Use the driver service to fetch drivers
      final drivers = await DriverService.getAvailableDrivers();

      updateAvailableDrivers(drivers);
      setLoading(false);
    } catch (e) {
      print('Error loading drivers: $e');
      // On error, keep existing drivers or show empty list
      setLoading(false);
    }
  }

  // Load drivers near a specific location
  Future<void> loadDriversNearLocation(LatLng location,
      {double radius = 5.0}) async {
    try {
      setLoading(true);

      // Use the driver service to fetch nearby drivers
      final drivers = await DriverService.getDriversNearLocation(
        userLocation: location,
        radiusInKm: radius,
      );

      updateAvailableDrivers(drivers);
      setLoading(false);
    } catch (e) {
      print('Error loading nearby drivers: $e');
      setLoading(false);
    }
  }

  // Filter drivers by gender preference
  void filterDriversByGender(String? genderPreference) {
    final filteredDrivers = DriverService.filterDriversByGender(
      state.availableDrivers,
      genderPreference,
    );
    updateAvailableDrivers(filteredDrivers);
  }

  // Filter drivers by role
  void filterDriversByRole(String? rolePreference) {
    final filteredDrivers = DriverService.filterDriversByRole(
      state.availableDrivers,
      rolePreference,
    );
    updateAvailableDrivers(filteredDrivers);
  }

  // Get driver statistics
  Map<String, dynamic> getDriverStats(UserSignupModel driver) {
    return DriverService.getDriverStats(driver);
  }
}
