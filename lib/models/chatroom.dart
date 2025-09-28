// Model classes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoom {
  final String id;
  final List<String> participants;
  final String status;
  final DateTime lastMessageTime;
  final String lastMessage;
  final String? blockedBy;
  final bool? lastMessageRead;
  final bool? amILastMessageSender;

  ChatRoom({
    required this.id,
    required this.participants,
    required this.status,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.lastMessageRead,
    required this.amILastMessageSender,
    this.blockedBy,
  });

  factory ChatRoom.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ChatRoom(
      id: doc.id,
      lastMessageRead: data['lastMessageRead'],
      participants: List<String>.from(data['participants']),
      status: data['status'],
      amILastMessageSender:
          data['lastMessageSender'] == FirebaseAuth.instance.currentUser?.uid,
      lastMessageTime: (data['lastMessageTime'] as Timestamp).toDate(),
      lastMessage: data['lastMessage'],
      blockedBy: data['blockedBy'],
    );
  }
}
