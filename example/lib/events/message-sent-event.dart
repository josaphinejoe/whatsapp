import 'package:example/sdk/models/contact.dart';

class MessageSentEvent {
  final Contact contact;
  
  MessageSentEvent(this.contact);
}