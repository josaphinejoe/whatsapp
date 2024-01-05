import 'package:json_annotation/json_annotation.dart';

part 'message-info.g.dart';

@JsonSerializable()
class MessageInfo {
  String message;
  int time;
  bool isMyMsg;
  bool isImage;

  MessageInfo({required this.message, required this.time, required this.isMyMsg, this.isImage = false});

//for serialize and deserialize
  factory MessageInfo.fromJson(Map<String, dynamic> json) => _$MessageInfoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageInfoToJson(this);
}
