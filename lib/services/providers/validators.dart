import 'dart:developer';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'validators.g.dart';

@riverpod
class EmailValidityNotifier extends _$EmailValidityNotifier {
  @override
  ValueNotifier<bool> build() {
    return ValueNotifier<bool>(false);
  }

  void validateEmail(String email) {
    state.value = isvalidateEmailInput(email);
  }

  void reset() {
    state.value = false; // Reset the validity state to false
  }
}

bool isValidUrl(String url) {
  try {
    Uri uri = Uri.parse(url);
    return uri.host.isNotEmpty &&
        (uri.scheme == 'http' || uri.scheme == 'https');
  } catch (e) {
    return false;
  }
}

bool isvalidateEmailInput(String email) {
  final RegExp emailRegex =
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
  return emailRegex.hasMatch(email);
}

@riverpod
class PasswordVisibilityNotifier extends _$PasswordVisibilityNotifier {
  @override
  ValueNotifier<bool> build() {
    return ValueNotifier<bool>(true); // Default to password being obscured
  }

  void toggleVisibility() {
    state.value = !state.value;
  }
}
