import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';

// Import the new widget components
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/booking_details_driver/widgets/booking_detail_user_profile_section.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/booking_details_driver/widgets/booking_detail_transportation_section.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/booking_details_driver/widgets/booking_detail_trip_details_section.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/booking_details_driver/widgets/booking_detail_cost_section.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/driver/booking_details_driver/widgets/booking_detail_rating_section.dart';
import 'package:semester_student_ride_app/widgets/drive_booking_card/widgets/booking_action_buttons.dart';

class BookingDetailDriverView extends HookConsumerWidget {
  final RequestBookingModel booking;

  const BookingDetailDriverView({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    log(booking.status?.value ?? 'no status');
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
                  // User Profile Section
                  BookingDetailUserProfileSection(booking: booking),

                  24.verticalSpace,

                  // Transportation Details
                  BookingDetailTransportationSection(booking: booking),

                  24.verticalSpace,

                  // Trip Details
                  BookingDetailTripDetailsSection(booking: booking),

                  24.verticalSpace,

                  // Cost Section
                  BookingDetailCostSection(booking: booking),

                  // User Rating Section (only show if booking is completed)
                  if (booking.status == BookingStatus.completed) ...[
                    24.verticalSpace,
                    BookingDetailRatingSection(booking: booking),
                  ],

                  32.verticalSpace,

                  // Action Buttons - create a wrapper for the existing action buttons
                  _buildActionButtonsWrapper(context, ref, booking),

                  if (booking.status == BookingStatus.pending)
                    Center(
                        child: Padding(
                      padding: EdgeInsets.only(top: 30.h),
                      child: GestureDetector(
                        onTap: () =>
                            context.push('/flag_inappropriate', extra: booking),
                        child: Text(l10n.flagAsInappropriate,
                            style: montserrat(
                                14, Color(0xFFFA6E3B), FontWeight.w400)),
                      ),
                    )),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  // Simple wrapper for action buttons
  Widget _buildActionButtonsWrapper(
      BuildContext context, WidgetRef ref, RequestBookingModel booking) {
    final l10n = AppLocalizations.of(context)!;

    // Since we need a userProfile for BookingActionButtons,
    // we'll use a FutureBuilder to fetch it or create a simpler version
    return FutureBuilder<UserSignupModel?>(
      future: _getUserById(booking.userId ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return BookingActionButtons(
          booking: booking,
          userProfile: snapshot.data,
          l10n: l10n,
        );
      },
    );
  }

  // Helper method to fetch user details by ID
  Future<UserSignupModel?> _getUserById(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        return UserSignupModel.fromJson(userDoc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      log('Error fetching user by ID: $e');
      return null;
    }
  }
}
