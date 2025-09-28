import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_card_header.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_location_row.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_trip_details_section.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_user_profile_section.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_action_buttons.dart';

class BookingCardContent extends ConsumerWidget {
  final RequestBookingModel booking;
  final UserSignupModel? userProfile;
  final AppLocalizations l10n;
  final VoidCallback? onTap;

  const BookingCardContent({
    super.key,
    required this.booking,
    required this.userProfile,
    required this.l10n,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap ?? () => context.push('/booking_details_view', extra: booking),
      child: Container(
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
            
            // Profile and details row
            BookingUserProfileSection(
              booking: booking,
              userProfile: userProfile,
              l10n: l10n,
            ),
            7.verticalSpace,
            Divider(),
            8.verticalSpace,
            
            // Location details with custom aligned icons
            BookingLocationRow(booking: booking),
            10.verticalSpace,
            Divider(),
            
            // Trip details section
            12.verticalSpace,
            BookingTripDetailsSection(booking: booking, l10n: l10n),
            20.verticalSpace,
            
            // Action buttons
            BookingActionButtons(
              booking: booking,
              userProfile: userProfile,
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }
}
