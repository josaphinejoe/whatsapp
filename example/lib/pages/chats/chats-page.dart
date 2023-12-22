import 'dart:io';

import 'package:example/pages/chats/chats-page-state.dart';
import 'package:example/sdk/models/message-info.dart';
import 'package:example/widgets/loading_spinner/loading_spinner.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';

class ChatsPage extends StatefulWidgetBase<ChatsPageState>
{
  ChatsPage(String phone) : super(() => ChatsPageState(phone));

  @override
  Widget build(BuildContext context){
    return this.state.isReady? 
    Scaffold(
      appBar: AppBar(
        title:Text('${this.state.contact.firstName} ${this.state.contact.lastName??''}',style: const TextStyle(color: Colors.white,fontSize: 25),),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: false,
        leading: Row(
          children: [
            IconButton(icon:const Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: ()=> this.state.goBack()),
            CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(this.state.contact.displayPicture??"https://cdn4.iconfinder.com/data/icons/business-and-office-29/512/396-_profile__avatar__image__dp_-512.png"),
              ),
          ],
        ),
        leadingWidth: 88.0,
        
      ),
      backgroundColor: const Color.fromARGB(255, 220, 215, 215),
      body: SafeArea(child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                reverse: true,
                  itemCount: this.state.chats.length,
                  itemBuilder: (context, index) {
                    MessageInfo message = this.state.chats[index];
                    String formattedDate = this.state.getFormattedDate(message.time);
                    bool isFirstMsgOfDay = this.state.isFirstMsgOfDay(index,formattedDate);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if(isFirstMsgOfDay)
                        Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          formattedDate,
                          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                        ),),
                        Padding(
                          padding:EdgeInsets.only(left:message.isMyMsg?50.0:8.0, right: message.isMyMsg?8.0:50.0, top: 8.0,bottom:8.0),
                          child: Align(
                            alignment: message.isMyMsg?Alignment.centerRight:Alignment.centerLeft,
                            child:Container(
                              constraints: const BoxConstraints(
                                minWidth: 80.0,
                                maxWidth: 300.0
                              ),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: message.isMyMsg?const Color.fromARGB(255, 217, 248, 178):Colors.white,
                                borderRadius: BorderRadius.circular(12.0)
                              ),
                              child: message.isImage?
                              Stack(
                                children: [
                                  if(message.message.startsWith('http'))
                                    Image.network(
                                      message.message,
                                      width: 250,
                                      height:250,
                                      fit:BoxFit.cover
                                    )
                                  else
                                    Image.file(
                                      File(message.message),
                                      width: 250,
                                      height: 250,
                                      fit: BoxFit.cover,
                                    ),
                                  Positioned(bottom: 8.0,
                                    right: 8.0,
                                    child: Text(
                                    this.state.getFormattedTime(message.time),
                                    style: const TextStyle(color: Colors.grey),
                                  ))
                                ],
                              )
                               :IntrinsicWidth(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                      Expanded(child: Text(message.message, style: const TextStyle(color: Colors.black87),)),
                                    const SizedBox(width:8.0),
                                    Text(this.state.getFormattedTime(message.time),style: const TextStyle(color: Colors.grey),)
                                  ],
                                ),
                              ),
                            )
                            )
                          ),
                      ],
                    );
                  },
                ),
            ),
          ),
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: this.state.messageController,
                    style: TextStyle(color: Colors.black54),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.black54),
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18.0)
                      ),
                      suffixIcon: IconButton(onPressed: this.state.sendImage, icon: Icon(Icons.image, color:Colors.grey[800]))
                    ),
                  )),
                  IconButton(
                    onPressed: ()=> this.state.handleSendMessage(),
                     icon: const Icon(
                      Icons.send,
                      color: const Color(0xFF387463),
                     ))
              ],
            ),
          ),
        ],
      )),
    )
    :this._buildLoadingScreen();
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      body: Container(
        child: SizedBox.expand(
          child: Container(
            alignment: Alignment.center,
            child: LoadingSpinner(),
          ),
        ),
      ),
    );
  }
}