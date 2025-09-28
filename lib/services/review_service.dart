import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/models/review_model.dart';

class ReviewService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _reviewsCollection = 'reviews';
  static const String _reviewsSubcollection = 'reviews';

  // Submit a new review
  static Future<bool> submitReview(ReviewModel review) async {
    try {
      final reviewData = review.copyWith(
        id: _firestore.collection(_reviewsCollection).doc().id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Use a batch to ensure both operations succeed or fail together
      final batch = _firestore.batch();

      // 1. Store review in global reviews collection (for easy querying)
      final globalReviewRef =
          _firestore.collection(_reviewsCollection).doc(reviewData.id);
      batch.set(globalReviewRef, reviewData.toJson());

      // 2. Store review in driver's subcollection
      final driverReviewRef = userCollection
          .doc(review.driverId)
          .collection(_reviewsSubcollection)
          .doc(reviewData.id);
      batch.set(driverReviewRef, reviewData.toJson());

      // 3. Update driver's rating statistics directly in their document
      await _updateDriverRatingStats(review.driverId, reviewData, batch);

      // Execute all operations
      await batch.commit();

      return true;
    } catch (e) {
      print('Error submitting review: $e');
      return false;
    }
  }

  // Update driver's rating statistics directly in their document
  static Future<void> _updateDriverRatingStats(
      String driverId, ReviewModel newReview, WriteBatch batch) async {
    try {
      // Get current driver data
      final driverDoc = await userCollection.doc(driverId).get();

      if (!driverDoc.exists) {
        print('Driver document not found: $driverId');
        return;
      }

      final currentData = driverDoc.data()!;
      final currentTotalReviews = (currentData['totalReviews'] ?? 0) as int;
      final currentAvgRating = (currentData['averageRating'] ?? 0.0) as double;
      final currentAvgCommRating =
          (currentData['averageCommunicationRating'] ?? 0.0) as double;
      final currentAvgVehicleRating =
          (currentData['averageVehicleRating'] ?? 0.0) as double;

      // Calculate new totals
      final newTotalReviews = currentTotalReviews + 1;

      // Calculate new averages using incremental formula
      final newAvgRating =
          ((currentAvgRating * currentTotalReviews) + newReview.overallRating) /
              newTotalReviews;
      final newAvgCommRating = ((currentAvgCommRating * currentTotalReviews) +
              newReview.driverCommunicationRating) /
          newTotalReviews;
      final newAvgVehicleRating =
          ((currentAvgVehicleRating * currentTotalReviews) +
                  newReview.vehicleConditionRating) /
              newTotalReviews;

      // Update driver document with new stats
      final driverRef = userCollection.doc(driverId);
      batch.update(driverRef, {
        'averageRating': newAvgRating,
        'averageCommunicationRating': newAvgCommRating,
        'averageVehicleRating': newAvgVehicleRating,
        'totalReviews': newTotalReviews,
        'lastReviewUpdate': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating driver rating stats: $e');
    }
  }

  // Get reviews for a specific driver from their subcollection (more efficient)
  static Future<List<ReviewModel>> getDriverReviews(String driverId) async {
    try {
      final snapshot = await userCollection
          .doc(driverId)
          .collection(_reviewsSubcollection)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting driver reviews: $e');
      return [];
    }
  }

  // Check if a booking has been reviewed
  static Future<bool> hasBookingBeenReviewed(String bookingId) async {
    try {
      final snapshot = await _firestore
          .collection(_reviewsCollection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if booking has been reviewed: $e');
      return false;
    }
  }

  // Get review for a specific booking
  static Future<ReviewModel?> getBookingReview(String bookingId) async {
    try {
      final snapshot = await _firestore
          .collection(_reviewsCollection)
          .where('bookingId', isEqualTo: bookingId)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return ReviewModel.fromJson(snapshot.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error getting booking review: $e');
      return null;
    }
  }

  // Get driver statistics directly from user document (much faster!)
  static Future<Map<String, dynamic>> getDriverStats(String driverId) async {
    try {
      // First try drivers collection, then users collection
      DocumentSnapshot driverDoc = await userCollection.doc(driverId).get();

      if (!driverDoc.exists) {
        // Fallback to users collection if not found in drivers
        driverDoc = await _firestore.collection('users').doc(driverId).get();
      }

      if (driverDoc.exists) {
        final data = driverDoc.data() as Map<String, dynamic>;
        return {
          'averageRating': data['averageRating'] ?? 0.0,
          'averageCommunicationRating':
              data['averageCommunicationRating'] ?? 0.0,
          'averageVehicleRating': data['averageVehicleRating'] ?? 0.0,
          'totalReviews': data['totalReviews'] ?? 0,
          'totalTrips': data['totalTrips'] ?? 0,
        };
      }

      return {
        'averageRating': 0.0,
        'averageCommunicationRating': 0.0,
        'averageVehicleRating': 0.0,
        'totalReviews': 0,
        'totalTrips': 0,
      };
    } catch (e) {
      print('Error getting driver stats: $e');
      return {
        'averageRating': 0.0,
        'averageCommunicationRating': 0.0,
        'averageVehicleRating': 0.0,
        'totalReviews': 0,
        'totalTrips': 0,
      };
    }
  }
}
