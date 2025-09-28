import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_card_header.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_location_row.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_trip_details_section.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_user_profile_section.dart';

class BookingLoadingCard extends StatelessWidget {
  final RequestBookingModel booking;
  final AppLocalizations l10n;

  const BookingLoadingCard({
    super.key,
    required this.booking,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
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
          
          // Profile and details row with loading state
          BookingUserProfileSection(
            booking: booking,
            userProfile: null,
            l10n: l10n,
            isLoading: true,
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
          
          // Show loading indicator and timeout message
          Column(
            children: [
              CircularProgressIndicator(color: accentPurple),
              8.verticalSpace,
              Text(
                'Loading user information...',
                style: montserrat(12, grey36, FontWeight.w400),
              ),
              4.verticalSpace,
              Text(
                'If this takes too long, check your internet connection',
                style: montserrat(10, Colors.orange, FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
