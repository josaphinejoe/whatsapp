import 'package:example/sdk/models/message-info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  String firstName;
  String? lastName;
  String phone;
  String? displayPicture;
  List<MessageInfo> chatList =[];


  Contact({
    required this.firstName,
    this.lastName,
    required this.phone,
    this.displayPicture
  });

//for serialize and deserialize
  factory Contact.fromJson(Map<String,dynamic> json)=> _$ContactFromJson(json);
  Map<String,dynamic> toJson() => _$ContactToJson(this);
}