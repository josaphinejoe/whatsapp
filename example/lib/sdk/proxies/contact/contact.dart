import 'package:example/sdk/models/message-info.dart';

abstract class Contact {
  String get firstName;
  String? get lastName;
  String get phone;
  String? get profilePicture;
  List<MessageInfo> get chats;

  Future<void> sendMessage(String receiverPhone, String msg);
  Future<void> sendImage(String receiverPhone, String filePath);
}
