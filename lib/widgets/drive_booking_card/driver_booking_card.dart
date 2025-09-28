import 'dart:developer';

import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/providers/user_provider.dart';
import 'package:semester_student_ride_app/providers/driver_booking_card_provider.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_card_content.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_loading_card.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_error_card.dart';

class DriverBookingCard extends ConsumerWidget {
  final RequestBookingModel booking;
  final VoidCallback? onTap;

  const DriverBookingCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // Debug the booking data
    print('DEBUG: DriverBookingCard - Booking ID: ${booking.id}');
    print('DEBUG: DriverBookingCard - User ID: ${booking.userId}');
    print('DEBUG: DriverBookingCard - Service Type: ${booking.serviceType}');
    print(
        'DEBUG: DriverBookingCard - Full booking data: ${booking.toString()}');

    final userId = booking.userId;

    // Handle cases where userId is null or empty
    if (userId == null || userId.isEmpty) {
      log('DEBUG: userId is null or empty');
      return BookingErrorCard(
        booking: booking,
        l10n: l10n,
        errorMessage: "Invalid user data - No user ID",
      );
    }

    // Add timeout for the user fetch to prevent infinite loading
    return ref.watch(userByIdProvider(userId)).when(
      data: (user) {
        log('DEBUG: Loaded user profile: ${user?.name}');
        if (user == null) {
          log('DEBUG: User profile is null for userId: $userId');
          return BookingErrorCard(
            booking: booking,
            l10n: l10n,
            errorMessage: "User not found",
          );
        }
        return BookingCardContent(
          booking: booking,
          userProfile: user,
          l10n: l10n,
          onTap: onTap,
        );
      },
      loading: () {
        log('DEBUG: Loading user profile for userId: $userId');
        return BookingLoadingCard(booking: booking, l10n: l10n);
      },
      error: (error, stack) {
        log('DEBUG: Error loading user profile: $error');
        log('DEBUG: Stack trace: $stack');
        return BookingErrorCard(
          booking: booking,
          l10n: l10n,
          errorMessage: "Error loading user: ${error.toString()}",
        );
      },
    );
  }
}
