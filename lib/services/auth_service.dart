import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get current user data from Firestore
  static Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userDoc = await userCollection.doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc.data();
      }
      return null;
    } catch (e) {
      log('Error getting current user data: $e');
      return null;
    }
  }

  /// Check if current user is a driver
  static Future<bool> isCurrentUserDriver() async {
    try {
      final userData = await getCurrentUserData();
      if (userData != null) {
        return userData['isDriver'] ?? true; // Default to driver if not found
      }
      return false;
    } catch (e) {
      log('Error checking if user is driver: $e');
      return false;
    }
  }

  /// Get user verification status
  static Future<Map<String, bool>> getUserVerificationStatus() async {
    try {
      final userData = await getCurrentUserData();
      if (userData != null) {
        return {
          'phoneVerified': userData['phoneVerified'] ?? false,
          'idVerified': userData['idverified'] ?? false,
          'isBlocked': userData['isBlocked'] ?? false,
        };
      }
      return {
        'phoneVerified': false,
        'idVerified': false,
        'isBlocked': false,
      };
    } catch (e) {
      log('Error getting user verification status: $e');
      return {
        'phoneVerified': false,
        'idVerified': false,
        'isBlocked': false,
      };
    }
  }

  /// Sign out current user
  static Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('Error signing out: $e');
      rethrow;
    }
  }
}
