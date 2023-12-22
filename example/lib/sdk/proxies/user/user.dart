import 'dart:io';


abstract class User 
{
  String get firstName;
  String? get lastName;
  File? get displayPicture;
  String get phone;


  Future<void> addContact(String firstName,String phone,String? lastName);
  Future<void> sendMessage(String receiverPhone,String msg, bool isImage);
  Future<void> changeName(String firstName, String? lastName);
  Future<void> changeDp(File dp);
}