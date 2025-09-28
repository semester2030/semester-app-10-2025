import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String? imageUrl;
  final String? senderUserId;
  final String? chatRoomId;
  final String? meetupId; // Added for meetup notifications
  final String? notificationId; // The actual notification document ID stored in the notification
  final String type; // 'message', 'meetup', 'system', etc.
  final Map<String, dynamic>? data; // Additional data
  final DateTime timestamp;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.imageUrl,
    this.senderUserId,
    this.chatRoomId,
    this.meetupId,
    this.notificationId,
    required this.type,
    this.data,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
      'senderUserId': senderUserId,
      'chatRoomId': chatRoomId,
      'meetupId': meetupId,
      'notificationId': notificationId,
      'type': type,
      'data': data,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return NotificationModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      imageUrl: data['imageUrl'],
      senderUserId: data['senderUserId'],
      chatRoomId: data['chatRoomId'],
      meetupId: data['meetupId'],
      notificationId: data['notificationId'],
      type: data['type'] ?? 'system',
      data: data['data'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
    );
  }
}
