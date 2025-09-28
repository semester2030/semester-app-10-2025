import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation.g.dart';
part 'conversation.freezed.dart';

@freezed
abstract class Conversation with _$Conversation {
  const factory Conversation({
    // int? id,
    // @JsonKey(name: 'user_one') String? userone,
    // @JsonKey(name: 'user_two') String? usertwo,
    // // @JsonKey(fromJson: _MessageFromJson, toJson: _MessageToJson)
    // // Message? message,
    // String? lastmessage,
    // @JsonKey(name: 'unseen_count') int? unseencount,

    int? id,
    String? useroneName,
    String? usertwoName,
    String? useroneProfilePicUrl,
    String? usertwoProfilePicUrl,
    String? lastmessage,
  }) = _Conversation;

  factory Conversation.fromJson(Map<String, dynamic> json) =>
      _$ConversationFromJson(json);
}
