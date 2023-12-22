import 'package:example/sdk/models/chat.dart';
import 'package:example/sdk/models/contact.dart';

abstract class ContactService
{
  Future<List<Contact>> getContactList();
  Future<void> addContact(String firstName,String phone, String? lastName);
  Future<List<Chat>> getChatList();
  Future<Contact> getContact (String phone);
  Future<void> sendMessage(String receiverPhone,String msg, bool isImage);
}