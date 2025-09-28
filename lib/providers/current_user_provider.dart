import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';

part 'current_user_provider.g.dart';

/// Provider that returns the current user details from Firebase
/// Returns UserSignupModel if user is logged in, null otherwise
@riverpod
Future<UserSignupModel?> currentUserDetails(CurrentUserDetailsRef ref) async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;

    // If no user is logged in, return null
    if (currentUser == null) {
      log('No user currently logged in');
      return null;
    }

    log('Fetching user details for uid: ${currentUser.uid}');

    // Fetch user document from Firestore
    final userDoc = await userCollection.doc(currentUser.uid).get();

    // If document doesn't exist, return null
    if (!userDoc.exists) {
      log('User document not found for uid: ${currentUser.uid}');
      return null;
    }

    final userData = userDoc.data();
    if (userData == null) {
      log('User data is null for uid: ${currentUser.uid}');
      return null;
    }

    log('Successfully fetched user data for: ${userData['name'] ?? 'Unknown'}');

    // Convert Firestore data to UserSignupModel
    return UserSignupModel.fromJson(userData);
  } catch (e) {
    log('Error fetching current user details: $e');
    return null;
  }
}

/// Stream provider that listens to real-time updates of current user details
@riverpod
Stream<UserSignupModel?> currentUserDetailsStream(
    CurrentUserDetailsStreamRef ref) {
  final currentUser = FirebaseAuth.instance.currentUser;

  // If no user is logged in, return a stream with null
  if (currentUser == null) {
    log('No user currently logged in for stream');
    return Stream.value(null);
  }

  log('Setting up user details stream for uid: ${currentUser.uid}');

  // Return a stream that listens to the user document
  return userCollection.doc(currentUser.uid).snapshots().map((snapshot) {
    try {
      if (!snapshot.exists) {
        log('User document not found in stream for uid: ${currentUser.uid}');
        return null;
      }

      final userData = snapshot.data();
      if (userData == null) {
        log('User data is null in stream for uid: ${currentUser.uid}');
        return null;
      }

      log('User data updated in stream for: ${userData['name'] ?? 'Unknown'}');
      return UserSignupModel.fromJson(userData);
    } catch (e) {
      log('Error parsing user data from stream: $e');
      return null;
    }
  });
}
