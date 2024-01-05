import 'package:example/events/message-sent-event.dart';
import 'package:example/pages/chat-summary/chat-summary-page.dart';
import 'package:example/pages/routes.dart';
import 'package:example/sdk/models/chat.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:example/utilities/helper.dart';
import 'package:floater/floater.dart';

class ChatSummaryPageState extends WidgetStateBase<ChatSummaryPage> {
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");

  late List<Chat> _chatList = [];

  List<Chat> get chatList => this._chatList;

  ChatSummaryPageState() : super() {
    this._loadChatList();

    this.watch<MessageSentEvent>(this._eventAggregator.subscribe<MessageSentEvent>(), (event) {
      this._loadChatList();
    });
  }

  String getFormattedDateTime(int time) {
    return Helper.formatDateTime(time);
  }

  Future<void> onTapChat(Chat chat) async {
    await this
        ._navigator
        .pushNamed(NavigationService.instance.generateRoute(Routes.chats), arguments: {"phone": chat.phone});
  }

  void _loadChatList() {
    final user = this._userService.authenticatedUser;
    this._chatList = user.getChatSummary();
  }
}
