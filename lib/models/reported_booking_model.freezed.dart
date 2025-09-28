// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reported_booking_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReportedBookingModel _$ReportedBookingModelFromJson(Map<String, dynamic> json) {
  return _ReportedBookingModel.fromJson(json);
}

/// @nodoc
mixin _$ReportedBookingModel {
  String? get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get reportedBy =>
      throw _privateConstructorUsedError; // User ID of the person reporting
  String get reason =>
      throw _privateConstructorUsedError; // The selected reason for reporting
  String? get additionalDetails =>
      throw _privateConstructorUsedError; // Optional additional details
  DateTime get reportedAt => throw _privateConstructorUsedError;
  String? get status =>
      throw _privateConstructorUsedError; // 'pending', 'reviewed', 'resolved'
  String? get reviewedBy =>
      throw _privateConstructorUsedError; // Admin/moderator who reviewed the report
  DateTime? get reviewedAt => throw _privateConstructorUsedError;
  String? get resolutionNotes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportedBookingModelCopyWith<ReportedBookingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportedBookingModelCopyWith<$Res> {
  factory $ReportedBookingModelCopyWith(ReportedBookingModel value,
          $Res Function(ReportedBookingModel) then) =
      _$ReportedBookingModelCopyWithImpl<$Res, ReportedBookingModel>;
  @useResult
  $Res call(
      {String? id,
      String bookingId,
      String reportedBy,
      String reason,
      String? additionalDetails,
      DateTime reportedAt,
      String? status,
      String? reviewedBy,
      DateTime? reviewedAt,
      String? resolutionNotes});
}

/// @nodoc
class _$ReportedBookingModelCopyWithImpl<$Res,
        $Val extends ReportedBookingModel>
    implements $ReportedBookingModelCopyWith<$Res> {
  _$ReportedBookingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bookingId = null,
    Object? reportedBy = null,
    Object? reason = null,
    Object? additionalDetails = freezed,
    Object? reportedAt = null,
    Object? status = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? resolutionNotes = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      reportedBy: null == reportedBy
          ? _value.reportedBy
          : reportedBy // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      additionalDetails: freezed == additionalDetails
          ? _value.additionalDetails
          : additionalDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      reportedAt: null == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolutionNotes: freezed == resolutionNotes
          ? _value.resolutionNotes
          : resolutionNotes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportedBookingModelImplCopyWith<$Res>
    implements $ReportedBookingModelCopyWith<$Res> {
  factory _$$ReportedBookingModelImplCopyWith(_$ReportedBookingModelImpl value,
          $Res Function(_$ReportedBookingModelImpl) then) =
      __$$ReportedBookingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String bookingId,
      String reportedBy,
      String reason,
      String? additionalDetails,
      DateTime reportedAt,
      String? status,
      String? reviewedBy,
      DateTime? reviewedAt,
      String? resolutionNotes});
}

/// @nodoc
class __$$ReportedBookingModelImplCopyWithImpl<$Res>
    extends _$ReportedBookingModelCopyWithImpl<$Res, _$ReportedBookingModelImpl>
    implements _$$ReportedBookingModelImplCopyWith<$Res> {
  __$$ReportedBookingModelImplCopyWithImpl(_$ReportedBookingModelImpl _value,
      $Res Function(_$ReportedBookingModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bookingId = null,
    Object? reportedBy = null,
    Object? reason = null,
    Object? additionalDetails = freezed,
    Object? reportedAt = null,
    Object? status = freezed,
    Object? reviewedBy = freezed,
    Object? reviewedAt = freezed,
    Object? resolutionNotes = freezed,
  }) {
    return _then(_$ReportedBookingModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      reportedBy: null == reportedBy
          ? _value.reportedBy
          : reportedBy // ignore: cast_nullable_to_non_nullable
              as String,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      additionalDetails: freezed == additionalDetails
          ? _value.additionalDetails
          : additionalDetails // ignore: cast_nullable_to_non_nullable
              as String?,
      reportedAt: null == reportedAt
          ? _value.reportedAt
          : reportedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedBy: freezed == reviewedBy
          ? _value.reviewedBy
          : reviewedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      reviewedAt: freezed == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      resolutionNotes: freezed == resolutionNotes
          ? _value.resolutionNotes
          : resolutionNotes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportedBookingModelImpl implements _ReportedBookingModel {
  const _$ReportedBookingModelImpl(
      {this.id,
      required this.bookingId,
      required this.reportedBy,
      required this.reason,
      this.additionalDetails,
      required this.reportedAt,
      this.status,
      this.reviewedBy,
      this.reviewedAt,
      this.resolutionNotes});

  factory _$ReportedBookingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportedBookingModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String bookingId;
  @override
  final String reportedBy;
// User ID of the person reporting
  @override
  final String reason;
// The selected reason for reporting
  @override
  final String? additionalDetails;
// Optional additional details
  @override
  final DateTime reportedAt;
  @override
  final String? status;
// 'pending', 'reviewed', 'resolved'
  @override
  final String? reviewedBy;
// Admin/moderator who reviewed the report
  @override
  final DateTime? reviewedAt;
  @override
  final String? resolutionNotes;

  @override
  String toString() {
    return 'ReportedBookingModel(id: $id, bookingId: $bookingId, reportedBy: $reportedBy, reason: $reason, additionalDetails: $additionalDetails, reportedAt: $reportedAt, status: $status, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, resolutionNotes: $resolutionNotes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportedBookingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.reportedBy, reportedBy) ||
                other.reportedBy == reportedBy) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.additionalDetails, additionalDetails) ||
                other.additionalDetails == additionalDetails) &&
            (identical(other.reportedAt, reportedAt) ||
                other.reportedAt == reportedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reviewedBy, reviewedBy) ||
                other.reviewedBy == reviewedBy) &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.resolutionNotes, resolutionNotes) ||
                other.resolutionNotes == resolutionNotes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookingId,
      reportedBy,
      reason,
      additionalDetails,
      reportedAt,
      status,
      reviewedBy,
      reviewedAt,
      resolutionNotes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportedBookingModelImplCopyWith<_$ReportedBookingModelImpl>
      get copyWith =>
          __$$ReportedBookingModelImplCopyWithImpl<_$ReportedBookingModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportedBookingModelImplToJson(
      this,
    );
  }
}

abstract class _ReportedBookingModel implements ReportedBookingModel {
  const factory _ReportedBookingModel(
      {final String? id,
      required final String bookingId,
      required final String reportedBy,
      required final String reason,
      final String? additionalDetails,
      required final DateTime reportedAt,
      final String? status,
      final String? reviewedBy,
      final DateTime? reviewedAt,
      final String? resolutionNotes}) = _$ReportedBookingModelImpl;

  factory _ReportedBookingModel.fromJson(Map<String, dynamic> json) =
      _$ReportedBookingModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get bookingId;
  @override
  String get reportedBy;
  @override // User ID of the person reporting
  String get reason;
  @override // The selected reason for reporting
  String? get additionalDetails;
  @override // Optional additional details
  DateTime get reportedAt;
  @override
  String? get status;
  @override // 'pending', 'reviewed', 'resolved'
  String? get reviewedBy;
  @override // Admin/moderator who reviewed the report
  DateTime? get reviewedAt;
  @override
  String? get resolutionNotes;
  @override
  @JsonKey(ignore: true)
  _$$ReportedBookingModelImplCopyWith<_$ReportedBookingModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
