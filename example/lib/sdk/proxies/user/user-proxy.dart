import 'dart:io';

import 'package:example/sdk/proxies/user/user-dto.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/contacts-service/contacts-service.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';

class UserProxy implements User {
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _contactService = ServiceLocator.instance.resolve<ContactService>();

  UserDto _dto;

  UserProxy(this._dto);

  @override
  String get firstName => this._dto.firstName;

  @override
  String? get lastName => this._dto.lastName;

  @override
  File? get profilePicture => this._dto.profilePicture;

  @override
  String get phone => this._dto.phone;

  @override
  Future<void> addContact(String firstName, String phone, String? lastName) async {
    given(firstName, "firstName").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(phone, "phone").ensure((t) => t.isNotEmptyOrWhiteSpace);

    await this._contactService.addContact(firstName, phone, lastName);
  }

  @override
  Future<void> sendMessage(String receiverPhone, String msg) async {
    given(receiverPhone, "receiverPhone").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(msg, "msg").ensure((t) => t.isNotEmptyOrWhiteSpace);

    await this._contactService.sendMessage(receiverPhone, msg, false);
  }

  @override
  Future<void> sendImage(String receiverPhone, String filePath) async {
    given(receiverPhone, "receiverPhone").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(filePath, "filePath").ensure((t) => t.isNotEmptyOrWhiteSpace);

    await this._contactService.sendMessage(receiverPhone, filePath, true);
  }

  @override
  Future<void> changeName(String firstName, String? lastName) async {
    given(firstName, "firstName").ensure((t) => t.isNotEmptyOrWhiteSpace);

    final newUser = UserDto(firstName, lastName, this.profilePicture, this.phone);
    await this._userService.updateUser(newUser);
  }

  @override
  Future<void> changeProfilePicture(File profilePicture) async {
    final newUser = UserDto(this.firstName, this.lastName, profilePicture, this.phone);
    await this._userService.updateUser(newUser);
  }

  factory UserProxy.fromJson(Map<String, dynamic> json) => UserProxy(UserDto.fromJson(json));
}
