// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReviewModel _$ReviewModelFromJson(Map<String, dynamic> json) {
  return _ReviewModel.fromJson(json);
}

/// @nodoc
mixin _$ReviewModel {
  String? get id => throw _privateConstructorUsedError;
  String get bookingId => throw _privateConstructorUsedError;
  String get driverId => throw _privateConstructorUsedError;
  String get passengerId => throw _privateConstructorUsedError;
  double get overallRating => throw _privateConstructorUsedError;
  double get driverCommunicationRating => throw _privateConstructorUsedError;
  double get vehicleConditionRating => throw _privateConstructorUsedError;
  String? get reviewText => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReviewModelCopyWith<ReviewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewModelCopyWith<$Res> {
  factory $ReviewModelCopyWith(
          ReviewModel value, $Res Function(ReviewModel) then) =
      _$ReviewModelCopyWithImpl<$Res, ReviewModel>;
  @useResult
  $Res call(
      {String? id,
      String bookingId,
      String driverId,
      String passengerId,
      double overallRating,
      double driverCommunicationRating,
      double vehicleConditionRating,
      String? reviewText,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ReviewModelCopyWithImpl<$Res, $Val extends ReviewModel>
    implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bookingId = null,
    Object? driverId = null,
    Object? passengerId = null,
    Object? overallRating = null,
    Object? driverCommunicationRating = null,
    Object? vehicleConditionRating = null,
    Object? reviewText = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
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
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      passengerId: null == passengerId
          ? _value.passengerId
          : passengerId // ignore: cast_nullable_to_non_nullable
              as String,
      overallRating: null == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as double,
      driverCommunicationRating: null == driverCommunicationRating
          ? _value.driverCommunicationRating
          : driverCommunicationRating // ignore: cast_nullable_to_non_nullable
              as double,
      vehicleConditionRating: null == vehicleConditionRating
          ? _value.vehicleConditionRating
          : vehicleConditionRating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewText: freezed == reviewText
          ? _value.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewModelImplCopyWith<$Res>
    implements $ReviewModelCopyWith<$Res> {
  factory _$$ReviewModelImplCopyWith(
          _$ReviewModelImpl value, $Res Function(_$ReviewModelImpl) then) =
      __$$ReviewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String bookingId,
      String driverId,
      String passengerId,
      double overallRating,
      double driverCommunicationRating,
      double vehicleConditionRating,
      String? reviewText,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$ReviewModelImplCopyWithImpl<$Res>
    extends _$ReviewModelCopyWithImpl<$Res, _$ReviewModelImpl>
    implements _$$ReviewModelImplCopyWith<$Res> {
  __$$ReviewModelImplCopyWithImpl(
      _$ReviewModelImpl _value, $Res Function(_$ReviewModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? bookingId = null,
    Object? driverId = null,
    Object? passengerId = null,
    Object? overallRating = null,
    Object? driverCommunicationRating = null,
    Object? vehicleConditionRating = null,
    Object? reviewText = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ReviewModelImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      bookingId: null == bookingId
          ? _value.bookingId
          : bookingId // ignore: cast_nullable_to_non_nullable
              as String,
      driverId: null == driverId
          ? _value.driverId
          : driverId // ignore: cast_nullable_to_non_nullable
              as String,
      passengerId: null == passengerId
          ? _value.passengerId
          : passengerId // ignore: cast_nullable_to_non_nullable
              as String,
      overallRating: null == overallRating
          ? _value.overallRating
          : overallRating // ignore: cast_nullable_to_non_nullable
              as double,
      driverCommunicationRating: null == driverCommunicationRating
          ? _value.driverCommunicationRating
          : driverCommunicationRating // ignore: cast_nullable_to_non_nullable
              as double,
      vehicleConditionRating: null == vehicleConditionRating
          ? _value.vehicleConditionRating
          : vehicleConditionRating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewText: freezed == reviewText
          ? _value.reviewText
          : reviewText // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewModelImpl implements _ReviewModel {
  const _$ReviewModelImpl(
      {this.id,
      required this.bookingId,
      required this.driverId,
      required this.passengerId,
      required this.overallRating,
      required this.driverCommunicationRating,
      required this.vehicleConditionRating,
      this.reviewText,
      this.createdAt,
      this.updatedAt});

  factory _$ReviewModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewModelImplFromJson(json);

  @override
  final String? id;
  @override
  final String bookingId;
  @override
  final String driverId;
  @override
  final String passengerId;
  @override
  final double overallRating;
  @override
  final double driverCommunicationRating;
  @override
  final double vehicleConditionRating;
  @override
  final String? reviewText;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ReviewModel(id: $id, bookingId: $bookingId, driverId: $driverId, passengerId: $passengerId, overallRating: $overallRating, driverCommunicationRating: $driverCommunicationRating, vehicleConditionRating: $vehicleConditionRating, reviewText: $reviewText, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.bookingId, bookingId) ||
                other.bookingId == bookingId) &&
            (identical(other.driverId, driverId) ||
                other.driverId == driverId) &&
            (identical(other.passengerId, passengerId) ||
                other.passengerId == passengerId) &&
            (identical(other.overallRating, overallRating) ||
                other.overallRating == overallRating) &&
            (identical(other.driverCommunicationRating,
                    driverCommunicationRating) ||
                other.driverCommunicationRating == driverCommunicationRating) &&
            (identical(other.vehicleConditionRating, vehicleConditionRating) ||
                other.vehicleConditionRating == vehicleConditionRating) &&
            (identical(other.reviewText, reviewText) ||
                other.reviewText == reviewText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      bookingId,
      driverId,
      passengerId,
      overallRating,
      driverCommunicationRating,
      vehicleConditionRating,
      reviewText,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      __$$ReviewModelImplCopyWithImpl<_$ReviewModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewModelImplToJson(
      this,
    );
  }
}

abstract class _ReviewModel implements ReviewModel {
  const factory _ReviewModel(
      {final String? id,
      required final String bookingId,
      required final String driverId,
      required final String passengerId,
      required final double overallRating,
      required final double driverCommunicationRating,
      required final double vehicleConditionRating,
      final String? reviewText,
      final DateTime? createdAt,
      final DateTime? updatedAt}) = _$ReviewModelImpl;

  factory _ReviewModel.fromJson(Map<String, dynamic> json) =
      _$ReviewModelImpl.fromJson;

  @override
  String? get id;
  @override
  String get bookingId;
  @override
  String get driverId;
  @override
  String get passengerId;
  @override
  double get overallRating;
  @override
  double get driverCommunicationRating;
  @override
  double get vehicleConditionRating;
  @override
  String? get reviewText;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ReviewModelImplCopyWith<_$ReviewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
