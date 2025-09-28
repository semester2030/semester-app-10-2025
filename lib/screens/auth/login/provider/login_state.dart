import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default('') String email,
    @Default('') String password,

    // Validation errors
    @Default(null) String? emailError,
    @Default(null) String? passwordError,

    // Loading state
    @Default(false) bool isLoading,
  }) = _LoginState;
}
