import 'package:example/sdk/models/message-info.dart';

class Chat {
  String firstName;
  String phone;
  MessageInfo messageInfo;
  String? lastName;

  String? profilePicture;

  Chat({required this.firstName, required this.phone, required this.messageInfo, this.lastName, this.profilePicture});
}
