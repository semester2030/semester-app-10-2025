import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_model.freezed.dart';
part 'review_model.g.dart';

@freezed
class ReviewModel with _$ReviewModel {
  const factory ReviewModel({
    String? id,
    required String bookingId,
    required String driverId,
    required String passengerId,
    required double overallRating,
    required double driverCommunicationRating,
    required double vehicleConditionRating,
    String? reviewText,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ReviewModel;

  factory ReviewModel.fromJson(Map<String, dynamic> json) =>
      _$ReviewModelFromJson(json);
}
