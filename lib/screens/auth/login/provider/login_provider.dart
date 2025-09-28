import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semester_student_ride_app/config/app_validator.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/screens/auth/login/provider/login_state.dart';
import 'package:semester_student_ride_app/services/providers/validators.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

// LoginNotifier using Riverpod annotation
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() {
    return LoginState();
  }

  void updateEmail(String value) {
    state = state.copyWith(email: value, emailError: null);
  }

  void updatePassword(String value) {
    state = state.copyWith(password: value, passwordError: null);
  }

  // Validation methods
  bool validateLoginScreen() {
    bool isValid = true;

    if (state.email.isEmpty) {
      state = state.copyWith(emailError: "Email is required.");
      isValid = false;
    } else if (!isvalidateEmailInput(state.email)) {
      state = state.copyWith(emailError: "Please enter a valid email.");
      isValid = false;
    }

    if (state.password.isEmpty) {
      state = state.copyWith(passwordError: "Password is required.");
      isValid = false;
    }

    return isValid;
  }

  // Login method using Firebase Authentication
  Future<bool> login(BuildContext context) async {
    if (!validateLoginScreen()) {
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      // Sign in with Firebase Auth
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        // Get user data from Firestore to check verification status
        final userDoc = await userCollection.doc(user.uid).get();

        if (userDoc.exists) {
          final userData = userDoc.data()!;
          final bool isBlocked = userData['isBlocked'] ?? false;

          // Check if user is blocked
          if (isBlocked) {
            await FirebaseAuth.instance.signOut();
            state = state.copyWith(
              emailError:
                  "Your account has been blocked. Please contact support.",
              isLoading: false,
            );
            return false;
          }

          // For now, we'll allow login even if phone/ID not verified
          // and let the auth state handler manage the flow
          state = state.copyWith(isLoading: false);
          return true;
        } else {
          // User document doesn't exist
          await FirebaseAuth.instance.signOut();
          state = state.copyWith(
            emailError: "User data not found. Please contact support.",
            isLoading: false,
          );
          return false;
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email address.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password. Please try again.";
          break;
        case 'invalid-email':
          errorMessage = "Please enter a valid email address.";
          break;
        case 'user-disabled':
          errorMessage = "This account has been disabled.";
          break;
        case 'too-many-requests':
          errorMessage = "Too many login attempts. Please try again later.";
          break;
        case 'invalid-credential':
          errorMessage =
              "Invalid email or password. Please check your credentials.";
          break;
        default:
          errorMessage = "Login failed. Please try again.";
          log('Firebase Auth Error: ${e.code} - ${e.message}');
      }

      state = state.copyWith(
        emailError: errorMessage,
        isLoading: false,
      );
      return false;
    } catch (e) {
      log('Login error: $e');
      state = state.copyWith(
        emailError: "An unexpected error occurred. Please try again.",
        isLoading: false,
      );
      return false;
    }

    state = state.copyWith(isLoading: false);
    return false;
  }

  void reset() {
    state = LoginState();
  }
}
