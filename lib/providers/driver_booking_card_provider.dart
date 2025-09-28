import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/services/booking_service.dart';
import 'package:semester_student_ride_app/providers/driver_bookings_provider.dart';
import 'package:semester_student_ride_app/providers/user_bookings_provider.dart';
import 'package:semester_student_ride_app/providers/trip_tracking_provider.dart';
import 'package:semester_student_ride_app/utils/distance_utils.dart';
import 'package:semester_student_ride_app/utils/chat_utils.dart';
import 'package:semester_student_ride_app/widgets/app_dialogs.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:go_router/go_router.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

// Provider state class for managing booking card logic
class DriverBookingCardState {
  final bool isLoading;
  final String? errorMessage;
  final bool isProcessingAction;

  const DriverBookingCardState({
    this.isLoading = false,
    this.errorMessage,
    this.isProcessingAction = false,
  });

  DriverBookingCardState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isProcessingAction,
  }) {
    return DriverBookingCardState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isProcessingAction: isProcessingAction ?? this.isProcessingAction,
    );
  }
}

// Provider for managing booking card business logic
class DriverBookingCardNotifier extends StateNotifier<DriverBookingCardState> {
  final Ref ref;

  DriverBookingCardNotifier(this.ref) : super(const DriverBookingCardState());

