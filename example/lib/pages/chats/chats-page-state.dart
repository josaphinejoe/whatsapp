import 'package:example/events/message-sent-event.dart';
import 'package:example/pages/chats/chats-page.dart';
import 'package:example/sdk/models/message-info.dart';
import 'package:example/sdk/proxies/contact/contact.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatsPageState extends WidgetStateBase<ChatsPage> {
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();
  final TextEditingController _messageController = TextEditingController();

  final String _phone;
  late Contact _contact;

  bool _isReady = false;

  bool get isReady => this._isReady;
  set isReady(bool value) => (this.._isReady = value).triggerStateChange();

  TextEditingController get messageController => this._messageController;
  Contact get contact => this._contact;
  List<MessageInfo> get chats => this._contact.chats.reversed.toList();

  ChatsPageState(this._phone) : super() {
    this.onInitState(() {
      this._loadContact();
      this.triggerStateChange();
      this.isReady = true;
    });

    this.watch<MessageSentEvent>(this._eventAggregator.subscribe<MessageSentEvent>(), (event) {
      this._loadContact();
    });
  }

  String getFormattedTime(int time) {
    final messageTime = DateTime.fromMillisecondsSinceEpoch(time);
    final amPm = messageTime.hour < 12 ? 'AM' : 'PM';
    final formattedHour = messageTime.hour % 12 == 0 ? 12 : messageTime.hour % 12;
    return '$formattedHour:${messageTime.minute.toString().padLeft(2, '0')} $amPm';
  }

  String getFormattedDate(int time) {
    final now = DateTime.now();
    final messageTime = DateTime.fromMillisecondsSinceEpoch(time);

    if (now.year == messageTime.year && now.month == messageTime.month && now.day == messageTime.day) {
      return "Today";
    } else if (now.year == messageTime.year && now.month == messageTime.month && now.day == messageTime.day - 1) {
      return "Yesterday";
    } else {
      return '${messageTime.day}/${messageTime.month}/${messageTime.year}';
    }
  }

  Future<void> handleSendMessage() async {
    final message = this.messageController.text.trim();
    if (message.isNotEmpty) {
      await this._contact.sendMessage(this._phone, message);
      this.messageController.clear();
      this.triggerStateChange();
    }
  }

  void goBack() {
    this._navigator.pop();
  }

  bool isFirstMsgOfDay(index, time) {
    if (index == this.chats.length - 1) {
      return true;
    } else if (this.getFormattedDate(this.chats[index + 1].time) != time) {
      return true;
    }
    return false;
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        await this._contact.sendImage(this._phone, pickedFile.path);
        this.triggerStateChange();
      }
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }

  void _loadContact() {
    this.showLoading();
    try {
      final user = this._userService.authenticatedUser;
      this._contact = user.contactList.firstWhere((element) => element.phone == this._phone);
    } catch (e) {
      return;
    } finally {
      this.hideLoading();
    }
  }
}
