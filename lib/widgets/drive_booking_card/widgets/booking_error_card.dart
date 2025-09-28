import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/providers/user_provider.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_card_header.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_location_row.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_trip_details_section.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_user_profile_section.dart';

class BookingErrorCard extends ConsumerWidget {
  final RequestBookingModel booking;
  final AppLocalizations l10n;
  final String errorMessage;

  const BookingErrorCard({
    super.key,
    required this.booking,
    required this.l10n,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top row with date and status
          BookingCardHeader(booking: booking, l10n: l10n),
          Divider(thickness: 1),
          6.verticalSpace,
          
          // Profile and details row with error state
          BookingUserProfileSection(
            booking: booking,
            userProfile: null,
            l10n: l10n,
            isError: true,
          ),
          7.verticalSpace,
          Divider(),
          8.verticalSpace,
          
          // Location row
          BookingLocationRow(booking: booking),
          10.verticalSpace,
          Divider(),
          12.verticalSpace,
          
          // Trip details
          BookingTripDetailsSection(booking: booking, l10n: l10n),
          20.verticalSpace,
          
          // Show error message and retry button instead of action buttons
          Column(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 24.sp,
              ),
              8.verticalSpace,
              Text(
                errorMessage,
                style: montserrat(12, Colors.red, FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              8.verticalSpace,
              ElevatedButton(
                onPressed: () {
                  // Refresh the provider to retry loading user data
                  if (booking.userId != null && booking.userId!.isNotEmpty) {
                    ref.invalidate(userByIdProvider(booking.userId!));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentPurple,
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
                child: Text(
                  'Retry',
                  style: montserrat(12, Colors.white, FontWeight.w500),
                ),
              ),
              8.verticalSpace,
              // Add a fallback button to show basic card
              TextButton(
                onPressed: () {
                  // Show card with limited functionality (no user profile)
                  context.push('/booking_details_view', extra: booking);
                },
                child: Text(
                  'View Details Anyway',
                  style: montserrat(11, grey36, FontWeight.w400),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
