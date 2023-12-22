// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String,
      displayPicture: json['displayPicture'] as String?,
    )..chatList = (json['chatList'] as List<dynamic>)
        .map((e) => MessageInfo.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'displayPicture': instance.displayPicture,
      'chatList': instance.chatList,
    };
