// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactDto _$ContactDtoFromJson(Map<String, dynamic> json) => ContactDto(
      json['firstName'] as String,
      json['lastName'] as String?,
      json['phone'] as String,
      json['profilePicture'] as String?,
      (json['chats'] as List<dynamic>)
          .map((e) => MessageInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContactDtoToJson(ContactDto instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'profilePicture': instance.profilePicture,
      'chats': instance.chats,
    };
