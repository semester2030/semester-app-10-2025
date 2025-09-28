import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:semester_student_ride_app/config/firebase_collections.dart';

// FCM API service to send push notifications
class FCMService {
  // Your FCM server key - stored securely
  // Note: In production, this should be stored on a secure server
  // and not in the client app code
  static const String _serverKey = 'YOUR_FCM_SERVER_KEY';
  static const String _fcmUrl = 'https://fcm.googleapis.com/fcm/send';

  // Send a push notification via FCM API
  static Future<bool> sendPushNotification({
    required String token,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=$_serverKey',
      };

      final notification = {
        'body': body,
        'title': title,
        'sound': 'default',
        if (imageUrl != null) 'image': imageUrl,
      };

      final payload = {
        'notification': notification,
        'data': data ?? {},
        'to': token,
        'priority': 'high',
        'content_available': true,
      };

      final response = await http.post(
        Uri.parse(_fcmUrl),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        log('FCM Notification sent: $responseData');
        return responseData['success'] == 1;
      } else {
        log('Error sending FCM notification: ${response.body}');
        return false;
      }
    } catch (e) {
      log('Exception sending FCM notification: $e');
      return false;
    }
  }

  // Send notification to a specific user by userId
  static Future<bool> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    String? imageUrl,
    Map<String, dynamic>? data,
  }) async {
    try {
      // Get user's FCM token from Firestore
      final userDoc = await userCollection.doc(userId).get();
      if (!userDoc.exists) {
        log('User document not found for ID: $userId');
        return false;
      }

      final userData = userDoc.data();
      if (userData == null || userData['fcmToken'] == null) {
        log('FCM token not found for user: $userId');
        return false;
      }

      final fcmToken = userData['fcmToken'] as String;
      return sendPushNotification(
        token: fcmToken,
        title: title,
        body: body,
        imageUrl: imageUrl,
        data: data,
      );
    } catch (e) {
      log('Error sending notification to user $userId: $e');
      return false;
    }
  }

  // Get current user's FCM token
  static Future<String?> getCurrentUserToken() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return null;

      final userDoc = await userCollection.doc(currentUser.uid).get();
      if (!userDoc.exists) return null;

      final userData = userDoc.data();
      if (userData == null) return null;

      return userData['fcmToken'] as String?;
    } catch (e) {
      log('Error getting current user token: $e');
      return null;
    }
  }
}
