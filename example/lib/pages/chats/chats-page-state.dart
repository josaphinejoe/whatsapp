import 'package:example/events/message-sent-event.dart';
import 'package:example/pages/chats/chats-page.dart';
import 'package:example/sdk/models/contact.dart';
import 'package:example/sdk/models/message-info.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/contacts-service/contacts-service.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatsPageState extends WidgetStateBase<ChatsPage> {
  final _contactService = ServiceLocator.instance.resolve<ContactService>();
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();
  final TextEditingController _messageController = TextEditingController();

  final String _phone;
  late Contact _contact;
  late User _user;

  bool _isReady = false;

  bool get isReady => this._isReady;
  set isReady(bool value) => (this.._isReady = value).triggerStateChange();

  TextEditingController get messageController => this._messageController;
  Contact get contact => this._contact;
  List<MessageInfo> get chats => this._contact.chats.reversed.toList();

  ChatsPageState(this._phone) : super() {
    this.onInitState(() async {
      await this._loadContact();
      await this._loadUser();
      this.triggerStateChange();
      this.isReady = true;
    });

    this.watch<MessageSentEvent>(this._eventAggregator.subscribe<MessageSentEvent>(), (event) async {
      await this._loadContact();
    });
  }

  String getFormattedTime(int time) {
    DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(time);
    String amPm = messageTime.hour < 12 ? 'AM' : 'PM';
    int formattedHour = messageTime.hour % 12 == 0 ? 12 : messageTime.hour % 12;
    return '$formattedHour:${messageTime.minute.toString().padLeft(2, '0')} $amPm';
  }

  String getFormattedDate(int time) {
    DateTime now = DateTime.now();
    DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(time);

    if (now.year == messageTime.year && now.month == messageTime.month && now.day == messageTime.day) {
      return "Today";
    } else if (now.year == messageTime.year && now.month == messageTime.month && now.day == messageTime.day - 1) {
      return "Yesterday";
    } else {
      return '${messageTime.day}/${messageTime.month}/${messageTime.year}';
    }
  }

  void handleSendMessage() async {
    String message = this.messageController.text.trim();
    if (message.isNotEmpty) {
      this._user.sendMessage(this._phone, message);
      this.messageController.clear();
      this.triggerStateChange();
    }
  }

  void goBack() {
    this._navigator.pop();
  }

  bool isFirstMsgOfDay(index, time) {
    if (index == this.chats.length - 1)
      return true;
    else if (this.getFormattedDate(this.chats[index + 1].time) != time) return true;
    return false;
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        this._user.sendImage(this._phone, pickedFile.path);
        this.triggerStateChange();
      }
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  Future<void> _loadContact() async {
    this.showLoading();
    try {
      this._contact = await this._contactService.getContact(this._phone);
    } catch (e) {
      return;
    } finally {
      this.hideLoading();
    }
  }

  Future<void> _loadUser() async {
    this.showLoading();
    try {
      this._user = await this._userService.getAuthenticatedUser();
    } catch (e) {
      return;
    } finally {
      this.hideLoading();
    }
  }
}
