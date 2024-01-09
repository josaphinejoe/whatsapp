import 'dart:async';

import 'package:example/events/message-sent-event.dart';
import 'package:example/sdk/models/message-info.dart';
import 'package:example/sdk/proxies/contact/contact-dto.dart';
import 'package:example/sdk/proxies/contact/contact.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';

class ContactProxy implements Contact {
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();
  final _userService = ServiceLocator.instance.resolve<UserService>();

  ContactDto _dto;

  ContactProxy(this._dto);

  @override
  String get firstName => this._dto.firstName;

  @override
  String? get lastName => this._dto.lastName;

  @override
  String get phone => this._dto.phone;

  @override
  String? get profilePicture => this._dto.profilePicture;

  @override
  List<MessageInfo> get chats => this._dto.chats;

  @override
  Future<void> sendMessage(String receiverPhone, String msg) async {
    given(receiverPhone, "receiverPhone").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(msg, "msg").ensure((t) => t.isNotEmptyOrWhiteSpace);

    await this._sendMessage(receiverPhone, msg, false);
  }

  @override
  Future<void> sendImage(String receiverPhone, String filePath) async {
    given(receiverPhone, "receiverPhone").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(filePath, "filePath").ensure((t) => t.isNotEmptyOrWhiteSpace);

    await this._sendMessage(receiverPhone, filePath, true);
  }

  Future<void> _sendMessage(String receiverPhone, String msg, bool isImage) async {
    given(receiverPhone, "receiverPhone").ensure((t) => t.isNotEmptyOrWhiteSpace);

    await this._generateMessage(msg, true, isImage);
    unawaited(
      Future.delayed(const Duration(seconds: 10), () async {
        await this._generateMessage("Hi, How are you?", false, false);
      }),
    );
  }

  Future<void> _generateMessage(String msg, bool isMyMsg, bool isImage) async {
    final chat =
        MessageInfo(message: msg, time: DateTime.now().millisecondsSinceEpoch, isMyMsg: isMyMsg, isImage: isImage);
    final newChats = [...this.chats, chat];
    this._dto = ContactDto(this.firstName, this.lastName, this.phone, this.profilePicture, newChats);
    this._eventAggregator.publish(MessageSentEvent(this));
    await this._userService.updateStorage();
  }

  factory ContactProxy.fromJson(Map<String, dynamic> json) => ContactProxy(ContactDto.fromJson(json));
}
