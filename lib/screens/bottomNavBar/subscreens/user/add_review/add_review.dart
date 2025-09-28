import 'package:semester_student_ride_app/l10n/app_localizations.dart';
import 'package:semester_student_ride_app/semester_student_ride_app_imports.dart';
import 'package:semester_student_ride_app/widgets/screen_with_top_appbar.dart';
import 'package:semester_student_ride_app/widgets/app_dialogs.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/providers/driver_details_provider.dart';
import 'package:semester_student_ride_app/providers/review_provider.dart';
import 'package:semester_student_ride_app/models/review_model.dart';
import 'package:semester_student_ride_app/services/review_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddReview extends HookConsumerWidget {
  final RequestBookingModel? booking;

  const AddReview({super.key, this.booking});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    // State variables for ratings
    final overallRating = useState<double>(3.0);
    final driverCommunicationRating = useState<double>(3.0);
    final vehicleConditionRating = useState<double>(3.0);
    final reviewController = useTextEditingController();

    return ScreenWithTopAppbar(
        title: l10n.addReview,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 180.h),
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 32.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Driver Information Section
                      _buildDriverInfoSection(l10n, ref),

                      24.verticalSpace,

                      // Review Guidelines Section
                      _buildReviewGuidelines(l10n),

                      24.verticalSpace,

                      // Overall Rating Section
                      _buildRatingSection(
                        title: l10n.overallRating,
                        rating: overallRating.value,
                        onRatingChanged: (rating) {
                          overallRating.value = rating;
                        },
                      ),

                      24.verticalSpace,

                      // Driver Communication Rating Section
                      _buildRatingSection(
                        title: l10n.driverCommunicationRating,
                        rating: driverCommunicationRating.value,
                        onRatingChanged: (rating) {
                          driverCommunicationRating.value = rating;
                        },
                      ),

                      24.verticalSpace,

                      // Vehicle Condition Rating Section
                      _buildRatingSection(
                        title: l10n.vehicleCondition,
                        rating: vehicleConditionRating.value,
                        onRatingChanged: (rating) {
                          vehicleConditionRating.value = rating;
                        },
                      ),

                      24.verticalSpace,

                      // Review Text Field
                      _buildReviewTextField(reviewController, l10n),

                      // Add some bottom padding for scrolling
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: NormalCustomButton(
                  label: l10n.submitReview,
                  syncCallback: () async {
                    await _submitReview(
                      context,
                      ref,
                      l10n,
                      overallRating.value,
                      driverCommunicationRating.value,
                      vehicleConditionRating.value,
                      reviewController.text,
                    );
                  }),
            ),
          ],
        ));
  }

  // Helper method to build driver information section
  Widget _buildDriverInfoSection(AppLocalizations l10n, WidgetRef ref) {
    if (booking == null ||
        booking!.driverId == null ||
        booking!.driverId!.isEmpty) {
      // Fallback UI when no booking or driver data is available
      return Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.driverInformation,
              style: montserrat(16, grey36, FontWeight.w600),
            ),
            16.verticalSpace,
            Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundColor: Colors.grey[300],
                  child:
                      Icon(Icons.person, color: Colors.grey[600], size: 30.sp),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Driver Information',
                        style: montserrat(16, grey36, FontWeight.w500),
                      ),
                      4.verticalSpace,
                      Text(
                        'Driver details not available',
                        style: montserrat(12, grey5F63, FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final driverAsyncValue =
        ref.watch(driverDetailsProvider(booking!.driverId!));

    return driverAsyncValue.when(
      data: (driver) {
        if (driver == null) {
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.driverInformation,
                  style: montserrat(16, grey36, FontWeight.w600),
                ),
                16.verticalSpace,
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25.r,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person,
                          color: Colors.grey[600], size: 30.sp),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Driver Not Found',
                            style: montserrat(16, grey36, FontWeight.w500),
                          ),
                          4.verticalSpace,
                          Text(
                            'Driver information unavailable',
                            style: montserrat(12, grey5F63, FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        final statsMap = ref.watch(driverReviewStatsProvider(driver.email));

        return Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.driverInformation,
                style: montserrat(16, grey36, FontWeight.w600),
              ),
              16.verticalSpace,
              Row(
                children: [
                  // Driver profile picture
                  CircularProfileImage(
                    imageUrl: driver.profilePicture ?? '',
                    radius: 25,
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          driver.name,
                          style: montserrat(16, grey36, FontWeight.w500),
                        ),
                        4.verticalSpace,
                        statsMap.when(
                          data: (stats) => Text(
                            l10n.driverRatingFormat(
                                l10n.driver,
                                (stats['averageRating'] as double)
                                    .toStringAsFixed(1),
                                (stats['totalReviews'] as int).toString(),
                                l10n.reviews),
                            style: montserrat(12, grey5F63, FontWeight.w400),
                          ),
                          loading: () => Text(
                            'Loading ratings...',
                            style: montserrat(12, grey5F63, FontWeight.w400),
                          ),
                          error: (_, __) => Text(
                            'Rating unavailable',
                            style: montserrat(12, grey5F63, FontWeight.w400),
                          ),
                        ),
                        4.verticalSpace,
                        Row(
                          children: [
                            Icon(
                              Icons.directions_car,
                              color: Colors.grey[600],
                              size: 16.sp,
                            ),
                            4.horizontalSpace,
                            Text(
                              driver.fullVehicleName,
                              style: montserrat(12, grey5F63, FontWeight.w400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.driverInformation,
              style: montserrat(16, grey36, FontWeight.w600),
            ),
            16.verticalSpace,
            Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundColor: Colors.grey[300],
                  child: SizedBox(
                    width: 30.sp,
                    height: 30.sp,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(accentPurple)),
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Loading driver...',
                        style: montserrat(16, grey36, FontWeight.w500),
                      ),
                      4.verticalSpace,
                      Text(
                        'Fetching driver details...',
                        style: montserrat(12, grey5F63, FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      error: (error, _) => Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.driverInformation,
              style: montserrat(16, grey36, FontWeight.w600),
            ),
            16.verticalSpace,
            Row(
              children: [
                CircleAvatar(
                  radius: 25.r,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.error, color: Colors.white, size: 30.sp),
                ),
                16.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Error loading driver',
                        style: montserrat(16, grey36, FontWeight.w500),
                      ),
                      4.verticalSpace,
                      Text(
                        'Failed to fetch driver details',
                        style: montserrat(12, grey5F63, FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build review guidelines section
  Widget _buildReviewGuidelines(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icon(
            //   Icons.info_outline,
            //   color: whiteColor,
            //   size: 20.sp,
            // ),
            // 8.horizontalSpace,
            Text(
              l10n.reviewGuidelines,
              style: montserrat(14, grey36, FontWeight.w500),
            ),
          ],
        ),
        12.verticalSpace,
        _buildGuidelinePoint(l10n.guidelinePublic),
        8.verticalSpace,
        _buildGuidelinePoint(l10n.guidelineHonest),
        8.verticalSpace,
        _buildGuidelinePoint(l10n.guidelineServiceQuality),
        8.verticalSpace,
        _buildGuidelinePoint(l10n.guidelineRespectful),
      ],
    );
  }

  // Helper method to build individual guideline points
  Widget _buildGuidelinePoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 15.h,
            width: 15.h,
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: accentPurple),
            child: Icon(Icons.check, color: whiteColor, size: 10)),
        12.horizontalSpace,
        Expanded(
          child: Text(
            text,
            style: montserrat(14, grey36, FontWeight.w400),
          ),
        ),
      ],
    );
  }

  // Helper method to build rating sections
  Widget _buildRatingSection({
    required String title,
    required double rating,
    required Function(double) onRatingChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: montserrat(14, grey36, FontWeight.w500),
        ),
        12.verticalSpace,
        Row(
          children: [
            StarRating(
              allowHalfRating: true,
              rating: rating,
              onRatingChanged: onRatingChanged,
              color: Color(0xFFFFBF04),
              emptyIcon: Icons.star,
              size: 30.w,
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: accentPurple,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                rating.toString(),
                style: montserrat(12, whiteColor, FontWeight.w500),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper method to build review text field
  Widget _buildReviewTextField(
      TextEditingController controller, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.addReviewComment,
          style: montserrat(16, Colors.black, FontWeight.w600),
        ),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            // color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            textAlignVertical: TextAlignVertical.top,
            style: montserrat(14, Colors.black, FontWeight.w400),
            decoration: InputDecoration(
              hintText: l10n.reviewPlaceholder,
              hintStyle: montserrat(14, Colors.grey[500], FontWeight.w400),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 18.w,
                vertical: 18.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitReview(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    double overallRating,
    double communicationRating,
    double vehicleRating,
    String reviewText,
  ) async {
    // Validate that we have booking and driver data
    if (booking == null ||
        booking!.driverId == null ||
        booking!.driverId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Unable to submit review: Missing booking or driver information'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must be logged in to submit a review'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Create the review model
      final review = ReviewModel(
        bookingId: booking!.id!,
        driverId: booking!.driverId!,
        passengerId: currentUser.uid,
        overallRating: overallRating,
        driverCommunicationRating: communicationRating,
        vehicleConditionRating: vehicleRating,
        reviewText: reviewText.trim().isEmpty ? null : reviewText.trim(),
      );

      // Use the optimized ReviewService directly
      await ReviewService.submitReview(review);

      // Hide loading
      Navigator.of(context).pop();

      // Show success dialog
      await AppDialogs.showSuccessDialog(
        context,
        title: l10n.reviewSubmitted,
        message: l10n.reviewSubmittedMessage,
        buttonText: l10n.great,
        navigateBack: true,
      );

      // Invalidate relevant providers to refresh the UI
      ref.invalidate(driverDetailsProvider(booking!.driverId!));
      ref.invalidate(bookingReviewProvider(booking!.id!));
      ref.invalidate(bookingReviewStatusProvider(booking!.id!));
    } catch (e) {
      // Hide loading if it's still showing
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting review: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
