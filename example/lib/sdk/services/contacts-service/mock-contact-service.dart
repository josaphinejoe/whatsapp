import 'dart:convert';

import 'package:example/events/contact-added-event.dart';
import 'package:example/events/message-sent-event.dart';
import 'package:example/sdk/models/chat.dart';
import 'package:example/sdk/models/contact.dart';
import 'package:example/sdk/models/message-info.dart';
import 'package:example/sdk/services/contacts-service/contacts-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockContactService implements ContactService
{
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();
  
  final FlutterSecureStorage _contactsStorage = FlutterSecureStorage();
  final _storageKey="contacts";

  List<Contact> _contactList =[];


  MockContactService()
  {
    this._initialiseContactList();
  }


  Future<List<Contact>> getContactList() async
  {
    if(this._contactList.isEmpty)
      await this._initialiseContactList();

    return this._contactList;
  }

  Future<void> addContact(String firstName,String phone, String? lastName) async 
  {
    given(firstName, "firstName").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(phone, "phone").ensure((t)=>t.isNotEmptyOrWhiteSpace);

    Contact contact=Contact(firstName: firstName, lastName: lastName,phone: phone);
    
    this._contactList.add(contact);
    await this._updateStorage();
    this._eventAggregator.publish(ContactAddedEvent());
  }

  Future<List<Chat>> getChatList() async 
  {
    if(this._contactList.isEmpty)
      await this._initialiseContactList();

    List<Chat>chatList = _generateChatList();
    chatList.sort((a,b)=>b.messageInfo.time.compareTo(a.messageInfo.time));
    return chatList;
  }

  Future<Contact> getContact (String phone) async 
  {
    given(phone, "phone").ensure((t)=>t.isNotEmptyOrWhiteSpace);

      if(this._contactList.isEmpty)
        await this._initialiseContactList();
      
    return this._contactList.firstWhere((t) => t.phone== phone);
  }

  Future<void> sendMessage(String receiverPhone,String msg, bool isImage) async 
  {
    given(receiverPhone, "receiverPhone").ensure((t)=>t.isNotEmptyOrWhiteSpace);

    Contact contact = this._contactList.firstWhere((t) => t.phone == receiverPhone);
    contact.chats.add(MessageInfo(message: msg, time: DateTime.now().millisecondsSinceEpoch, isMyMsg: true, isImage: isImage));
    this._eventAggregator.publish(MessageSentEvent(contact));

       await Future.delayed(const Duration(seconds: 10),()  {
             contact.chats.add(MessageInfo(message: "Hi, How are you?", time: DateTime.now().millisecondsSinceEpoch, isMyMsg: false));
            this._eventAggregator.publish(MessageSentEvent(contact));
        });

    await this._updateStorage();
  }


   Future<void> _initialiseContactList()async
   {
    final String? storedContactList = await this._contactsStorage.read(key: this._storageKey);
    if(storedContactList == null)
    {
      this._mockContactList();
      await this._contactsStorage.write(key: this._storageKey, value: json.encode(this._contactList));
    }
    else
    {
      this._contactList = (json.decode(storedContactList) as List<dynamic>)
      .map((contactJson) => Contact.fromJson(contactJson)).toList();
    }
  }

  Future<void> _updateStorage() async 
  {
    final String contactsJson = json.encode(this._contactList.map((contact)=> contact.toJson()).toList());
    await this._contactsStorage.write(key: this._storageKey, value: contactsJson);
  }

  List<Chat> _generateChatList()
  {
    return this._contactList.where((t) => t.chats.isNotEmpty)
        .map((t) => Chat(firstName:t.firstName,lastName:t.lastName,phone:t.phone,messageInfo:t.chats.last,displayPicture:t.displayPicture)).toList();
  }

  void _mockContactList()
  {
       Contact hebbaContact = Contact(firstName: 'Hebba', lastName: 'Jose', phone: '9947367259',displayPicture:"https://miro.medium.com/v2/resize:fit:800/1*avN_YJhMr_MJZ48a-RbZzw.jpeg");

        hebbaContact.chats.add(MessageInfo(
        message: 'send me 2k',
        time: 1702009124942,
        isMyMsg: false));

        hebbaContact.chats.add(MessageInfo(
        message: 'ok',
        time: 1702009124942,
        isMyMsg: true));

    _contactList.add(hebbaContact);

    Contact johnlyContact = Contact(firstName: 'Johnly', phone: '9123456789',displayPicture: "https://mastimorning.com/wp-content/uploads/2023/07/Download-hd-girls-whatsapp-dp-Pics-images-Download.jpg");

    johnlyContact.chats.add(MessageInfo(
        message: 'Hello Johnly, How is the flood? Hope you are safe',
        time: 1701943200000,
        isMyMsg: true));

    johnlyContact.chats.add(MessageInfo(
        message: 'I am safe only, still pouring outside.',
        time: 1701946800000,
        isMyMsg: false));

    johnlyContact.chats.add(MessageInfo(
        message: 'so WFH only right?',
        time: 1701946800000,
        isMyMsg: true));

    _contactList.add(johnlyContact);

    Contact meghanaContact = Contact(firstName: 'Meghana', lastName: 'Dhaware', phone: '9876543210',displayPicture: "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/d4af53c8-66ff-403f-bf37-92c23c3e540c/dfb4k01-be3fbe9c-7814-41d8-89d9-522af3d9c123.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2Q0YWY1M2M4LTY2ZmYtNDAzZi1iZjM3LTkyYzIzYzNlNTQwY1wvZGZiNGswMS1iZTNmYmU5Yy03ODE0LTQxZDgtODlkOS01MjJhZjNkOWMxMjMuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.W0s7AfSUNUfNcyFMf4Tw7l-II9_sIXfYfJl3siRrBvc");

    meghanaContact.chats.add(MessageInfo(
        message: 'Hi Meghana, Happy Birthday',
        time: 1701936000000,
        isMyMsg: true));

    meghanaContact.chats.add(MessageInfo(
        message: 'Thank you very much Irene',
        time: 1701940815000,
        isMyMsg: false));

    _contactList.add(meghanaContact);

    Contact roseContact = Contact(firstName: 'Rose', lastName: 'Mary', phone: '98765432345',displayPicture: "https://mastimorning.com/wp-content/uploads/2023/07/Best-HD-girls-whatsapp-dp-Pics-Images-2023.jpg");

        roseContact.chats.add(MessageInfo(
        message: 'Hi Irene',
        time: 1702006038985,
        isMyMsg: false));

        roseContact.chats.add(MessageInfo(
        message: 'Hi Rose',
        time: 1702006038985,
        isMyMsg: true));

    _contactList.add(roseContact);

    Contact sreeLakshmiContact = Contact(firstName: 'Sree', lastName: 'Lakshmi', phone: '9476543210',displayPicture: "https://mastimorning.com/wp-content/uploads/2023/07/Best-HD-girls-whatsapp-dp-Wallpaper.jpg");

    sreeLakshmiContact.chats.add(MessageInfo(
        message: 'I will not be there in eveng, have some urgent work.',
        time: 1701936000000,
        isMyMsg: true));

    sreeLakshmiContact.chats.add(MessageInfo(
        message: 'ok. let me know, if you are coming',
        time: 1701936000000,
        isMyMsg: false));

    sreeLakshmiContact.chats.add(MessageInfo(
        message: 'https://miro.medium.com/v2/resize:fit:800/1*avN_YJhMr_MJZ48a-RbZzw.jpeg',
        time: 1701936000000,
        isMyMsg: false, 
        isImage: true));

        _contactList.add(sreeLakshmiContact);
  }
}