import 'dart:io';
import 'package:example/sdk/proxies/contact/contact-dto.dart';
import 'package:example/sdk/proxies/contact/contact.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user-dto.g.dart';

@JsonSerializable()
class UserDto {
  String firstName;
  String? lastName;

  @FileConverter()
  File? profilePicture;

  final String phone;

  @ContactListConverter()
  List<Contact> contactList;

  UserDto(this.firstName, this.lastName, this.profilePicture, this.phone, this.contactList);

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return _$UserDtoFromJson(json);
  }
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

class FileConverter implements JsonConverter<File?, String?> {
  const FileConverter();

  @override
  File? fromJson(String? json) {
    return json != null ? File(json) : null;
  }

  @override
  String? toJson(File? file) {
    return file?.path;
  }
}

class ContactListConverter implements JsonConverter<List<Contact>, List<dynamic>> {
  const ContactListConverter();

  @override
  List<Contact> fromJson(List<dynamic> json) {
    return json.map((contactJson) {
      return ContactDto.fromJson(contactJson).toContact();
    }).toList();
  }

  @override
  List<Map<String, dynamic>> toJson(List<Contact> contacts) {
    return contacts.map((contact) => ContactDto.fromContact(contact).toJson()).toList();
  }
}
