import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/screens/auth/login/model/login_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'auth_state.g.dart';

/// The current authentication state of the app.
///
/// This notifier is responsible for saving/removing the token and profile info
/// to the storage through the [login] and [logout] methods.
@riverpod
class CurrentAuthState extends _$CurrentAuthState {
  @override
  AuthState build() {
    final user = FirebaseAuth.instance.currentUser;
    log(user != null
        ? "Current user: ${user.email}"
        : "No user currently logged in");
    if (user != null) {
      return AuthState.authenticated;
    } else {
      return AuthState.unauthenticated;
    }
  }
}

/// The possible authentication states of the app.
enum AuthState {
  unknown(
    redirectPath: '/',
    allowedPaths: [
      '/',
    ],
  ),

  unauthenticated(
    redirectPath: '/main_role_selection',
    allowedPaths: [
      '/splash',
      '/onboarding1',
      '/onboarding2',
      '/onboarding3',
      '/main_role_selection',
      '/customer_role_dropdown',
      '/role_specific_signup',
      '/user_type_selection',
      '/phone_registration',
      '/otp_verification',
      '/name_gender',
      '/password_creation',
      '/location_type',
      '/location_details',
      '/university_selection',
      '/student_university_selection',
      '/teacher_school_selection',
      '/employee_workplace_selection',
      '/metro_student_station_selection',
      '/date_selection',
      '/on_board',
      '/on_board_2',
      '/on_board_3',
      '/user_driver_selection',
      '/login',
      '/signup_user',
      '/signup_driver',
      '/upload_documents',
      '/forget_password',
      '/register',
      '/otp',
      '/user_privacy_terms_about',
      '/reset_password',
      '/registration',
      '/change_password',
      '/user_driver_selection',
      '/change_language'
    ],
  ),
  authenticated(
    redirectPath: '/bottom_nav_bar',
    allowedPaths: [
      '/reset_password',
      '/bottom_nav_bar',
      '/messages',
      '/change_password',
      '/select_meetup_location',
      '/meetup_details',
      '/interested_users',
      '/user_profile_detail',
      '/notification_settings',
      '/chatting',
      '/edit_profile',
      '/help_support',
      '/payment',
      '/add_payment',
      '/notifications',
      '/change_language',
      '/add_review',
      '/booking_details',
      '/cancel_ride',
      // '/add_address_details', // deprecated: old flow
      '/select_driver',
      '/additional_booking_details',
      '/booking_details_view',
      '/booking_details_driver_view',
      '/flag_inappropriate',
      '/service_availability',
      '/live_driver_tracking',
      '/settings',
    ],
  ),
  ;

  const AuthState({
    required this.redirectPath,
    required this.allowedPaths,
  });

  /// The target path to redirect when the current route is not allowed in this
  /// auth state.
  final String redirectPath;

  /// List of paths allowed when the app is in this auth state.
  final List<String> allowedPaths;
}
