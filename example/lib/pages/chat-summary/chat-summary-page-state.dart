import 'package:example/events/message-sent-event.dart';
import 'package:example/pages/chat-summary/chat-summary-page.dart';
import 'package:example/pages/routes.dart';
import 'package:example/sdk/models/chat.dart';
import 'package:example/sdk/services/contacts-service/contacts-service.dart';
import 'package:floater/floater.dart';

class ChatSummaryPageState extends WidgetStateBase<ChatSummaryPage>{
  final _contactService = ServiceLocator.instance.resolve<ContactService>();
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");

  late List<Chat> _chatList = [];

  List<Chat> get chatList => this._chatList;


  ChatSummaryPageState() : super()
  {
    this.onInitState(() async 
    {
      await this._loadChatList();
    });

    this.watch<MessageSentEvent>(this._eventAggregator.subscribe<MessageSentEvent>(),(event) async
    {
      await this._loadChatList();
    });
  }


  String getFormattedDateTime(int time) 
  {
      DateTime now = DateTime.now();
      DateTime messageTime = DateTime.fromMillisecondsSinceEpoch(time);

      if (now.year == messageTime.year && now.month == messageTime.month && now.day == messageTime.day) 
      {
        String amPm = messageTime.hour < 12 ? 'AM' : 'PM';
        int formattedHour = messageTime.hour % 12 == 0 ? 12 : messageTime.hour % 12;
        return '$formattedHour:${messageTime.minute.toString().padLeft(2, '0')} $amPm';
      } 
      else 
      {
        return '${messageTime.month}/${messageTime.day}/${messageTime.year}';
      }
    }


  Future<void> onTapChat(Chat chat) async 
  {
    this._navigator.pushNamed(
      NavigationService.instance.generateRoute(Routes.chats)
      ,arguments: {"phone": chat.phone});
  }


    Future<void> _loadChatList() async 
    {
      this.showLoading();
      try 
      {
        this._chatList = await this._contactService.getChatList();
      } 
      catch (e) 
      {
        return;
      } 
      finally 
      {
        this.hideLoading();
      }
    }
}