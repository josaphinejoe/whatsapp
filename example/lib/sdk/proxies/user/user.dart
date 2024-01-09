import 'dart:io';

import 'package:example/sdk/models/chat.dart';
import 'package:example/sdk/proxies/contact/contact.dart';

abstract class User {
  String get firstName;
  String? get lastName;
  File? get profilePicture;
  String get phone;
  List<Contact> get contactList;

  Future<void> addContact(String firstName, String phone, String? lastName);
  Future<void> changeName(String firstName, String? lastName);
  Future<void> changeProfilePicture(File profilePicture);
  List<Chat> getChatSummary();
}
