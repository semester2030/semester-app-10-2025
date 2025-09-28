import 'package:cloud_firestore/cloud_firestore.dart';

final userCollection = FirebaseFirestore.instance.collection('users');
final notificationsCollection =
    FirebaseFirestore.instance.collection('notifications');
final chatsCollection = FirebaseFirestore.instance.collection('chats');

// Legacy sponser_pins collection has been removed.
// Sponsored pins are now stored in business subcollections at:
// /businesses/{businessId}/sponsored_pins/{pinId}
