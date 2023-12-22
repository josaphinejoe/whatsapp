// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String,
      messageInfo:
          MessageInfo.fromJson(json['messageInfo'] as Map<String, dynamic>),
      displayPicture: json['displayPicture'] as String?,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'messageInfo': instance.messageInfo,
      'displayPicture': instance.displayPicture,
    };
