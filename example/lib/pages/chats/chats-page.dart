import 'dart:io';

import 'package:example/pages/chats/chats-page-state.dart';
import 'package:example/sdk/models/message-info.dart';
import 'package:example/sdk/proxies/contact/contact.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChatsPage extends StatefulWidgetBase<ChatsPageState> {
  ChatsPage(String phone) : super(() => ChatsPageState(phone));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ChatsAppBar(
        contact: this.state.contact,
        goBack: this.state.goBack,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Image.network(
              "https://i.pinimg.com/736x/8c/98/99/8c98994518b575bfd8c949e91d20548b.jpg",
              fit: BoxFit.cover,
              height: double.infinity,
            ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: this.state.chats.length,
                      itemBuilder: (context, index) {
                        final message = this.state.chats[index];
                        final formattedDate = this.state.getFormattedDate(message.time);
                        final isFirstMsgOfDay = this.state.isFirstMsgOfDay(index, formattedDate);
                        return _Chat(
                          isFirstMsgOfDay: isFirstMsgOfDay,
                          formattedDate: formattedDate,
                          message: message,
                          getFormattedTime: this.state.getFormattedTime,
                        );
                      },
                    ),
                  ),
                ),
                _UserInput(
                  handleSendMessage: this.state.sendMessage,
                  messageController: this.state.messageController,
                  sendImage: this.state.sendImage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserInput extends StatelessWidget {
  final VoidCallback handleSendMessage;
  final TextEditingController messageController;
  final VoidCallback sendImage;

  const _UserInput({
    required this.handleSendMessage,
    required this.messageController,
    required this.sendImage,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: this.messageController,
              style: TextStyle(
                color: Colors.black54,
              ),
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.black54,
                ),
                hintText: "Message",
                prefixIcon: Icon(Icons.emoji_emotions),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                suffixIcon: IconButton(
                  onPressed: this.sendImage,
                  icon: Icon(
                    Icons.image,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: const Color(0xFF387463),
              ),
              child: IconButton(
                onPressed: () => this.handleSendMessage(),
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chat extends StatelessWidget {
  const _Chat({
    required this.isFirstMsgOfDay,
    required this.formattedDate,
    required this.message,
    required this.getFormattedTime,
  }) : super();

  final bool isFirstMsgOfDay;
  final String formattedDate;
  final MessageInfo message;
  final String Function(int) getFormattedTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isFirstMsgOfDay)
          _DayRepresentation(
            formattedDate: formattedDate,
          ),
        Padding(
          padding: EdgeInsets.all(5.0),
          child: ChatBubble(
            clipper: ChatBubbleClipper1(
              type: message.isMyMsg ? BubbleType.sendBubble : BubbleType.receiverBubble,
            ),
            alignment: message.isMyMsg ? Alignment.topRight : Alignment.topLeft,
            backGroundColor: message.isMyMsg ? const Color.fromARGB(255, 217, 248, 178) : Colors.white,
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 80.0,
                maxWidth: 300.0,
              ),
              child: message.isImage
                  ? _ImageMessage(
                      message: message,
                      getFormattedTime: getFormattedTime,
                    )
                  : _TextMessage(
                      message: message,
                      getFormattedTime: getFormattedTime,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TextMessage extends StatelessWidget {
  const _TextMessage({
    required this.message,
    required this.getFormattedTime,
  }) : super();

  final MessageInfo message;
  final String Function(int p1) getFormattedTime;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                message.message,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Text(
              this.getFormattedTime(message.time),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageMessage extends StatelessWidget {
  const _ImageMessage({
    required this.message,
    required this.getFormattedTime,
  }) : super();

  final MessageInfo message;
  final String Function(int p1) getFormattedTime;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (message.message.startsWith('http'))
          Image.network(
            message.message,
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          )
        else
          Image.file(
            File(message.message),
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ),
        Positioned(
          bottom: 8.0,
          right: 8.0,
          child: Text(
            this.getFormattedTime(message.time),
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

class _DayRepresentation extends StatelessWidget {
  const _DayRepresentation({
    required this.formattedDate,
  }) : super();

  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white70,
        ),
        child: Text(
          formattedDate,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ChatsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ChatsAppBar({
    required this.contact,
    required this.goBack,
  }) : super();

  final Contact contact;
  final VoidCallback goBack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '${this.contact.firstName} ${this.contact.lastName ?? ''}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      leading: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => this.goBack(),
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
              this.contact.profilePicture ??
                  "https://cdn4.iconfinder.com/data/icons/business-and-office-29/512/396-_profile__avatar__image__dp_-512.png",
            ),
          ),
        ],
      ),
      leadingWidth: 88.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
