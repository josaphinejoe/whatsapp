import 'package:example/pages/chat-summary/chat-summary-page-state.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class ChatSummaryPage extends StatefulWidgetBase<ChatSummaryPageState> {
  ChatSummaryPage() : super(() => ChatSummaryPageState());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: this.state.chatList.length,
          itemBuilder: (ctx, index) {
            final chat = this.state.chatList[index];
            return Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
              ),
              child: ListTile(
                title: Text(
                  '${chat.firstName} ${chat.lastName ?? ""}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () => this.state.onTapChat(chat),
                subtitle: Text(
                  chat.messageInfo.isImage ? "Photo" : chat.messageInfo.message,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(chat.profilePicture ??
                      "https://cdn4.iconfinder.com/data/icons/business-and-office-29/512/396-_profile__avatar__image__dp_-512.png"),
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
                trailing: Text(this.state.getFormattedDateTime(chat.messageInfo.time)),
              ),
            );
          },
        ),
      ),
    );
  }
}
