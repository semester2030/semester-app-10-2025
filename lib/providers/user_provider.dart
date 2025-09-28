import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';
import 'dart:developer';

/// A provider that fetches a user by ID
final userByIdProvider =
    FutureProvider.family<UserSignupModel?, String>((ref, userId) async {
  try {
    if (userId.isEmpty) {
      log('Cannot fetch user with empty ID', name: 'UserProvider');
      return null;
    }

    log('Fetching user with ID: $userId', name: 'UserProvider');

    // Add timeout to prevent infinite loading
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        log('Timeout fetching user with ID: $userId', name: 'UserProvider');
        throw Exception('Timeout: Unable to fetch user data');
      },
    );

    if (!userDoc.exists || userDoc.data() == null) {
      log('User not found for ID: $userId', name: 'UserProvider');
      return null;
    }

    final userData = userDoc.data()!;
    userData['id'] = userDoc.id; // Ensure the document ID is included

    log('Successfully fetched user: ${userData['name']}', name: 'UserProvider');
    return UserSignupModel.fromJson(userData);
  } catch (e, stack) {
    log('Error fetching user: $e', name: 'UserProvider');
    log('Stack trace: $stack', name: 'UserProvider');
    // Throw the error to let the UI handle it in the error state
    throw Exception('Failed to load user: $e');
  }
});

/// A provider to manually clear cache for a specific user
final clearUserCacheProvider = Provider<void Function(String)>((ref) {
  return (String userId) {
    ref.invalidate(userByIdProvider(userId));
  };
});
