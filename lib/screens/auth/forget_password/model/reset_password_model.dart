import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_model.freezed.dart';
part 'reset_password_model.g.dart';

@freezed
abstract class ResetPasswordModel with _$ResetPasswordModel {
  factory ResetPasswordModel(
      {required String email,
      required String password,
      required String accessToken}) = _ResetPasswordModel;

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordModelFromJson(json);
}
