// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationImpl _$$ConversationImplFromJson(Map<String, dynamic> json) =>
    _$ConversationImpl(
      id: (json['id'] as num?)?.toInt(),
      useroneName: json['useroneName'] as String?,
      usertwoName: json['usertwoName'] as String?,
      useroneProfilePicUrl: json['useroneProfilePicUrl'] as String?,
      usertwoProfilePicUrl: json['usertwoProfilePicUrl'] as String?,
      lastmessage: json['lastmessage'] as String?,
    );

Map<String, dynamic> _$$ConversationImplToJson(_$ConversationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'useroneName': instance.useroneName,
      'usertwoName': instance.usertwoName,
      'useroneProfilePicUrl': instance.useroneProfilePicUrl,
      'usertwoProfilePicUrl': instance.usertwoProfilePicUrl,
      'lastmessage': instance.lastmessage,
    };
