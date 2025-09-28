import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semester_student_ride_app/models/offer_model.dart';
import 'package:semester_student_ride_app/models/request_booking_model.dart';
import 'package:semester_student_ride_app/enums/transportation_service_type.dart';

class OfferService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _offersCollection = FirebaseFirestore.instance.collection('offers');
  final CollectionReference _requestsCollection = FirebaseFirestore.instance.collection('requests');
  final CollectionReference _counterOffersCollection = FirebaseFirestore.instance.collection('counter_offers');

  // Create a new request
  Future<String> createRequest(RequestModel request) async {
    try {
      final docRef = await _requestsCollection.add(request.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create request: $e');
    }
  }

  // Broadcast request to providers
  Future<void> broadcastRequest(String requestId, double radiusKm) async {
    try {
      // This would typically involve:
      // 1. Finding providers within radius
      // 2. Sending push notifications
      // 3. Creating offer opportunities
      
      // For now, we'll simulate by creating some mock offers
      await _createMockOffers(requestId);
    } catch (e) {
      throw Exception('Failed to broadcast request: $e');
    }
  }

  // Get offers for a request
  Stream<List<OfferModel>> getOffersForRequest(String requestId) {
    return _offersCollection
        .where('requestId', isEqualTo: requestId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OfferModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Create an offer
  Future<String> createOffer(OfferModel offer) async {
    try {
      final docRef = await _offersCollection.add(offer.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create offer: $e');
    }
  }

  // Accept an offer
  Future<void> acceptOffer(String offerId) async {
    try {
      await _offersCollection.doc(offerId).update({
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to accept offer: $e');
    }
  }

  // Decline an offer
  Future<void> declineOffer(String offerId) async {
    try {
      await _offersCollection.doc(offerId).update({
        'status': 'declined',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to decline offer: $e');
    }
  }

  // Create counter offer
  Future<String> createCounterOffer(CounterOfferModel counterOffer) async {
    try {
      final docRef = await _counterOffersCollection.add(counterOffer.toJson());
      
      // Update offer status to negotiating
      await _offersCollection.doc(counterOffer.offerId).update({
        'status': 'negotiating',
        'counterOfferId': docRef.id,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create counter offer: $e');
    }
  }

  // Get counter offers for an offer
  Stream<List<CounterOfferModel>> getCounterOffers(String offerId) {
    return _counterOffersCollection
        .where('offerId', isEqualTo: offerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CounterOfferModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Accept counter offer
  Future<void> acceptCounterOffer(String counterOfferId) async {
    try {
      // Get counter offer details
      final counterOfferDoc = await _counterOffersCollection.doc(counterOfferId).get();
      final counterOffer = CounterOfferModel.fromJson(counterOfferDoc.data() as Map<String, dynamic>);
      
      // Update offer with new price
      await _offersCollection.doc(counterOffer.offerId).update({
        'price': counterOffer.proposedPrice,
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      // Update counter offer status
      await _counterOffersCollection.doc(counterOfferId).update({
        'status': 'accepted',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to accept counter offer: $e');
    }
  }

  // Decline counter offer
  Future<void> declineCounterOffer(String counterOfferId) async {
    try {
      await _counterOffersCollection.doc(counterOfferId).update({
        'status': 'declined',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to decline counter offer: $e');
    }
  }

  // Get request details
  Future<RequestModel?> getRequest(String requestId) async {
    try {
      final doc = await _requestsCollection.doc(requestId).get();
      if (doc.exists) {
        return RequestModel.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get request: $e');
    }
  }

  // Create mock offers for testing
  Future<void> _createMockOffers(String requestId) async {
    final mockOffers = [
      OfferModel(
        id: 'offer_1',
        requestId: requestId,
        providerId: 'provider_1',
        providerName: 'أحمد محمد',
        providerType: 'individual',
        providerPhoto: 'https://via.placeholder.com/100',
        price: 450.0,
        priceType: 'monthly',
        seats: 4,
        vehicleType: 'Sedan Car',
        vehicleModel: 'Toyota Camry 2023',
        vehiclePhoto: 'https://via.placeholder.com/200',
        rating: 4.8,
        tripsCount: 1250,
        etaMinutes: 5,
        distanceKm: 2.3,
        status: 'pending',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(minutes: 30)),
      ),
      OfferModel(
        id: 'offer_2',
        requestId: requestId,
        providerId: 'provider_2',
        providerName: 'شركة النقل المتميزة',
        providerType: 'company',
        providerPhoto: 'https://via.placeholder.com/100',
        price: 480.0,
        priceType: 'monthly',
        seats: 6,
        vehicleType: 'Small Van',
        vehicleModel: 'Ford Transit',
        vehiclePhoto: 'https://via.placeholder.com/200',
        rating: 4.6,
        tripsCount: 3200,
        etaMinutes: 8,
        distanceKm: 3.1,
        status: 'pending',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(minutes: 30)),
      ),
      OfferModel(
        id: 'offer_3',
        requestId: requestId,
        providerId: 'provider_3',
        providerName: 'فاطمة علي',
        providerType: 'individual',
        providerPhoto: 'https://via.placeholder.com/100',
        price: 420.0,
        priceType: 'monthly',
        seats: 4,
        vehicleType: 'Sedan Car',
        vehicleModel: 'Honda Accord 2022',
        vehiclePhoto: 'https://via.placeholder.com/200',
        rating: 4.9,
        tripsCount: 890,
        etaMinutes: 12,
        distanceKm: 4.5,
        status: 'pending',
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(const Duration(minutes: 30)),
      ),
    ];

    for (final offer in mockOffers) {
      await _offersCollection.doc(offer.id).set(offer.toJson());
    }
  }

  // Convert BookingFlowState to RequestModel
  RequestModel bookingStateToRequest(
    String userId,
    String requestId,
    Map<String, dynamic> bookingData,
  ) {
    return RequestModel(
      id: requestId,
      userId: userId,
      serviceType: bookingData['serviceType'] ?? 'student',
      pickupAddress: bookingData['pickupAddress'] ?? '',
      dropOffAddress: bookingData['dropOffAddress'] ?? '',
      suggestedPrice: bookingData['suggestedPrice'] ?? 500.0,
      priceType: bookingData['priceType'] ?? 'monthly',
      subscriptionDays: bookingData['subscriptionDays'] ?? 'Sun-Thu',
      departureTimes: bookingData['departureTimes'] ?? 'Morning & Evening',
      seatsRequired: bookingData['seatsRequired'] ?? 1,
      vehicleType: bookingData['vehicleType'] ?? 'Sedan Car',
      rideType: bookingData['rideType'] ?? 'private',
      driverGender: bookingData['driverGender'] ?? 'any',
      providerType: bookingData['providerType'] ?? 'any',
      minRating: bookingData['minRating'] ?? 4.0,
      searchRadius: bookingData['searchRadius'] ?? 5.0,
      status: 'active',
      createdAt: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 2)),
      preferences: bookingData['preferences'] ?? {},
    );
  }
}
