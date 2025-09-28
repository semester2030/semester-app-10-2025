class OfferModel {
  final String id;
  final String requestId;
  final String providerId;
  final String providerName;
  final String providerType; // 'individual' or 'company'
  final String providerPhoto;
  final double price;
  final String priceType; // 'monthly' or 'per_ride'
  final int seats;
  final String vehicleType;
  final String vehicleModel;
  final String vehiclePhoto;
  final double rating;
  final int tripsCount;
  final int etaMinutes;
  final double distanceKm;
  final String status; // 'pending', 'accepted', 'declined', 'negotiating'
  final DateTime createdAt;
  final DateTime? expiresAt;
  final String? counterOfferId;
  final String? chatId;
  final Map<String, dynamic>? additionalInfo;

  const OfferModel({
    required this.id,
    required this.requestId,
    required this.providerId,
    required this.providerName,
    required this.providerType,
    required this.providerPhoto,
    required this.price,
    required this.priceType,
    required this.seats,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehiclePhoto,
    required this.rating,
    required this.tripsCount,
    required this.etaMinutes,
    required this.distanceKm,
    required this.status,
    required this.createdAt,
    this.expiresAt,
    this.counterOfferId,
    this.chatId,
    this.additionalInfo,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as String,
      requestId: json['requestId'] as String,
      providerId: json['providerId'] as String,
      providerName: json['providerName'] as String,
      providerType: json['providerType'] as String,
      providerPhoto: json['providerPhoto'] as String,
      price: (json['price'] as num).toDouble(),
      priceType: json['priceType'] as String,
      seats: json['seats'] as int,
      vehicleType: json['vehicleType'] as String,
      vehicleModel: json['vehicleModel'] as String,
      vehiclePhoto: json['vehiclePhoto'] as String,
      rating: (json['rating'] as num).toDouble(),
      tripsCount: json['tripsCount'] as int,
      etaMinutes: json['etaMinutes'] as int,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
      counterOfferId: json['counterOfferId'] as String?,
      chatId: json['chatId'] as String?,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requestId': requestId,
      'providerId': providerId,
      'providerName': providerName,
      'providerType': providerType,
      'providerPhoto': providerPhoto,
      'price': price,
      'priceType': priceType,
      'seats': seats,
      'vehicleType': vehicleType,
      'vehicleModel': vehicleModel,
      'vehiclePhoto': vehiclePhoto,
      'rating': rating,
      'tripsCount': tripsCount,
      'etaMinutes': etaMinutes,
      'distanceKm': distanceKm,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'counterOfferId': counterOfferId,
      'chatId': chatId,
      'additionalInfo': additionalInfo,
    };
  }
}

class CounterOfferModel {
  final String id;
  final String offerId;
  final String fromUserId;
  final String toUserId;
  final double proposedPrice;
  final String message;
  final String status; // 'pending', 'accepted', 'declined'
  final DateTime createdAt;

  const CounterOfferModel({
    required this.id,
    required this.offerId,
    required this.fromUserId,
    required this.toUserId,
    required this.proposedPrice,
    required this.message,
    required this.status,
    required this.createdAt,
  });

  factory CounterOfferModel.fromJson(Map<String, dynamic> json) {
    return CounterOfferModel(
      id: json['id'] as String,
      offerId: json['offerId'] as String,
      fromUserId: json['fromUserId'] as String,
      toUserId: json['toUserId'] as String,
      proposedPrice: (json['proposedPrice'] as num).toDouble(),
      message: json['message'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'offerId': offerId,
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'proposedPrice': proposedPrice,
      'message': message,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class RequestModel {
  final String id;
  final String userId;
  final String serviceType;
  final String pickupAddress;
  final String dropOffAddress;
  final double suggestedPrice;
  final String priceType; // 'monthly' or 'per_ride'
  final String subscriptionDays; // 'Sun-Thu' or custom
  final String departureTimes; // 'Morning & Evening' or custom
  final int seatsRequired;
  final String vehicleType;
  final String rideType; // 'private' or 'shared'
  final String driverGender;
  final String providerType; // 'individual' or 'company' or 'any'
  final double minRating;
  final double searchRadius;
  final String status; // 'active', 'completed', 'cancelled'
  final DateTime createdAt;
  final DateTime? expiresAt;
  final List<String>? acceptedOffers;
  final Map<String, dynamic>? preferences;

  const RequestModel({
    required this.id,
    required this.userId,
    required this.serviceType,
    required this.pickupAddress,
    required this.dropOffAddress,
    required this.suggestedPrice,
    required this.priceType,
    required this.subscriptionDays,
    required this.departureTimes,
    required this.seatsRequired,
    required this.vehicleType,
    required this.rideType,
    required this.driverGender,
    required this.providerType,
    required this.minRating,
    required this.searchRadius,
    required this.status,
    required this.createdAt,
    this.expiresAt,
    this.acceptedOffers,
    this.preferences,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      serviceType: json['serviceType'] as String,
      pickupAddress: json['pickupAddress'] as String,
      dropOffAddress: json['dropOffAddress'] as String,
      suggestedPrice: (json['suggestedPrice'] as num).toDouble(),
      priceType: json['priceType'] as String,
      subscriptionDays: json['subscriptionDays'] as String,
      departureTimes: json['departureTimes'] as String,
      seatsRequired: json['seatsRequired'] as int,
      vehicleType: json['vehicleType'] as String,
      rideType: json['rideType'] as String,
      driverGender: json['driverGender'] as String,
      providerType: json['providerType'] as String,
      minRating: (json['minRating'] as num).toDouble(),
      searchRadius: (json['searchRadius'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
      acceptedOffers: json['acceptedOffers'] != null ? List<String>.from(json['acceptedOffers'] as List) : null,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'serviceType': serviceType,
      'pickupAddress': pickupAddress,
      'dropOffAddress': dropOffAddress,
      'suggestedPrice': suggestedPrice,
      'priceType': priceType,
      'subscriptionDays': subscriptionDays,
      'departureTimes': departureTimes,
      'seatsRequired': seatsRequired,
      'vehicleType': vehicleType,
      'rideType': rideType,
      'driverGender': driverGender,
      'providerType': providerType,
      'minRating': minRating,
      'searchRadius': searchRadius,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'acceptedOffers': acceptedOffers,
      'preferences': preferences,
    };
  }
}