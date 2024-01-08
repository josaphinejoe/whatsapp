import 'dart:io';

import 'package:example/pages/routes.dart';
import 'package:example/pages/user/user-page.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/file-service/file-service.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPageState extends WidgetStateBase<UserPage> {
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _fileService = ServiceLocator.instance.resolve<FileService>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");

  late User _user;
  late String _firstName;
  late String? _lastName;
  late File? _profilePicture;

  String get phone => this._user.phone;

  String get firstName => this._firstName;
  set firstName(String value) => (this.._firstName = value).triggerStateChange();

  String? get lastName => this._lastName;
  set lastName(String? value) => (this.._lastName = value).triggerStateChange();

  File? get profilePicture => this._profilePicture;
  set profilePicture(File? value) => (this.._profilePicture = value).triggerStateChange();

  UserPageState() : super() {
    this._user = this._userService.authenticatedUser;
    this._profilePicture = this._user.profilePicture;
    this._firstName = this._user.firstName;
    this._lastName = this._user.lastName;
  }

  Future<void> saveFirstName() async {
    if (this._firstName.isEmptyOrWhiteSpace) return;
    try {
      await this._user.changeName(this.firstName, this._user.lastName);
      this.triggerStateChange();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> saveLastName() async {
    if (this.lastName != null && this.lastName!.isEmptyOrWhiteSpace) this.lastName = null;

    try {
      await this._user.changeName(this._user.firstName, this.lastName);
      this.triggerStateChange();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void goBack() {
    this._navigator.pop();
  }

  Future<void> editProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final permanentFile =
          await this._fileService.moveFileToPermanentLocation(File(pickedFile.path), "profilePicture");
      this._profilePicture = permanentFile;
      await this._user.changeProfilePicture(permanentFile);
      this.triggerStateChange();
    }
  }

  ImageProvider<Object>? getImage() {
    if (this.profilePicture != null) {
      return FileImage(this.profilePicture!);
    } else {
      return null;
    }
  }

  void goToSettings() {
    this._navigator.pushNamed(Routes.settings);
  }
}