  // Handle accept booking functionality
  Future<bool> handleAcceptBooking(
    BuildContext context,
    RequestBookingModel booking,
    AppLocalizations l10n,
    UserSignupModel? userProfile,
  ) async {
    log('DEBUG: handleAcceptBooking called - START');
    log('DEBUG: Provider mounted status: $mounted');

    // Don't check mounted before showing dialog - let user see the dialog first
    try {
      // Debug the booking data before processing
      log('DEBUG: _handleAcceptBooking - Booking ID: ${booking.id}');
      log('DEBUG: _handleAcceptBooking - Booking Status: ${booking.status}');
      log('DEBUG: _handleAcceptBooking - User ID: ${booking.userId}');

      // Validate booking data first
      if (booking.id == null || booking.id!.isEmpty) {
        log('ERROR: Booking ID is null or empty');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid booking data. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }

      // Show confirmation dialog first before any state changes
      final shouldAccept = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            l10n.acceptBooking,
            style: montserrat(16, grey36, FontWeight.w600),
          ),
          content: Text('Are you sure you want to accept this booking ?',
              style: montserrat(14, grey36, FontWeight.w500)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No', style: montserrat(14, grey36, FontWeight.w500)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes',
                  style: montserrat(14, accentPurple, FontWeight.w500)),
            ),
          ],
        ),
      );

      if (shouldAccept != true) {
        log('DEBUG: User cancelled the accept booking action');
        return false;
      }

      // Only check mounted after user confirms and we're about to change state
      if (!mounted) {
        log('DEBUG: Provider was disposed after user confirmation');
        return false;
      }

      log('DEBUG: Setting processing state...');
      state = state.copyWith(isProcessingAction: true);

      log('DEBUG: Calling BookingService.acceptBooking...');

      // Call the booking service to accept the booking
      final bookingService = BookingService();
      final success = await bookingService.acceptBooking(booking: booking);

      log('DEBUG: BookingService.acceptBooking result: $success');

      if (success) {
        log('DEBUG: Booking accepted successfully, invalidating providers...');

        // Invalidate providers to refresh the UI
        ref.invalidate(driverBookingsProvider);
        ref.invalidate(userBookingsProvider);

        // Show success dialog
        if (context.mounted) {
          log('DEBUG: Showing success dialog...');
          await AppDialogs.showAcceptBookingDialog(
            context,
            studentName: userProfile?.name ??
                _getStudentNameFromServiceType(booking.serviceType, l10n),
            onGoToBooking: () {
              // Navigate to booking details or driver home
              // context.go('/bottom_nav_bar');
            },
            onGoToHome: () {
              // Navigate to driver home
              // context.go('/bottom_nav_bar');
            },
          );
        }
      } else {
        log('ERROR: Failed to accept booking');
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to accept booking. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      if (mounted) {
        state = state.copyWith(isProcessingAction: false);
      }
      return success;
    } catch (e, stackTrace) {
      log('ERROR: Exception in _handleAcceptBooking: $e');
      log('STACK TRACE: $stackTrace');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (mounted) {
        state = state.copyWith(isProcessingAction: false);
      }
      return false;
    }
  }

  // Handle decline booking functionality
  Future<bool> handleDeclineBooking(
    BuildContext context,
    RequestBookingModel booking,
    AppLocalizations l10n,
    UserSignupModel? userProfile,
  ) async {
    try {
      if (!mounted) return false;
      state = state.copyWith(isProcessingAction: true);

      // Show confirmation dialog first
      final shouldDecline = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            l10n.declineBooking,
            style: montserrat(16, grey36, FontWeight.w600),
          ),
          content: Text(
              'Are you sure you want to decline this booking? This action cannot be undone.',
              style: montserrat(14, grey36, FontWeight.w500)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('No', style: montserrat(14, grey36, FontWeight.w500)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Yes',
                  style: montserrat(14, Colors.red, FontWeight.w500)),
            ),
          ],
        ),
      );

      if (shouldDecline != true) {
        if (mounted) {
          state = state.copyWith(isProcessingAction: false);
        }
        return false;
      }

      // Call the booking service to decline the booking
      final bookingService = BookingService();
      final success = await bookingService.declineBooking(
        booking: booking,
        reason: 'Declined by driver',
      );

      if (success) {
        // Invalidate providers to refresh the UI
        ref.invalidate(driverBookingsProvider);
        ref.invalidate(userBookingsProvider);

        // Show success dialog
        if (context.mounted) {
          await AppDialogs.showDeclineBookingDialog(
            context,
            onGoToNewBooking: () {
              // Navigate to driver home to find new bookings
              context.go('/bottom_nav_bar');
            },
            onGoToHome: () {
              // Navigate to driver home
              context.go('/bottom_nav_bar');
            },
          );
        }
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to decline booking. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      if (mounted) {
        state = state.copyWith(isProcessingAction: false);
      }
      return success;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (mounted) {
        state = state.copyWith(isProcessingAction: false);
      }
      return false;
    }
  }

  // Handle driver is coming functionality
  Future<bool> handleDriverIsComing(
    BuildContext context,
    RequestBookingModel booking,
    AppLocalizations l10n,
    UserSignupModel? userProfile,
  ) async {
    try {
      if (!mounted) return false;
      state = state.copyWith(isProcessingAction: true);

      // Show confirmation dialog first
      final shouldProceed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "I'm Coming",
            style: montserrat(16, grey36, FontWeight.w600),
          ),
          content: Text(
              'Are you sure you want to notify the passenger that you are coming? This will enable live location tracking.',
              style: montserrat(14, grey36, FontWeight.w500)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel',
                  style: montserrat(14, grey36, FontWeight.w500)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("I'm Coming",
                  style: montserrat(14, Colors.blue, FontWeight.w500)),
            ),
          ],
        ),
      );

      if (shouldProceed != true) {
        if (mounted) {
          state = state.copyWith(isProcessingAction: false);
        }
        return false;
      }

      // Call the trip tracking service
      final tripTrackingNotifier = ref.read(tripTrackingProvider.notifier);
      final success = await tripTrackingNotifier.driverIsComing(booking);

      if (success) {
        // Invalidate providers to refresh the UI
        ref.invalidate(driverBookingsProvider);
        ref.invalidate(userBookingsProvider);

        // Show success message
        if (context.mounted) {
          showSuccessFlushBar(
              message:
                  'Passenger notified! You can now start driving to the destination.',
              context: context);
        }
      } else {
        // Show error message
        if (context.mounted) {
          showErrorFlushBar(
              message: 'Failed to notify passenger. Please try again.',
              context: context);
        }
      }

      if (mounted) {
        state = state.copyWith(isProcessingAction: false);
      }
      return success;
    } catch (e) {
      if (context.mounted) {
        showErrorFlushBar(
            message: 'An error occurred: ${e.toString()}', context: context);
      }

      if (mounted) {
        state = state.copyWith(isProcessingAction: false);
      }
      return false;
    }
  }

  // Handle start trip functionality
  Future<bool> handleStartTrip(
    BuildContext context,
    RequestBookingModel booking,
    AppLocalizations l10n,
    UserSignupModel? userProfile,
  ) async {
    try {
      if (!mounted) return false;
      state = state.copyWith(isProcessingAction: true);

      // Show confirmation dialog first
      final shouldStart = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Start Trip',
            style: montserrat(16, grey36, FontWeight.w600),
          ),
          content: Text(
              'Are you sure you want to start the trip? This will enable live location tracking for the passenger.',
              style: montserrat(14, grey36, FontWeight.w500)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel',
                  style: montserrat(14, grey36, FontWeight.w500)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Start Trip',
                  style: montserrat(14, Colors.green, FontWeight.w500)),
            ),
          ],
        ),
      );

      if (shouldStart != true) {
        if (mounted) {
          state = state.copyWith(isProcessingAction: false);
        }
        return false;
      }

      // Start the trip using trip tracking service
      final tripTrackingNotifier = ref.read(tripTrackingProvider.notifier);
      final success = await tripTrackingNotifier.startTrip(booking);

      if (success) {
        // Invalidate providers to refresh the UI
        ref.invalidate(driverBookingsProvider);
        ref.invalidate(userBookingsProvider);

        // Show success message
        if (context.mounted) {
          showSuccessFlushBar(
              message:
                  'Trip started successfully! Live tracking is now enabled.',
              context: context);
        }
      } else {
        // Show error message
        if (context.mounted) {
          showErrorFlushBar(
              message: 'Failed to start trip. Please try again.',
              context: context);
        }
      }

      if (mounted) {
        state = state.copyWith(isProcessingAction: false);
      }
      return success;
    } catch (e) {
      if (context.mounted) {
        showErrorFlushBar(
            message: 'An error occurred: ${e.toString()}', context: context);
      }

      if (mounted) {
        state = state.copyWith(isProcessingAction: false);
      }
      return false;
    }
  }

  // Handle end trip functionality
  Future<bool> handleEndTrip(
    BuildContext context,
    RequestBookingModel booking,
    AppLocalizations l10n,
    UserSignupModel? userProfile,
  ) async {
    try {
      if (!mounted) return false;
      state = state.copyWith(isProcessingAction: true);

      // Show confirmation dialog first
      final shouldEnd = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'End Trip',
            style: montserrat(16, grey36, FontWeight.w600),
          ),
          content: Text(
              'Are you sure you want to end the trip? This will mark the booking as completed.',
              style: montserrat(14, grey36, FontWeight.w500)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel',
                  style: montserrat(14, grey36, FontWeight.w500)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('End Trip',
                  style: montserrat(14, Colors.red, FontWeight.w500)),
            ),
          ],
        ),
      );

      if (shouldEnd != true) {
        if (mounted) {
          state = state.copyWith(isProcessingAction: false);
        }
        return false;
      }

      // End the trip using trip tracking service
      final tripTrackingNotifier = ref.read(tripTrackingProvider.notifier);
      final success = await tripTrackingNotifier.endTrip(booking);

      if (success) {
        // Invalidate providers to refresh the UI
        ref.invalidate(driverBookingsProvider);
        ref.invalidate(userBookingsProvider);

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Trip completed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to end trip. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      if (mounted) {
        state = state.copyWith(isProcessingAction: false);
      }
      return success;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (mounted) {
        state = state.copyWith(isProcessingAction: false);
      }
      return false;
    }
  }

  // Handle chat with user
  void handleChatWithUser(
    BuildContext context,
    UserSignupModel? userProfile,
    WidgetRef widgetRef,
  ) {
    if (userProfile != null) {
      ChatUtils.startChat(
        context: context,
        otherUser: userProfile,
        ref: widgetRef,
      );
    }
  }

  // Handle close booking
  Future<void> handleCloseBooking(BuildContext context) async {
    await AppDialogs.showDeclineBookingDialog(
      context,
      onGoToNewBooking: () {
        context.go('/bottom_nav_bar');
      },
      onGoToHome: () {
        context.go('/bottom_nav_bar');
      },
    );
  }

  // Simple one-time distance check function for pickup
  Future<bool> checkDriverWithinPickupRange(
      String driverId, LatLng pickupLocation) async {
    try {
      // Get current driver location from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(driverId)
          .get();

      if (!userDoc.exists) {
        log('DEBUG: Driver document does not exist');
        return false;
      }

      final data = userDoc.data() as Map<String, dynamic>;
      final currentLocation = data['currentLocation'] as Map<String, dynamic>?;

      if (currentLocation == null) {
        log('DEBUG: No current location found for driver');
        return false;
      }

      final driverLatLng = LatLng(
        currentLocation['latitude']?.toDouble() ?? 0.0,
        currentLocation['longitude']?.toDouble() ?? 0.0,
      );

      // Calculate distance using DistanceUtils
      final distance =
          DistanceUtils.calculateDistance(driverLatLng, pickupLocation);
      final isWithinRange = distance <= 100.0; // 1000 meters for testing

      log('DEBUG: One-time distance check: ${distance.toStringAsFixed(1)}m, Within range: $isWithinRange');

      return isWithinRange;
    } catch (e) {
      log('DEBUG: Error in distance check: $e');
      return false;
    }
  }

