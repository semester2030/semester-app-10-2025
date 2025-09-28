import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/screens/auth/forget_password/provider/forget_password_state.dart';
import 'package:semester_student_ride_app/services/providers/validators.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forget_password_provider.g.dart';

// ForgetPasswordNotifier using Riverpod annotation
@riverpod
class ForgetPasswordNotifier extends _$ForgetPasswordNotifier {
  @override
  ForgetPasswordState build() {
    return ForgetPasswordState();
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value, emailError: null);
  }

  // Validation methods
  bool validateEmail() {
    bool isValid = true;

    if (state.email.isEmpty) {
      state = state.copyWith(emailError: "Please enter your email address.");
      isValid = false;
    } else if (!isvalidateEmailInput(state.email)) {
      state = state.copyWith(emailError: "Please enter a valid email address.");
      isValid = false;
    }

    return isValid;
  }

  // Send password reset email
  Future<bool> sendPasswordResetEmail(BuildContext context) async {
    if (!validateEmail()) {
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: state.email.trim());
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email address.";
          break;
        case 'invalid-email':
          errorMessage = "Please enter a valid email address.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many requests. Please try again later.";
          break;
        default:
          errorMessage = "An error occurred. Please try again.";
      }

      state = state.copyWith(
        emailError: errorMessage,
        isLoading: false,
      );
      return false;
    } catch (e) {
      log('Error sending password reset email: $e');
      state = state.copyWith(
        emailError: "An unexpected error occurred. Please try again.",
        isLoading: false,
      );
      return false;
    }
  }

  void reset() {
    state = ForgetPasswordState();
  }
}
