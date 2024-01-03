import 'package:example/sdk/models/message-info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  String firstName;
  String? lastName;
  String phone;
  MessageInfo messageInfo;
  String? profilePicture;

  Chat({required this.firstName, this.lastName, required this.phone, required this.messageInfo, this.profilePicture});

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
