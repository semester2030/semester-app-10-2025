import 'package:semester_student_ride_app/providers/user_bookings_provider.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/providers/booking_flow_provider.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/services/driver_service.dart';
import 'package:semester_student_ride_app/services/booking_service.dart';
import 'package:semester_student_ride_app/providers/current_user_provider.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';

class BookingDetailsPage extends HookConsumerWidget {
  final TransportationServiceType serviceType;
  final Map<String, dynamic>? acceptedOfferData;

  const BookingDetailsPage({
    super.key,
    required this.serviceType,
    this.acceptedOfferData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bookingState = ref.watch(bookingFlowProvider);

    // Handle accepted offer data
    useEffect(() {
      if (acceptedOfferData != null) {
        // Accepted offer data received: ${acceptedOfferData!['providerName']}
        // Here you can update the booking state with offer data
        // For example, set the selected driver from the offer
      }
      return null;
    }, [acceptedOfferData]);

    return ScreenWithTopAppbar(
      title: l10n.bookingDetails,
      child: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(24.w, 160.h, 24.w, 32.h),
              padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Accepted Offer Section (if coming from offers list)
                    if (acceptedOfferData != null) ...[
                      _buildAcceptedOfferSection(context, acceptedOfferData!),
                      24.verticalSpace,
                    ],
                    
                    // Driver Profile Section
                    _buildDriverProfileSection(context, bookingState),

                    24.verticalSpace,

                    // Transportation Details
                    _buildTransportationDetails(context, bookingState),

                    24.verticalSpace,

                    // Trip Details Section
                    _buildTripDetails(context, bookingState),

                    24.verticalSpace,

                    // Cost Section
                    _buildCostSection(context, bookingState),

                    24.verticalSpace,

                    // Payment Method
                    _buildPaymentMethod(context, bookingState),

                    32.verticalSpace,

                    // Action Buttons
                    _buildActionButtons(context, ref),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverProfileSection(
      BuildContext context, BookingFlowState bookingState) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: containerbackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CircularProfileImage(
            imageUrl: bookingState.selectedDriver?.profilePicture ?? '',
            radius: 25,
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookingState.selectedDriver?.name ?? l10n.driverName,
                  style: montserrat(16, grey36, FontWeight.w600),
                ),
                4.verticalSpace,
                Row(
                  children: [
                    Text(
                      '${bookingState.selectedDriver?.role ?? l10n.student} - ',
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                    Icon(
                      Icons.star,
                      color: yellowE2A640,
                      size: 14.sp,
                    ),
                    2.horizontalSpace,
                    Text(
                      '4.5 (${l10n.rating})', // Using static rating for now
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                  ],
                ),
                8.verticalSpace,
              ],
            ),
          ),
          Text(
            '2.5 km', // Using static distance for now
            style: montserrat(14, grey36, FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportationDetails(
      BuildContext context, BookingFlowState bookingState) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                l10n.type,
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                l10n.city,
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ),
          ],
        ),
        4.verticalSpace,
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                _getFormattedServiceType(context, bookingState.serviceType),
                style: montserrat(14, grey36, FontWeight.w500),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                bookingState.city.isNotEmpty
                    ? bookingState.city
                    : l10n.notSpecified,
                style: montserrat(14, grey36, FontWeight.w500),
              ),
            ),
          ],
        ),
        // Add Institution/University row if available
        if (bookingState.schoolName.isNotEmpty &&
            bookingState.serviceType != TransportationServiceType.daily) ...[
          16.verticalSpace,
          Text(
            l10n.institution, // or l10n.university if available
            style: montserrat(12, grey5F63, FontWeight.w400),
          ),
          4.verticalSpace,
          Text(
            bookingState.schoolName,
            style: montserrat(14, grey36, FontWeight.w500),
          ),
        ],
        16.verticalSpace,
        Text(
          l10n.pickupLocation,
          style: montserrat(12, grey5F63, FontWeight.w400),
        ),
        4.verticalSpace,
        Text(
          _getPickupLocation(context, bookingState),
          style: montserrat(14, grey36, FontWeight.w500),
        ),
        16.verticalSpace,
        Text(
          l10n.destination,
          style: montserrat(12, grey5F63, FontWeight.w400),
        ),
        4.verticalSpace,
        Text(
          _getDestination(context, bookingState),
          style: montserrat(14, grey36, FontWeight.w500),
        ),
        20.verticalSpace,
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: containerbackground,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: iconPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.directions_car,
                  color: iconPurple,
                  size: 24.sp,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getVehicleInfo(context, bookingState),
                      style: montserrat(14, grey36, FontWeight.w600),
                    ),
                    4.verticalSpace,
                    Text(
                      '${l10n.serviceType}: ${bookingState.selectedServiceType.isNotEmpty ? bookingState.selectedServiceType : l10n.notSpecified}',
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${bookingState.finalPrice?.toStringAsFixed(0) ?? '0'} ${_getPriceUnit(context, bookingState)}',
                    style: montserrat(16, grey36, FontWeight.w600),
                  ),
                  Text(
                    l10n.fare,
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTripDetails(
      BuildContext context, BookingFlowState bookingState) {
    final l10n = AppLocalizations.of(context)!;
    final isEditMode = bookingState.originalDriverID != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.bookingStatus,
          style: montserrat(12, grey5F63, FontWeight.w400),
        ),
        4.verticalSpace,
        Text(
          isEditMode ? "Editing" : l10n.draft, // Show "Editing" if in edit mode
          style: montserrat(14, grey36, FontWeight.w500),
        ),
        20.verticalSpace,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pickupTime,
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                  4.verticalSpace,
                  Text(
                    _getPickupTime(context, bookingState),
                    style: montserrat(14, grey36, FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.tripType,
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                  4.verticalSpace,
                  Text(
                    bookingState.selectedTripType.isNotEmpty
                        ? bookingState.selectedTripType
                        : l10n.notSpecified,
                    style: montserrat(14, grey36, FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        16.verticalSpace,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.pickupDate,
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                  4.verticalSpace,
                  Text(
                    _getPickupDate(context, bookingState),
                    style: montserrat(14, grey36, FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.workSchedule,
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                  4.verticalSpace,
                  Text(
                    bookingState.selectedWorkSchedule.isNotEmpty
                        ? bookingState.selectedWorkSchedule
                        : l10n.notSpecified,
                    style: montserrat(14, grey36, FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (bookingState.serviceType == TransportationServiceType.teacher ||
            bookingState.serviceType == TransportationServiceType.employee) ...[
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.driverGender,
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                    4.verticalSpace,
                    Text(
                      bookingState.selectedDriverGender.isNotEmpty
                          ? bookingState.selectedDriverGender
                          : l10n.any,
                      style: montserrat(14, grey36, FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.subscriptionPlan,
                      style: montserrat(12, grey5F63, FontWeight.w400),
                    ),
                    4.verticalSpace,
                    Text(
                      'Monthly',
                      style: montserrat(14, grey36, FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCostSection(
      BuildContext context, BookingFlowState bookingState) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.cost,
          style: montserrat(16, grey36, FontWeight.w600),
        ),
        16.verticalSpace,
        if (bookingState.serviceType == TransportationServiceType.daily) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.hours,
                style: montserrat(14, grey5F63, FontWeight.w400),
              ),
              Text(
                '${bookingState.numberOfHours ?? 8.0}',
                style: montserrat(14, grey36, FontWeight.w500),
              ),
            ],
          ),
          12.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.pricePerHour,
                style: montserrat(14, grey5F63, FontWeight.w400),
              ),
              Text(
                '${bookingState.pricePerHour ?? 40.0} ${l10n.riyal}',
                style: montserrat(14, grey36, FontWeight.w500),
              ),
            ],
          ),
          12.verticalSpace,
        ] else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.basePrice,
                style: montserrat(14, grey5F63, FontWeight.w400),
              ),
              Text(
                '${bookingState.basePrice?.toStringAsFixed(0) ?? '0'} ${_getPriceUnit(context, bookingState)}',
                style: montserrat(14, grey36, FontWeight.w500),
              ),
            ],
          ),
          12.verticalSpace,
        ],
        
        // Subscription Plan
        
        // Payment Method
        if (bookingState.selectedPaymentMethod.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Payment Method:',
                style: montserrat(14, grey5F63, FontWeight.w400),
              ),
              Text(
                _getPaymentMethodName(bookingState.selectedPaymentMethod),
                style: montserrat(14, grey36, FontWeight.w500),
              ),
            ],
          ),
          12.verticalSpace,
        ],
        
        // Promo Code
        if (bookingState.promoCode != null && bookingState.promoCode!.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Promo Code:',
                style: montserrat(14, grey5F63, FontWeight.w400),
              ),
              Text(
                bookingState.promoCode!,
                style: montserrat(14, Colors.green[700]!, FontWeight.w500),
              ),
            ],
          ),
          12.verticalSpace,
        ],
        
        // Discounts
        if (bookingState.discountPercentage != null && bookingState.discountPercentage! > 0) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Discount:',
                style: montserrat(14, grey5F63, FontWeight.w400),
              ),
              Text(
                '-${(bookingState.discountPercentage! * 100).toStringAsFixed(0)}%',
                style: montserrat(14, Colors.green[700]!, FontWeight.w500),
              ),
            ],
          ),
          12.verticalSpace,
        ],
        
        // Divider
        Container(
          height: 1,
          color: Colors.grey[300],
        ),
        12.verticalSpace,
        
        // Final Price
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n.finalPrice,
              style: montserrat(16, grey36, FontWeight.w600),
            ),
            Text(
              '${bookingState.finalPrice?.toStringAsFixed(0) ?? '0'} ${_getPriceUnit(context, bookingState)}',
              style: montserrat(18, accentPurple, FontWeight.w700),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(
      BuildContext context, BookingFlowState bookingState) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: containerbackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Image.asset(
            AppImages.masterCard,
            height: 30.h,
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '**** 8989',
                style: montserrat(14, grey36, FontWeight.w600),
              ),
              4.verticalSpace,
              Text(
                l10n.masterCard,
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bookingState = ref.watch(bookingFlowProvider);

    // Check if we're in edit mode by checking if there's an original driver ID
    final isEditMode = bookingState.originalDriverID != null;

    return NormalCustomButton(
      label: isEditMode ? "Update Booking" : l10n.confirmBooking,
      height: 40,
      titleStyle: montserrat(12, whiteColor, FontWeight.w500),
      syncCallback: () {
        _confirmBooking(context, ref);
      },
    );
  }

  // Helper methods
  String _getFormattedServiceType(
      BuildContext context, TransportationServiceType serviceType) {
    final l10n = AppLocalizations.of(context)!;
    switch (serviceType) {
      case TransportationServiceType.student:
        return l10n.student;
      case TransportationServiceType.teacher:
        return l10n.teacher;
      case TransportationServiceType.employee:
        return l10n.employee;
      case TransportationServiceType.daily:
        return l10n.dailyTransport;
    }
  }

  String _getPickupLocation(
      BuildContext context, BookingFlowState bookingState) {
    final l10n = AppLocalizations.of(context)!;

    // Use pickupAddress if available, otherwise fall back to old logic
    if (bookingState.pickupAddress != null &&
        bookingState.pickupAddress!.address.isNotEmpty) {
      return bookingState.pickupAddress!.address;
    }

    // Fallback logic for when addresses haven't been set
    if (bookingState.serviceType == TransportationServiceType.daily) {
      return '${bookingState.areaDistrict.isNotEmpty ? bookingState.areaDistrict : l10n.area}, ${bookingState.city.isNotEmpty ? bookingState.city : l10n.city}';
    } else {
      return '${bookingState.schoolName.isNotEmpty ? bookingState.schoolName : l10n.institution}, ${bookingState.areaDistrict.isNotEmpty ? bookingState.areaDistrict : l10n.neighborhood}';
    }
  }

  String _getDestination(BuildContext context, BookingFlowState bookingState) {
    final l10n = AppLocalizations.of(context)!;

    // Use dropOffAddress if available, otherwise fall back to old logic
    if (bookingState.dropOffAddress != null &&
        bookingState.dropOffAddress!.address.isNotEmpty) {
      return bookingState.dropOffAddress!.address;
    }

    // Fallback logic for when addresses haven't been set
    if (bookingState.serviceType == TransportationServiceType.daily) {
      return bookingState.pickupAddress?.address ?? l10n.destination;
    } else {
      return '${bookingState.city.isNotEmpty ? bookingState.city : l10n.city} - ${bookingState.addressType.isNotEmpty ? bookingState.addressType : 'Location'}';
    }
  }

  String _getVehicleInfo(BuildContext context, BookingFlowState bookingState) {
    final l10n = AppLocalizations.of(context)!;
    if (bookingState.serviceType == TransportationServiceType.student) {
      return bookingState.selectedVehicleType.isNotEmpty
          ? bookingState.selectedVehicleType
          : l10n.vehicle;
    } else {
      return l10n.serviceVehicle;
    }
  }

  String _getPriceUnit(BuildContext context, BookingFlowState bookingState) {
    String unit = bookingState.priceUnit;
    // Convert to AED for display consistency with original design
    if (unit.contains('Riyal')) {
      return 'AED';
    }
    return unit;
  }

  String _getPickupTime(BuildContext context, BookingFlowState bookingState) {
    final l10n = AppLocalizations.of(context)!;
    if (bookingState.serviceType == TransportationServiceType.daily) {
      return bookingState.startTime.isNotEmpty
          ? bookingState.startTime
          : l10n.notSpecified;
    } else if (bookingState.serviceType == TransportationServiceType.student) {
      return bookingState.transportStartTime.isNotEmpty
          ? bookingState.transportStartTime
          : l10n.notSpecified;
    } else {
      return l10n.asPerSchedule;
    }
  }

  String _getPickupDate(BuildContext context, BookingFlowState bookingState) {
    final l10n = AppLocalizations.of(context)!;
    if (bookingState.serviceType == TransportationServiceType.daily) {
      return bookingState.selectedDate.isNotEmpty
          ? bookingState.selectedDate
          : l10n.notSpecified;
    } else if (bookingState.serviceType == TransportationServiceType.student) {
      return bookingState.transportStartDate.isNotEmpty
          ? bookingState.transportStartDate
          : l10n.notSpecified;
    } else {
      return l10n.asPerSchedule;
    }
  }

  void _confirmBooking(BuildContext context, WidgetRef ref) async {
    final bookingState = ref.read(bookingFlowProvider);

    // Check if we're in edit mode
    final isEditMode = bookingState.originalDriverID != null;

    // Validate that we have all required data
    if (bookingState.selectedDriver == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No driver selected'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text(isEditMode
                      ? "Updating booking..."
                      : "Submitting booking..."),
                ],
              ),
            ),
          );
        },
      );

      // Get current user data
      final currentUserAsyncValue = ref.read(currentUserDetailsProvider);
      UserSignupModel? currentUser;

      await currentUserAsyncValue.when(
        data: (user) async {
          currentUser = user;
        },
        loading: () async {
          // Wait for the user data to load
          final userDetails = await ref.read(currentUserDetailsProvider.future);
          currentUser = userDetails;
        },
        error: (error, stackTrace) async {
          throw Exception('Failed to get user details: $error');
        },
      );

      // Submit booking to Firebase
      final bookingService = BookingService();
      final bookingId = await bookingService.submitBooking(
        bookingState: bookingState,
        currentUser: currentUser,
      );

      // Close loading dialog
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (bookingId != null) {
        // Booking was successful
        if (context.mounted) {
          // Reset the booking flow state
          ref.read(bookingFlowProvider.notifier).resetBooking();
          ref.invalidate(pendingAndActiveBookingsProvider);
          ref.invalidate(userBookingsProvider);

          // Show congratulations dialog
          _showCongratulationsDialog(context, isEditMode);
        }
      } else {
        // Booking failed
        if (context.mounted) {
          showErrorFlushBar(
              message: isEditMode
                  ? 'Failed to update booking. Please try again.'
                  : 'Failed to submit booking. Please try again.',
              context: context);
        }
      }
    } catch (e) {
      // Close loading dialog if it's open
      if (context.mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        showErrorFlushBar(
            message: isEditMode
                ? 'Error updating booking: ${e.toString()}'
                : 'Error submitting booking: ${e.toString()}',
            context: context);
      }
    }
  }

  void _showCongratulationsDialog(BuildContext context,
      [bool isEditMode = false]) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                SvgPicture.asset(AppIcons.confirmBooking),

                24.verticalSpace,

                // Congratulations Text
                Text(
                  isEditMode ? "Success!" : l10n.congratulation,
                  style: montserrat(24, grey36, FontWeight.w600),
                  textAlign: TextAlign.center,
                ),

                16.verticalSpace,

                // Description Text
                Text(
                  isEditMode
                      ? "Your booking has been updated successfully!"
                      : l10n.bookingSuccessMessage,
                  style: montserrat(14, grey5F63, FontWeight.w400),
                  textAlign: TextAlign.center,
                ),

                32.verticalSpace,

                // Go to Booking Button
                NormalCustomButton(
                  label: l10n.goToBooking,
                  titleStyle: montserrat(16, whiteColor, FontWeight.w500),
                  syncCallback: () {
                    context.go('/bottom_nav_bar'); // Navigate to bottom nav bar
                  },
                ),

                16.verticalSpace,

                // Close Button
                NormalCustomButton(
                  label: l10n.close,
                  titleStyle: montserrat(16, grey5E5E5E, FontWeight.w500),
                  buttonColor: Color(0xffF3F8FE),
                  syncCallback: () {
                    context.go('/bottom_nav_bar'); // Navigate to bottom nav bar
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  String _getPaymentMethodName(String method) {
    switch (method) {
      case 'mada':
        return 'Mada (5% off)';
      case 'visa':
        return 'Visa';
      case 'mastercard':
        return 'Mastercard';
      case 'apple_pay':
        return 'Apple Pay (3% off)';
      case 'wallet':
        return 'Digital Wallet (2% off)';
      default:
        return method;
    }
  }

  Widget _buildAcceptedOfferSection(BuildContext context, Map<String, dynamic> offerData) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
              12.horizontalSpace,
              Text(
                'Offer Accepted!',
                style: montserrat(18, Colors.green[700]!, FontWeight.w600),
              ),
            ],
          ),
          16.verticalSpace,
          
          // Provider info
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundImage: NetworkImage(offerData['providerPhoto'] ?? ''),
                backgroundColor: Colors.grey[300],
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offerData['providerName'] ?? 'Provider',
                      style: montserrat(16, grey36, FontWeight.w600),
                    ),
                    4.verticalSpace,
                    Row(
                      children: [
                        Icon(Icons.star, size: 16.sp, color: Colors.amber),
                        4.horizontalSpace,
                        Text(
                          '${offerData['rating']?.toStringAsFixed(1) ?? '0.0'}',
                          style: montserrat(14, grey36, FontWeight.w500),
                        ),
                        8.horizontalSpace,
                        Text(
                          '• ${offerData['tripsCount'] ?? 0} trips',
                          style: montserrat(12, grey5F63, FontWeight.w400),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'SAR ${offerData['price']?.toStringAsFixed(0) ?? '0'}',
                    style: montserrat(18, accentPurple, FontWeight.w700),
                  ),
                  Text(
                    offerData['priceType'] == 'monthly' ? 'per month' : 'per ride',
                    style: montserrat(12, grey5F63, FontWeight.w400),
                  ),
                ],
              ),
            ],
          ),
          
          16.verticalSpace,
          
          // Vehicle info
          Row(
            children: [
              Icon(Icons.directions_car, size: 16.sp, color: grey5F63),
              8.horizontalSpace,
              Text(
                '${offerData['vehicleType'] ?? ''} • ${offerData['vehicleModel'] ?? ''}',
                style: montserrat(14, grey36, FontWeight.w500),
              ),
              16.horizontalSpace,
              Icon(Icons.people, size: 16.sp, color: grey5F63),
              8.horizontalSpace,
              Text(
                '${offerData['seats'] ?? 0} seats',
                style: montserrat(14, grey36, FontWeight.w500),
              ),
            ],
          ),
          
          16.verticalSpace,
          
          // ETA and distance
          Row(
            children: [
              Icon(Icons.access_time, size: 16.sp, color: accentPurple),
              8.horizontalSpace,
              Text(
                'ETA: ${offerData['etaMinutes'] ?? 0} min',
                style: montserrat(14, accentPurple, FontWeight.w600),
              ),
              16.horizontalSpace,
              Icon(Icons.location_on, size: 16.sp, color: grey5F63),
              8.horizontalSpace,
              Text(
                'Distance: ${offerData['distanceKm']?.toStringAsFixed(1) ?? '0.0'} km',
                style: montserrat(14, grey5F63, FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
