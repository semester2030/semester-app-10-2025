import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/models/reported_booking_model.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';

class ReportService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference for reported bookings
  final CollectionReference _reportedBookingsCollection =
      FirebaseFirestore.instance.collection('reported_bookings');

  /// Submit a report for a booking
  Future<bool> reportBooking({
    required RequestBookingModel booking,
    required String reason,
    String? additionalDetails,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        log('Error: No authenticated user found for reporting booking');
        return false;
      }

      if (booking.id == null) {
        log('Error: Booking ID is null');
        return false;
      }

      // Create the report
      final reportId = _reportedBookingsCollection.doc().id;
      final report = ReportedBookingModel(
        id: reportId,
        bookingId: booking.id!,
        reportedBy: user.uid,
        reason: reason,
        additionalDetails: additionalDetails,
        reportedAt: DateTime.now(),
        status: 'pending',
      );

      // Save the report to Firestore
      await _reportedBookingsCollection.doc(reportId).set(report.toJson());

      log('Booking ${booking.id} reported successfully by user ${user.uid}');
      return true;
    } catch (e) {
      log('Error reporting booking: $e');
      return false;
    }
  }

  /// Get reports for a specific booking
  Future<List<ReportedBookingModel>> getReportsForBooking(
      String bookingId) async {
    try {
      final querySnapshot = await _reportedBookingsCollection
          .where('bookingId', isEqualTo: bookingId)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              ReportedBookingModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error fetching reports for booking: $e');
      return [];
    }
  }

  /// Get all reports by a user
  Future<List<ReportedBookingModel>> getReportsByUser(String userId) async {
    try {
      final querySnapshot = await _reportedBookingsCollection
          .where('reportedBy', isEqualTo: userId)
          .orderBy('reportedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              ReportedBookingModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error fetching reports by user: $e');
      return [];
    }
  }

  /// Get all pending reports (for admin use)
  Future<List<ReportedBookingModel>> getPendingReports() async {
    try {
      final querySnapshot = await _reportedBookingsCollection
          .where('status', isEqualTo: 'pending')
          .orderBy('reportedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) =>
              ReportedBookingModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      log('Error fetching pending reports: $e');
      return [];
    }
  }

  /// Update report status (for admin use)
  Future<bool> updateReportStatus({
    required String reportId,
    required String status,
    String? reviewedBy,
    String? resolutionNotes,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
        'reviewedAt': DateTime.now(),
      };

      if (reviewedBy != null) {
        updateData['reviewedBy'] = reviewedBy;
      }

      if (resolutionNotes != null) {
        updateData['resolutionNotes'] = resolutionNotes;
      }

      await _reportedBookingsCollection.doc(reportId).update(updateData);

      log('Report $reportId status updated to $status');
      return true;
    } catch (e) {
      log('Error updating report status: $e');
      return false;
    }
  }
}
