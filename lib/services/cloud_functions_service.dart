import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';

/// A service class for interacting with Firebase Cloud Functions
/// that implement the FCM v1 API for sending notifications
class CloudFunctionsService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  // Send a notification to a specific device using FCM token
  Future<bool> sendNotification({
    required String token,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      final result = await _functions.httpsCallable('sendNotification').call({
        'token': token,
        'title': title,
        'body': body,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (data != null) 'data': data,
      });

      final success = result.data['success'] as bool;
      if (success) {
        log('Notification sent successfully via Cloud Functions');
      } else {
        log('Error sending notification: ${result.data['error']}');
      }
      return success;
    } catch (e) {
      log('Exception calling sendNotification function: $e');
      return false;
    }
  }

  // Send a notification to a topic
  Future<bool> sendNotificationToTopic({
    required String topic,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      final result =
          await _functions.httpsCallable('sendNotificationToTopic').call({
        'topic': topic,
        'title': title,
        'body': body,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (data != null) 'data': data,
      });

      final success = result.data['success'] as bool;
      if (success) {
        log('Notification sent to topic $topic successfully via Cloud Functions');
      } else {
        log('Error sending notification to topic: ${result.data['error']}');
      }
      return success;
    } catch (e) {
      log('Exception calling sendNotificationToTopic function: $e');
      return false;
    }
  }

  // Subscribe a user to a topic
  Future<bool> subscribeToTopic(String topic) async {
    try {
      final String? token = await _getCurrentUserToken();
      if (token == null) {
        log('Cannot subscribe to topic: FCM token not available');
        return false;
      }

      // Update user document in Firestore to track subscriptions
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await userCollection.doc(currentUser.uid).update({
          'fcmTopics': FieldValue.arrayUnion([topic])
        });
      }

      log('User subscribed to topic: $topic');
      return true;
    } catch (e) {
      log('Error subscribing to topic: $e');
      return false;
    }
  }

  // Unsubscribe a user from a topic
  Future<bool> unsubscribeFromTopic(String topic) async {
    try {
      final String? token = await _getCurrentUserToken();
      if (token == null) {
        log('Cannot unsubscribe from topic: FCM token not available');
        return false;
      }

      // Update user document in Firestore to track subscriptions
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await userCollection.doc(currentUser.uid).update({
          'fcmTopics': FieldValue.arrayRemove([topic])
        });
      }

      log('User unsubscribed from topic: $topic');
      return true;
    } catch (e) {
      log('Error unsubscribing from topic: $e');
      return false;
    }
  }

  // Send notifications to multiple users at once (for group messages)
  Future<Map<String, dynamic>?> sendBulkNotifications({
    required List<String> userIds,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Log concisely
      log('Sending bulk notifications to ${userIds.length} users',
          name: 'BULK_NOTIFICATION');

      // Note: We're still using the specific bulk notifications function
      // as it's more efficient than calling createNotification individually
      final result =
          await _functions.httpsCallable('sendBulkNotifications').call({
        'userIds': userIds,
        'title': title,
        'body': body,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (data != null) 'data': data,
      });

      final success = result.data['success'] as bool;
      if (success) {
        final successCount = result.data['successCount'] as int;
        final failureCount = result.data['failureCount'] as int;
        log('Bulk notifications results: $successCount sent, $failureCount failed',
            name: 'BULK_NOTIFICATION');
        return result.data;
      } else {
        log('Error sending bulk notifications: ${result.data['error']}',
            name: 'NOTIFICATION_ERROR');
        return null;
      }
    } catch (e) {
      log('Exception calling sendBulkNotifications function: $e');
      return null;
    }
  }

  // Test admin app notification (for debugging)
  Future<Map<String, dynamic>?> testAdminNotification({
    required String userId,
  }) async {
    try {
      final result =
          await _functions.httpsCallable('testAdminNotification').call({
        'userId': userId,
      });

      log('Test admin notification result: ${result.data}');
      return result.data;
    } catch (e) {
      log('Exception calling testAdminNotification function: $e');
      return null;
    }
  }

  // Note: We no longer need a method to create notifications via Cloud Functions
  // Instead, we create Firestore documents directly which trigger the Cloud Functions

  // Helper method to get the current user's FCM token
  Future<String?> _getCurrentUserToken() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return null;

      final userDoc = await userCollection.doc(currentUser.uid).get();
      if (!userDoc.exists) return null;

      final userData = userDoc.data();
      return userData?['fcmToken'] as String?;
    } catch (e) {
      log('Error getting current user token: $e');
      return null;
    }
  }

  // Generic method to call any Cloud Function by name
  Future<dynamic> callFunction(String functionName,
      {Map<String, dynamic>? data}) async {
    try {
      final result =
          await _functions.httpsCallable(functionName).call(data ?? {});
      log('Successfully called Cloud Function: $functionName');
      return result.data;
    } catch (e) {
      log('Error calling Cloud Function $functionName: $e');
      return null;
    }
  }
}
