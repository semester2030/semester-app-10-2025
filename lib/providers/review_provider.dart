import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:semester_student_ride_app/models/review_model.dart';
import 'package:semester_student_ride_app/services/review_service.dart';

// Provider for submitting reviews
final reviewSubmissionProvider =
    FutureProvider.family<bool, ReviewModel>((ref, review) async {
  return await ReviewService.submitReview(review);
});

// Provider for getting driver reviews
final driverReviewsProvider =
    FutureProvider.family<List<ReviewModel>, String>((ref, driverId) async {
  return await ReviewService.getDriverReviews(driverId);
});

// Provider for checking if booking has been reviewed
final bookingReviewStatusProvider =
    FutureProvider.family<bool, String>((ref, bookingId) async {
  return await ReviewService.hasBookingBeenReviewed(bookingId);
});

// Provider for getting specific booking review
final bookingReviewProvider =
    FutureProvider.family<ReviewModel?, String>((ref, bookingId) async {
  return await ReviewService.getBookingReview(bookingId);
});

// Provider for driver statistics
final driverReviewStatsProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, driverId) async {
  return await ReviewService.getDriverStats(driverId);
});

// State notifier for review submission
class ReviewSubmissionNotifier extends StateNotifier<AsyncValue<bool>> {
  ReviewSubmissionNotifier() : super(const AsyncValue.data(false));

  Future<void> submitReview(ReviewModel review) async {
    state = const AsyncValue.loading();
    try {
      final success = await ReviewService.submitReview(review);
      state = AsyncValue.data(success);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(false);
  }
}

final reviewSubmissionNotifierProvider =
    StateNotifierProvider<ReviewSubmissionNotifier, AsyncValue<bool>>((ref) {
  return ReviewSubmissionNotifier();
});
