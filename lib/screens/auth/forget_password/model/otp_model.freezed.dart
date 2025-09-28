// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OTPModel _$OTPModelFromJson(Map<String, dynamic> json) {
  return _OTPModel.fromJson(json);
}

/// @nodoc
mixin _$OTPModel {
  String get email => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OTPModelCopyWith<OTPModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OTPModelCopyWith<$Res> {
  factory $OTPModelCopyWith(OTPModel value, $Res Function(OTPModel) then) =
      _$OTPModelCopyWithImpl<$Res, OTPModel>;
  @useResult
  $Res call({String email, String otp});
}

/// @nodoc
class _$OTPModelCopyWithImpl<$Res, $Val extends OTPModel>
    implements $OTPModelCopyWith<$Res> {
  _$OTPModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? otp = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OTPModelImplCopyWith<$Res>
    implements $OTPModelCopyWith<$Res> {
  factory _$$OTPModelImplCopyWith(
          _$OTPModelImpl value, $Res Function(_$OTPModelImpl) then) =
      __$$OTPModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String otp});
}

/// @nodoc
class __$$OTPModelImplCopyWithImpl<$Res>
    extends _$OTPModelCopyWithImpl<$Res, _$OTPModelImpl>
    implements _$$OTPModelImplCopyWith<$Res> {
  __$$OTPModelImplCopyWithImpl(
      _$OTPModelImpl _value, $Res Function(_$OTPModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? otp = null,
  }) {
    return _then(_$OTPModelImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OTPModelImpl implements _OTPModel {
  _$OTPModelImpl({required this.email, required this.otp});

  factory _$OTPModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OTPModelImplFromJson(json);

  @override
  final String email;
  @override
  final String otp;

  @override
  String toString() {
    return 'OTPModel(email: $email, otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OTPModelImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, email, otp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OTPModelImplCopyWith<_$OTPModelImpl> get copyWith =>
      __$$OTPModelImplCopyWithImpl<_$OTPModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OTPModelImplToJson(
      this,
    );
  }
}

abstract class _OTPModel implements OTPModel {
  factory _OTPModel({required final String email, required final String otp}) =
      _$OTPModelImpl;

  factory _OTPModel.fromJson(Map<String, dynamic> json) =
      _$OTPModelImpl.fromJson;

  @override
  String get email;
  @override
  String get otp;
  @override
  @JsonKey(ignore: true)
  _$$OTPModelImplCopyWith<_$OTPModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
