import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'package:semester_student_ride_app/providers/driver_details_provider.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/providers/booking_flow_provider.dart';
import 'package:semester_student_ride_app/providers/user_bookings_provider.dart';
import 'package:semester_student_ride_app/services/booking_service.dart';
import 'package:semester_student_ride_app/utils/chat_utils.dart';
import 'package:semester_student_ride_app/providers/trip_tracking_provider.dart';
import 'package:semester_student_ride_app/providers/review_provider.dart';
import 'package:semester_student_ride_app/widgets/user_booking_card/widgets/booking_action_buttons.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/booking_details/widgets/booking_detail_trip_section.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/booking_details/widgets/booking_detail_cost_section.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/booking_details/widgets/booking_detail_driver_profile_section.dart';
import 'package:semester_student_ride_app/screens/bottomNavBar/subscreens/user/booking_details/widgets/booking_detail_transportation_section.dart';

class BookingDetailView extends HookConsumerWidget {
  final RequestBookingModel booking;

  const BookingDetailView({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the provided booking or get from arguments or default to first test booking
    // final BookingModel currentBooking = booking ??
    //     (ModalRoute.of(context)?.settings.arguments as BookingModel?) ??
    //     AppConstants.testBookings.first;
    log(booking.status?.value ?? 'no status');
    return ScreenWithTopAppbar(
      title: AppLocalizations.of(context)!.bookingDetails,
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
                  // Driver Profile Section
                  BookingDetailDriverProfileSection(booking: booking),

                  24.verticalSpace,

                  // Transportation Details
                  BookingDetailTransportationSection(booking: booking),

                  24.verticalSpace,

                  // Trip Details
                  BookingDetailTripSection(booking: booking),

                  24.verticalSpace,

                  // Cost Section
                  BookingDetailCostSection(booking: booking),

                  24.verticalSpace,

                  // Payment Method
                  _buildPaymentMethod(booking),

                  // User Rating Section (only show if booking is completed and has ratings)
                  if (booking.status == BookingStatus.completed) ...[
                    24.verticalSpace,
                    _buildUserRatingSection(context, booking),
                  ],

                  32.verticalSpace,

                  // Action Buttons
                  BookingActionButtons(
                      booking: booking, showViewDetails: false),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(RequestBookingModel booking) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: containerbackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Image.asset(_getPaymentIcon('Card'), // Default to card
              height: 30.h),
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
                'Master Card',
                style: montserrat(12, grey5F63, FontWeight.w400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserRatingSection(
      BuildContext context, RequestBookingModel booking) {
    if (booking.id == null) {
      return Container(); // No booking ID, can't fetch review
    }

    return Consumer(
      builder: (context, ref, child) {
        // Get the actual review for this booking
        final reviewAsync = ref.watch(bookingReviewProvider(booking.id!));

        return reviewAsync.when(
          data: (review) {
            if (review == null) {
              // No review found - don't show the rating section at all
              return Container();
            }

            // Show actual review data
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.yourRatingAndReview,
                  style: montserrat(16, grey36, FontWeight.w600),
                ),
                16.verticalSpace,
                Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: containerbackground,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Overall Rating (actual data)
                      _buildRatingRow(
                          context,
                          AppLocalizations.of(context)!.overallRating,
                          review.overallRating),

                      12.verticalSpace,

                      // Driver Communication Rating (actual data)
                      _buildRatingRow(
                          context,
                          AppLocalizations.of(context)!
                              .driverCommunicationRating,
                          review.driverCommunicationRating),

                      12.verticalSpace,

                      // Vehicle Condition Rating (actual data)
                      _buildRatingRow(
                          context,
                          AppLocalizations.of(context)!.vehicleCondition,
                          review.vehicleConditionRating),

                      // User Review text (only show if exists)
                      if (review.reviewText != null &&
                          review.reviewText!.isNotEmpty) ...[
                        16.verticalSpace,
                        Text(
                          AppLocalizations.of(context)!.yourReview,
                          style: montserrat(14, grey36, FontWeight.w600),
                        ),
                        8.verticalSpace,
                        Text(
                          review.reviewText!,
                          style: montserrat(12, grey5F63, FontWeight.w400),
                        ),
                      ],

                      // Review date
                      if (review.createdAt != null) ...[
                        16.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14.sp,
                              color: grey5F63,
                            ),
                            4.horizontalSpace,
                            Text(
                              'Reviewed on ${_formatDate(review.createdAt!)}',
                              style: montserrat(10, grey5F63, FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: containerbackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20.sp,
                  height: 20.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(accentPurple),
                  ),
                ),
                16.horizontalSpace,
                Text(
                  'Loading your review...',
                  style: montserrat(14, grey5F63, FontWeight.w400),
                ),
              ],
            ),
          ),
          error: (error, _) => Container(), // Don't show anything on error
        );
      },
    );
  }

  Widget _buildRatingRow(BuildContext context, String title, double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: montserrat(12, grey5F63, FontWeight.w400),
        ),
        Row(
          children: List.generate(5, (index) {
            return Icon(
              index < rating ? Icons.star : Icons.star_border,
              color: index < rating ? yellowE2A640 : grey5F63,
              size: 16.sp,
            );
          }),
        ),
      ],
    );
  }

  String _formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }

  String _getPaymentIcon(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'card':
      case 'master card':
      case 'visa':
        return AppImages.masterCard;
      case 'cash':
        return AppImages.masterCard;
      case 'digital wallet':
        return AppImages.masterCard;
      default:
        return AppImages.masterCard;
    }
  }
}
