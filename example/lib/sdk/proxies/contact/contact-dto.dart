import 'package:example/sdk/models/message-info.dart';
import 'package:example/sdk/proxies/contact/contact-proxy.dart';
import 'package:example/sdk/proxies/contact/contact.dart';
import 'package:json_annotation/json_annotation.dart';

part 'contact-dto.g.dart';

@JsonSerializable()
class ContactDto {
  String firstName;
  String? lastName;

  final String phone;

  String? profilePicture;
  List<MessageInfo> chats;

  ContactDto(this.firstName, this.lastName, this.phone, this.profilePicture, this.chats);

  factory ContactDto.fromJson(Map<String, dynamic> json) => _$ContactDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ContactDtoToJson(this);

  ContactDto.fromContact(Contact contact)
      : firstName = contact.firstName,
        lastName = contact.lastName,
        phone = contact.phone,
        profilePicture = contact.profilePicture,
        chats = List.from(contact.chats.map((chat) => MessageInfo.fromJson(chat.toJson())));

  Contact toContact() {
    return ContactProxy(this);
  }
}
