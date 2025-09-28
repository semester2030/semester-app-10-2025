import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/booking_status.dart';
import 'package:semester_student_ride_app/providers/booking_actions_provider.dart';
import 'package:semester_student_ride_app/providers/review_provider.dart';
import 'package:semester_student_ride_app/config/app_colors.dart';
import 'package:semester_student_ride_app/utils/text_styles.dart';
import 'package:semester_student_ride_app/widgets/button.dart';
import 'package:semester_student_ride_app/utils/extensions.dart';
import 'package:go_router/go_router.dart';

class BookingActionButtons extends ConsumerWidget {
  final RequestBookingModel booking;
  final bool showViewDetails;

  const BookingActionButtons({
    super.key,
    required this.booking,
    this.showViewDetails = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = booking.status ?? BookingStatus.draft;

    switch (status) {
      case BookingStatus.draft:
        return _buildDraftButtons(context, ref);
      case BookingStatus.pending:
        return _buildPendingButtons(context, ref);
      case BookingStatus.active:
        return _buildActiveButtons(context, ref);
      case BookingStatus.driverComing:
        return _buildDriverComingButtons(context, ref);
      case BookingStatus.tripStarted:
        return _buildTripStartedButtons(context, ref);
      case BookingStatus.completed:
        return _buildCompletedButtons(context, ref);
      case BookingStatus.cancelled:
        return _buildCancelledButtons(context, ref);
    }
  }

  Widget _buildDraftButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => BookingActions.editBooking(context, ref, booking),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              'Continue Booking',
              style: montserrat(14, Colors.white, FontWeight.w500),
            ),
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: OutlinedButton(
            onPressed: () => BookingActions.cancelBooking(context, booking),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              backgroundColor: containerbackground,
              side: BorderSide(color: containerbackground),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              'Delete Draft',
              style: montserrat(14, grey5F63, FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => BookingActions.editBooking(context, ref, booking),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              'Edit or Update',
              style: montserrat(14, Colors.white, FontWeight.w500),
            ),
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: OutlinedButton(
            onPressed: () => BookingActions.cancelBooking(context, booking),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              backgroundColor: containerbackground,
              side: BorderSide(color: containerbackground),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              'Cancel Booking',
              style: montserrat(14, grey5F63, FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () =>
                BookingActions.contactDriver(context, ref, booking),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
            ),
            child: Text(
              'Contact Driver',
              style: montserrat(14, Colors.white, FontWeight.w500),
            ),
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: OutlinedButton(
            onPressed: () => BookingActions.cancelBooking(context, booking),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              backgroundColor: containerbackground,
              side: BorderSide(color: containerbackground),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
            child: Text(
              'Cancel Booking',
              style: montserrat(14, grey5F63, FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverComingButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: NormalCustomButton(
            height: 40,
            label: 'Track Driver',
            titleStyle: montserrat(14, whiteColor, FontWeight.w500),
            buttonColor: Colors.blue,
            syncCallback: () async {
              // Navigate to driver tracking screen
              context.push('/live_driver_tracking', extra: booking);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTripStartedButtons(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: NormalCustomButton(
            height: 40,
            label: 'Track Ride',
            titleStyle: montserrat(14, whiteColor, FontWeight.w500),
            buttonColor: Colors.green,
            syncCallback: () async {
              // Navigate to ride tracking screen
              context.push('/live_driver_tracking', extra: booking);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedButtons(BuildContext context, WidgetRef ref) {
    final hasReview = ref.watch(bookingReviewStatusProvider(booking.id!));

    return hasReview.when(
      data: (isReviewed) => Row(
        children: [
          if (!isReviewed)
            Expanded(
              child: OutlinedButton(
                onPressed: () => isReviewed
                    ? BookingActions.viewReview(context, ref, booking)
                    : BookingActions.rateBooking(context, booking),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: accentPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  isReviewed ? 'View Review' : 'Rate',
                  style: montserrat(14, accentPurple, FontWeight.w500),
                ),
              ),
            ),
          if (!isReviewed && showViewDetails) 16.horizontalSpace,
          if (showViewDetails)
            Expanded(
              child: ElevatedButton(
                onPressed: () => BookingActions.viewDetails(context, booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'View Details',
                  style: montserrat(14, Colors.white, FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
      loading: () => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => BookingActions.rateBooking(context, booking),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: accentPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'Rate',
                style: montserrat(14, accentPurple, FontWeight.w500),
              ),
            ),
          ),
          if (showViewDetails) 16.horizontalSpace,
          if (showViewDetails)
            Expanded(
              child: ElevatedButton(
                onPressed: () => BookingActions.viewDetails(context, booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'View Details',
                  style: montserrat(14, Colors.white, FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
      error: (_, __) => Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => BookingActions.rateBooking(context, booking),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: accentPurple),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                'Rate',
                style: montserrat(14, accentPurple, FontWeight.w500),
              ),
            ),
          ),
          if (showViewDetails) 16.horizontalSpace,
          if (showViewDetails)
            Expanded(
              child: ElevatedButton(
                onPressed: () => BookingActions.viewDetails(context, booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'View Details',
                  style: montserrat(14, Colors.white, FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCancelledButtons(BuildContext context, WidgetRef ref) {
    if (!showViewDetails) {
      return Container(); // Don't show any button if View Details is disabled
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => BookingActions.viewDetails(context, booking),
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        child: Text(
          'View Details',
          style: montserrat(14, Colors.white, FontWeight.w500),
        ),
      ),
    );
  }
}
