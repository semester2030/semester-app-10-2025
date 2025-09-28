import 'package:freezed_annotation/freezed_annotation.dart';

part 'otp_model.freezed.dart';
part 'otp_model.g.dart';

@freezed
abstract class OTPModel with _$OTPModel {
  factory OTPModel({
    required String email,
    required String otp,
  }) = _OTPModel;

  factory OTPModel.fromJson(Map<String, dynamic> json) =>
      _$OTPModelFromJson(json);
}
