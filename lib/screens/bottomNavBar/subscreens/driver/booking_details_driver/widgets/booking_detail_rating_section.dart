import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/models/review_model.dart';
import 'package:semester_student_ride_app/providers/review_provider.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';

class BookingDetailRatingSection extends ConsumerWidget {
  final RequestBookingModel booking;

  const BookingDetailRatingSection({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    if (booking.id == null) {
      return Container(); // No booking ID, can't fetch review
    }

    // Get the actual review for this booking
    final reviewAsync = ref.watch(bookingReviewProvider(booking.id!));

    return reviewAsync.when(
      data: (review) {
        if (review == null) {
          // No review found - show waiting for rating message
          if (_shouldShowRatingPrompt()) {
            return _buildWaitingForRatingWidget(l10n);
          }
          return Container(); // Don't show anything if not applicable
        }

        // Show actual review data
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rating,
              style: montserrat(16, colorPrimary, FontWeight.w600),
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
                  // Overall Rating
                  _buildRatingRow(
                    context,
                    l10n.overallRating,
                    review.overallRating,
                  ),

                  12.verticalSpace,

                  // Driver Communication Rating
                  _buildRatingRow(
                    context,
                    l10n.driverCommunicationRating,
                    review.driverCommunicationRating,
                  ),

                  12.verticalSpace,

                  // Vehicle Condition Rating
                  _buildRatingRow(
                    context,
                    l10n.vehicleCondition,
                    review.vehicleConditionRating,
                  ),

                  // Review text (only show if exists)
                  if (review.reviewText != null &&
                      review.reviewText!.isNotEmpty) ...[
                    16.verticalSpace,
                    Text(
                      'Customer Review',
                      style: montserrat(14, grey36, FontWeight.w600),
                    ),
                    8.verticalSpace,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: borderGrey,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        review.reviewText!,
                        style: montserrat(12, grey5F63, FontWeight.w400),
                      ),
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
              'Loading review...',
              style: montserrat(14, grey5F63, FontWeight.w400),
            ),
          ],
        ),
      ),
      error: (error, _) => Container(), // Don't show anything on error
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
          children: [
            ...List.generate(5, (index) {
              return Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: index < rating ? yellowE2A640 : grey5F63,
                size: 16.sp,
              );
            }),
            8.horizontalSpace,
            Text(
              rating.toStringAsFixed(1),
              style: montserrat(12, grey36, FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWaitingForRatingWidget(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.rating,
          style: montserrat(16, colorPrimary, FontWeight.w600),
        ),
        16.verticalSpace,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: lightPurple,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: colorPrimary,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.star_outline,
                size: 32,
                color: colorPrimary,
              ),
              8.verticalSpace,
              Text(
                'Waiting for customer rating',
                style: montserrat(14, colorPrimary, FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              4.verticalSpace,
              Text(
                'The customer will be able to rate this trip after completion',
                style: montserrat(12, grey5F63, FontWeight.w400),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _shouldShowRatingPrompt() {
    // Show rating prompt if the trip is completed but not rated
    return booking.status?.toString() == 'completed';
  }

  String _formatDate(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.year}";
  }
}
