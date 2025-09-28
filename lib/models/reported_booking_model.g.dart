// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reported_booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportedBookingModelImpl _$$ReportedBookingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ReportedBookingModelImpl(
      id: json['id'] as String?,
      bookingId: json['bookingId'] as String,
      reportedBy: json['reportedBy'] as String,
      reason: json['reason'] as String,
      additionalDetails: json['additionalDetails'] as String?,
      reportedAt: DateTime.parse(json['reportedAt'] as String),
      status: json['status'] as String?,
      reviewedBy: json['reviewedBy'] as String?,
      reviewedAt: json['reviewedAt'] == null
          ? null
          : DateTime.parse(json['reviewedAt'] as String),
      resolutionNotes: json['resolutionNotes'] as String?,
    );

Map<String, dynamic> _$$ReportedBookingModelImplToJson(
        _$ReportedBookingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bookingId': instance.bookingId,
      'reportedBy': instance.reportedBy,
      'reason': instance.reason,
      'additionalDetails': instance.additionalDetails,
      'reportedAt': instance.reportedAt.toIso8601String(),
      'status': instance.status,
      'reviewedBy': instance.reviewedBy,
      'reviewedAt': instance.reviewedAt?.toIso8601String(),
      'resolutionNotes': instance.resolutionNotes,
    };