// Simple one-time destination distance check function
  Future<bool> checkDriverWithinDestinationRange(
      String driverId, LatLng destinationLocation) async {
    try {
      // Get current driver location from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(driverId)
          .get();

      if (!userDoc.exists) {
        log('DEBUG: Driver document does not exist');
        return false;
      }

      final data = userDoc.data() as Map<String, dynamic>;
      final currentLocation = data['currentLocation'] as Map<String, dynamic>?;

      if (currentLocation == null) {
        log('DEBUG: No current location found for driver');
        return false;
      }

      final driverLatLng = LatLng(
        currentLocation['latitude']?.toDouble() ?? 0.0,
        currentLocation['longitude']?.toDouble() ?? 0.0,
      );

      // Calculate distance using DistanceUtils
      final distance =
          DistanceUtils.calculateDistance(driverLatLng, destinationLocation);
      final isWithinRange = distance <= 500.0; // 500 meters for destination

      log('DEBUG: One-time destination distance check: ${distance.toStringAsFixed(1)}m, Within range: $isWithinRange');

      return isWithinRange;
    } catch (e) {
      log('DEBUG: Error in destination distance check: $e');
      return false;
    }
  }

  // Helper method to get role description based on service type
  String _getStudentNameFromServiceType(
      TransportationServiceType serviceType, AppLocalizations l10n) {
    switch (serviceType) {
      case TransportationServiceType.student:
        return l10n.theStudent;
      case TransportationServiceType.teacher:
      case TransportationServiceType.employee:
        return l10n.theEmployee;
      case TransportationServiceType.daily:
        return l10n.theUser;
    }
  }
}

// Provider for the booking card notifier
final driverBookingCardProvider = StateNotifierProvider.autoDispose<
    DriverBookingCardNotifier, DriverBookingCardState>(
  (ref) {
    return DriverBookingCardNotifier(ref);
  },
);
