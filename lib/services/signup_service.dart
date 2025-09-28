import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';
import 'package:semester_student_ride_app/models/user_signup_model.dart';

class SignupService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign up a user (student or driver)
  Future<User?> signupUser(UserSignupModel user) async {
    try {
      // Create user with email and password
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        // Add timestamps
        final userWithTimestamps =
            user.copyWith(createdAt: DateTime.now(), id: firebaseUser.uid);

        // Save user data to Firestore
        await userCollection
            .doc(firebaseUser.uid)
            .set(userWithTimestamps.toJson());

        log('User created successfully: ${firebaseUser.uid}');
        return firebaseUser;
      }
    } catch (e) {
      log('Error creating user: $e');
      rethrow;
    }
    return null;
  }

  /// Check if email already exists
  Future<bool> isEmailAlreadyRegistered(String email) async {
    try {
      final querySnapshot =
          await userCollection.where("email", isEqualTo: email.trim()).get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log('Error checking email availability: $e');
      return false; // Assume email is available if check fails
    }
  }

  /// Check if phone number already exists
  Future<bool> isPhoneNumberAlreadyRegistered(String phoneNumber) async {
    try {
      final querySnapshot = await userCollection
          .where("phoneNumber", isEqualTo: phoneNumber.trim())
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log('Error checking phone number availability: $e');
      return false; // Assume phone is available if check fails
    }
  }

  /// Update user documents after upload
  Future<void> updateDriverDocuments({
    required String userId,
    String? drivingLicenseImage,
    String? vehicleImage,
    String? vehicleMake,
    String? vehicleModel,
    String? vehicleYear,
    String? district,
    String? serviceType,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': DateTime.now(),
      };

      if (drivingLicenseImage != null) {
        updates['drivingLicenseImage'] = drivingLicenseImage;
      }
      if (vehicleImage != null) updates['vehicleImage'] = vehicleImage;
      if (vehicleMake != null) updates['vehicleMake'] = vehicleMake;
      if (vehicleModel != null) updates['vehicleModel'] = vehicleModel;
      if (vehicleYear != null) updates['vehicleYear'] = vehicleYear;
      if (district != null) updates['district'] = district;
      if (serviceType != null) updates['serviceType'] = serviceType;

      await userCollection.doc(userId).update(updates);
      log('Driver documents updated successfully');
    } catch (e) {
      log('Error updating driver documents: $e');
      rethrow;
    }
  }
}
