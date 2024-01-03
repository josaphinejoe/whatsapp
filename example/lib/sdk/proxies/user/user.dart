import 'dart:io';

abstract class User {
  String get firstName;
  String? get lastName;
  File? get profilePicture;
  String get phone;

  Future<void> addContact(String firstName, String phone, String? lastName);
  Future<void> sendMessage(String receiverPhone, String msg);
  Future<void> sendImage(String receiverPhone, String filePath);
  Future<void> changeName(String firstName, String? lastName);
  Future<void> changeProfilePicture(File profilePicture);
}
