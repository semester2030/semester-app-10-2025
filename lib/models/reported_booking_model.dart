import 'package:freezed_annotation/freezed_annotation.dart';

part 'reported_booking_model.freezed.dart';
part 'reported_booking_model.g.dart';

@freezed
class ReportedBookingModel with _$ReportedBookingModel {
  const factory ReportedBookingModel({
    String? id,
    required String bookingId,
    required String reportedBy, // User ID of the person reporting
    required String reason, // The selected reason for reporting
    String? additionalDetails, // Optional additional details
    required DateTime reportedAt,
    String? status, // 'pending', 'reviewed', 'resolved'
    String? reviewedBy, // Admin/moderator who reviewed the report
    DateTime? reviewedAt,
    String? resolutionNotes,
  }) = _ReportedBookingModel;

  factory ReportedBookingModel.fromJson(Map<String, dynamic> json) =>
      _$ReportedBookingModelFromJson(json);
}
