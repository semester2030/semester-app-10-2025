import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forget_password_state.freezed.dart';

@freezed
class ForgetPasswordState with _$ForgetPasswordState {
  const factory ForgetPasswordState({
    @Default('') String email,

    // Validation errors
    @Default(null) String? emailError,

    // Loading state
    @Default(false) bool isLoading,
  }) = _ForgetPasswordState;
}
