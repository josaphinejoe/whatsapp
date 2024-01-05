import 'dart:io';

import 'package:example/events/contact-added-event.dart';
import 'package:example/events/user-updated-event.dart';
import 'package:example/sdk/models/chat.dart';
import 'package:example/sdk/proxies/contact/contact-dto.dart';
import 'package:example/sdk/proxies/contact/contact-proxy.dart';
import 'package:example/sdk/proxies/contact/contact.dart';
import 'package:example/sdk/proxies/user/user-dto.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';

class UserProxy implements User {
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();

  UserDto _dto;

  UserProxy(this._dto);

  @override
  String get firstName => this._dto.firstName;

  @override
  String? get lastName => this._dto.lastName;

  @override
  File? get profilePicture => this._dto.profilePicture;

  @override
  String get phone => this._dto.phone;

  @override
  List<Contact> get contactList => this._dto.contactList;

  @override
  Future<void> addContact(String firstName, String phone, String? lastName) async {
    given(firstName, "firstName").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(phone, "phone").ensure((t) => t.isNotEmptyOrWhiteSpace);

    if (this.contactList.find((t) => t.phone == phone) != null) {
      throw Exception("Contact with same number already exist");
    }

    final contact = new ContactProxy(ContactDto(firstName, lastName, phone, null, []));
    final contactList = [...this.contactList, contact];
    final newUser = UserDto(this.firstName, this.lastName, this.profilePicture, this.phone, contactList);
    this._dto = newUser;
    this._eventAggregator.publish(ContactAddedEvent());
    await this._userService.updateStorage();
  }

  @override
  Future<void> changeName(String firstName, String? lastName) async {
    given(firstName, "firstName").ensure((t) => t.isNotEmptyOrWhiteSpace);

    final newUser = UserDto(firstName, lastName, this.profilePicture, this.phone, this.contactList);
    this._dto = newUser;
    this._eventAggregator.publish(UserUpdatedEvent(this));
    await this._userService.updateStorage();
  }

  @override
  Future<void> changeProfilePicture(File profilePicture) async {
    final newUser = UserDto(this.firstName, this.lastName, profilePicture, this.phone, this.contactList);
    this._dto = newUser;
    this._eventAggregator.publish(UserUpdatedEvent(this));
    await this._userService.updateStorage();
  }

  List<Chat> getChatSummary() {
    final chatSummary = _generateChatList();
    chatSummary.sort((a, b) => b.messageInfo.time.compareTo(a.messageInfo.time));
    return chatSummary;
  }

  List<Chat> _generateChatList() {
    return this
        .contactList
        .where((t) => t.chats.isNotEmpty)
        .map(
          (t) => Chat(
            firstName: t.firstName,
            phone: t.phone,
            messageInfo: t.chats.last,
            lastName: t.lastName,
            profilePicture: t.profilePicture,
          ),
        )
        .toList();
  }

  factory UserProxy.fromJson(Map<String, dynamic> json) => UserProxy(UserDto.fromJson(json));
}
