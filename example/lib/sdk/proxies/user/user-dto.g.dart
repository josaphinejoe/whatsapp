// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      json['firstName'] as String,
      json['lastName'] as String?,
      const FileConverter().fromJson(json['profilePicture'] as String?),
      json['phone'] as String,
      const ContactListConverter().fromJson(json['contactList'] as List<dynamic>),
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePicture': const FileConverter().toJson(instance.profilePicture),
      'phone': instance.phone,
      'contactList': const ContactListConverter().toJson(instance.contactList),
    };
