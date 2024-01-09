// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message-info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageInfo _$MessageInfoFromJson(Map<String, dynamic> json) => MessageInfo(
      message: json['message'] as String,
      time: json['time'] as int,
      isMyMsg: json['isMyMsg'] as bool,
      isImage: json['isImage'] as bool? ?? false,
    );

Map<String, dynamic> _$MessageInfoToJson(MessageInfo instance) =>
    <String, dynamic>{
      'message': instance.message,
      'time': instance.time,
      'isMyMsg': instance.isMyMsg,
      'isImage': instance.isImage,
    };
