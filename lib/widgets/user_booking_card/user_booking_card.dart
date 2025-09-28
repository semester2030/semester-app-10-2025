import 'package:semester_student_ride_app/providers/user_bookings_provider.dart';
import 'package:semester_student_ride_app/providers/booking_flow_provider.dart';
import 'package:semester_student_ride_app/providers/trip_tracking_provider.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/providers/driver_details_provider.dart';
import 'package:semester_student_ride_app/providers/review_provider.dart';
import 'package:semester_student_ride_app/services/booking_service.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/driver_tracking/live_driver_tracking_screen.dart';
import 'package:semester_student_ride_app/utils/chat_utils.dart';
import 'package:semester_student_ride_app/widgets/user_booking_card/widgets/booking_action_buttons.dart';
import 'package:semester_student_ride_app/widgets/user_booking_card/widgets/booking_driver_profile_section.dart';
import 'package:semester_student_ride_app/widgets/user_booking_card/widgets/booking_location_row.dart';
import 'package:semester_student_ride_app/utils/booking_status_utilities.dart';

class UserBookingCard extends HookConsumerWidget {
  final RequestBookingModel booking;
  final VoidCallback? onTap;

  const UserBookingCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap:
          onTap ?? () => context.push('/booking_details_view', extra: booking),
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  BookingStatusUtilities.formatDate(booking.createdAt),
                  style: montserrat(12, grey36, FontWeight.w400),
                ),
                BookingStatusChip(booking: booking),
              ],
            ),
            Divider(thickness: 1),
            10.verticalSpace,

            // Driver Profile Section
            BookingDriverProfileSection(booking: booking),

            16.verticalSpace,
            Divider(),
            12.verticalSpace,

            // Location details
            BookingLocationRow(booking: booking),

            16.verticalSpace,

            // Action buttons based on status
            BookingActionButtons(booking: booking),
          ],
        ),
      ),
    );
  }
}
