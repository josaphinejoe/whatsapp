// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      json['firstName'] as String,
      json['lastName'] as String?,
      const FileConverter().fromJson(json['displayPicture'] as String?),
      json['phone'] as String,
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'displayPicture': const FileConverter().toJson(instance.profilePicture),
      'phone': instance.phone,
    };
