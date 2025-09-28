// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
// int? id,
// @JsonKey(name: 'user_one') String? userone,
// @JsonKey(name: 'user_two') String? usertwo,
// // @JsonKey(fromJson: _MessageFromJson, toJson: _MessageToJson)
// // Message? message,
// String? lastmessage,
// @JsonKey(name: 'unseen_count') int? unseencount,
  int? get id => throw _privateConstructorUsedError;
  String? get useroneName => throw _privateConstructorUsedError;
  String? get usertwoName => throw _privateConstructorUsedError;
  String? get useroneProfilePicUrl => throw _privateConstructorUsedError;
  String? get usertwoProfilePicUrl => throw _privateConstructorUsedError;
  String? get lastmessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
          Conversation value, $Res Function(Conversation) then) =
      _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call(
      {int? id,
      String? useroneName,
      String? usertwoName,
      String? useroneProfilePicUrl,
      String? usertwoProfilePicUrl,
      String? lastmessage});
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? useroneName = freezed,
    Object? usertwoName = freezed,
    Object? useroneProfilePicUrl = freezed,
    Object? usertwoProfilePicUrl = freezed,
    Object? lastmessage = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      useroneName: freezed == useroneName
          ? _value.useroneName
          : useroneName // ignore: cast_nullable_to_non_nullable
              as String?,
      usertwoName: freezed == usertwoName
          ? _value.usertwoName
          : usertwoName // ignore: cast_nullable_to_non_nullable
              as String?,
      useroneProfilePicUrl: freezed == useroneProfilePicUrl
          ? _value.useroneProfilePicUrl
          : useroneProfilePicUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      usertwoProfilePicUrl: freezed == usertwoProfilePicUrl
          ? _value.usertwoProfilePicUrl
          : usertwoProfilePicUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastmessage: freezed == lastmessage
          ? _value.lastmessage
          : lastmessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
          _$ConversationImpl value, $Res Function(_$ConversationImpl) then) =
      __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? useroneName,
      String? usertwoName,
      String? useroneProfilePicUrl,
      String? usertwoProfilePicUrl,
      String? lastmessage});
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
      _$ConversationImpl _value, $Res Function(_$ConversationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? useroneName = freezed,
    Object? usertwoName = freezed,
    Object? useroneProfilePicUrl = freezed,
    Object? usertwoProfilePicUrl = freezed,
    Object? lastmessage = freezed,
  }) {
    return _then(_$ConversationImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      useroneName: freezed == useroneName
          ? _value.useroneName
          : useroneName // ignore: cast_nullable_to_non_nullable
              as String?,
      usertwoName: freezed == usertwoName
          ? _value.usertwoName
          : usertwoName // ignore: cast_nullable_to_non_nullable
              as String?,
      useroneProfilePicUrl: freezed == useroneProfilePicUrl
          ? _value.useroneProfilePicUrl
          : useroneProfilePicUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      usertwoProfilePicUrl: freezed == usertwoProfilePicUrl
          ? _value.usertwoProfilePicUrl
          : usertwoProfilePicUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      lastmessage: freezed == lastmessage
          ? _value.lastmessage
          : lastmessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl implements _Conversation {
  const _$ConversationImpl(
      {this.id,
      this.useroneName,
      this.usertwoName,
      this.useroneProfilePicUrl,
      this.usertwoProfilePicUrl,
      this.lastmessage});

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

// int? id,
// @JsonKey(name: 'user_one') String? userone,
// @JsonKey(name: 'user_two') String? usertwo,
// // @JsonKey(fromJson: _MessageFromJson, toJson: _MessageToJson)
// // Message? message,
// String? lastmessage,
// @JsonKey(name: 'unseen_count') int? unseencount,
  @override
  final int? id;
  @override
  final String? useroneName;
  @override
  final String? usertwoName;
  @override
  final String? useroneProfilePicUrl;
  @override
  final String? usertwoProfilePicUrl;
  @override
  final String? lastmessage;

  @override
  String toString() {
    return 'Conversation(id: $id, useroneName: $useroneName, usertwoName: $usertwoName, useroneProfilePicUrl: $useroneProfilePicUrl, usertwoProfilePicUrl: $usertwoProfilePicUrl, lastmessage: $lastmessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.useroneName, useroneName) ||
                other.useroneName == useroneName) &&
            (identical(other.usertwoName, usertwoName) ||
                other.usertwoName == usertwoName) &&
            (identical(other.useroneProfilePicUrl, useroneProfilePicUrl) ||
                other.useroneProfilePicUrl == useroneProfilePicUrl) &&
            (identical(other.usertwoProfilePicUrl, usertwoProfilePicUrl) ||
                other.usertwoProfilePicUrl == usertwoProfilePicUrl) &&
            (identical(other.lastmessage, lastmessage) ||
                other.lastmessage == lastmessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, useroneName, usertwoName,
      useroneProfilePicUrl, usertwoProfilePicUrl, lastmessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(
      this,
    );
  }
}

abstract class _Conversation implements Conversation {
  const factory _Conversation(
      {final int? id,
      final String? useroneName,
      final String? usertwoName,
      final String? useroneProfilePicUrl,
      final String? usertwoProfilePicUrl,
      final String? lastmessage}) = _$ConversationImpl;

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override // int? id,
// @JsonKey(name: 'user_one') String? userone,
// @JsonKey(name: 'user_two') String? usertwo,
// // @JsonKey(fromJson: _MessageFromJson, toJson: _MessageToJson)
// // Message? message,
// String? lastmessage,
// @JsonKey(name: 'unseen_count') int? unseencount,
  int? get id;
  @override
  String? get useroneName;
  @override
  String? get usertwoName;
  @override
  String? get useroneProfilePicUrl;
  @override
  String? get usertwoProfilePicUrl;
  @override
  String? get lastmessage;
  @override
  @JsonKey(ignore: true)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
