import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String? uid; // Document ID from Firestore
  final String sender;
  final String receiver;
  final String message;
  final DateTime? timestamp;
  final String? message_type;
  final String? meetupId; // Added field to reference a meetup
  final String? sponserPinId; // Added field to reference a sponsored pin
  final double? customOfferAmount; // Amount for custom payment offers
  final String? customOfferDescription; // Description for custom payment offers
  final String? customOfferId; // Unique ID for custom payment offers
  final String? customOfferStatus; // Status: 'pending', 'accepted', 'rejected'
  final String? businessId; // Business ID for custom payment offers
  // Sponsored pin data for custom offers
  final String? sponserPinName; // Business name
  final String? sponserPinCategory; // Business category
  final String? sponserPinLogo; // Business logo URL

  Message({
    this.uid, // Document ID (optional for new messages)
    required this.sender,
    required this.receiver,
    required this.message,
    required this.timestamp,
    this.message_type,
    this.meetupId, // Added meetupId parameter
    this.sponserPinId, // Added sponserPinId parameter
    this.customOfferAmount, // Custom offer amount
    this.customOfferDescription, // Custom offer description
    this.customOfferId, // Custom offer ID
    this.customOfferStatus, // Custom offer status
    this.businessId, // Business ID for custom payment offers
    this.sponserPinName, // Business name
    this.sponserPinCategory, // Business category
    this.sponserPinLogo, // Business logo URL
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Message(
      uid: doc.id, // Add document ID
      sender: data['sender'],
      receiver: data['receiver'],
      message: data['message'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      message_type: data['message_type'],
      meetupId: data['meetupId'], // Added field to constructor
      sponserPinId: data['sponserPinId'], // Added field to constructor
      customOfferAmount: data['customOfferAmount']?.toDouble(),
      customOfferDescription: data['customOfferDescription'],
      customOfferId: data['customOfferId'],
      customOfferStatus: data['customOfferStatus'],
      businessId: data['businessId'],
      sponserPinName: data['sponserPinName'],
      sponserPinCategory: data['sponserPinCategory'],
      sponserPinLogo: data['sponserPinLogo'],
    );
  }

  // Method to convert Message to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'timestamp': timestamp,
      'message_type': message_type,
      'meetupId': meetupId,
      'sponserPinId': sponserPinId,
      'customOfferAmount': customOfferAmount,
      'customOfferDescription': customOfferDescription,
      'customOfferId': customOfferId,
      'customOfferStatus': customOfferStatus,
      'businessId': businessId,
      'sponserPinName': sponserPinName,
      'sponserPinCategory': sponserPinCategory,
      'sponserPinLogo': sponserPinLogo,
    };
  }
}
