import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/providers/booking_flow_provider.dart';
import 'package:semester_student_ride_app/providers/driver_details_provider.dart';
import 'package:semester_student_ride_app/providers/review_provider.dart';
import 'package:semester_student_ride_app/utils/chat_utils.dart';

class BookingActions {
  /// Cancel booking functionality
  static Future<void> cancelBooking(
      BuildContext context, RequestBookingModel booking) async {
    // Navigate to cancel ride screen with booking data
    context.push('/cancel_ride', extra: booking);
  }

  /// View booking details functionality
  static void viewDetails(BuildContext context, RequestBookingModel booking) {
    // Navigate to booking details view
    context.push('/booking_details_view', extra: booking);
  }

  /// Edit booking functionality
  static void editBooking(
      BuildContext context, WidgetRef ref, RequestBookingModel booking) {
    // Initialize the booking flow provider with existing booking data
    final bookingNotifier = ref.read(bookingFlowProvider.notifier);
    bookingNotifier.initializeFromExistingBooking(booking);

    // Navigate to the first step of the booking flow
    context.push('/booking_map', extra: booking.serviceType);
  }

  /// Rate booking functionality
  static void rateBooking(BuildContext context, RequestBookingModel booking) {
    // Navigate to add review screen with booking data
    context.push('/add_review', extra: booking);
  }

  /// View existing review functionality
  static Future<void> viewReview(
      BuildContext context, WidgetRef ref, RequestBookingModel booking) async {
    // Get the existing review for this booking
    final reviewAsync = ref.read(bookingReviewProvider(booking.id!));

    reviewAsync.when(
      data: (review) {
        if (review != null) {
          // Show review details in a dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Your Review'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Overall Rating: ${review.overallRating}/5'),
                  Text('Communication: ${review.driverCommunicationRating}/5'),
                  Text('Vehicle Condition: ${review.vehicleConditionRating}/5'),
                  if (review.reviewText != null) ...[
                    SizedBox(height: 10),
                    Text('Comment:'),
                    Text(review.reviewText!),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ],
            ),
          );
        } else {
          // No review found, redirect to rating
          rateBooking(context, booking);
        }
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Loading review...')),
        );
      },
      error: (error, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading review'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  /// Contact driver functionality
  static Future<void> contactDriver(
      BuildContext context, WidgetRef ref, RequestBookingModel booking) async {
    final driverId = booking.driverId;

    if (driverId == null || driverId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No driver assigned to this booking'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Get driver details using the provider
      final driverAsyncValue = ref.read(driverDetailsProvider(driverId));

      driverAsyncValue.when(
        data: (driver) {
          if (driver != null) {
            ChatUtils.startChat(
              context: context,
              otherUser: driver,
              ref: ref,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Driver not found'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        loading: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Loading driver details...'),
              backgroundColor: Colors.orange,
            ),
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading driver details'),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to contact driver: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
