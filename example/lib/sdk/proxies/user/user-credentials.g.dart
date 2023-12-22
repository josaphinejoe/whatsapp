// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user-credentials.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCredentials _$UserCredentialsFromJson(Map<String, dynamic> json) =>
    UserCredentials(
      UserDto.fromJson(json['user'] as Map<String, dynamic>),
      json['password'] as String,
      json['isAuthenticated'] as bool,
    );

Map<String, dynamic> _$UserCredentialsToJson(UserCredentials instance) =>
    <String, dynamic>{
      'user': instance.user,
      'password': instance.password,
      'isAuthenticated': instance.isAuthenticated,
    };
