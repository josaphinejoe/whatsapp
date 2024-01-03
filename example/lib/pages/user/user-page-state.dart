import 'dart:io';

import 'package:example/pages/routes.dart';
import 'package:example/pages/user/user-page.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserPageState extends WidgetStateBase<UserPage> {
  final _userService = ServiceLocator.instance.resolve<UserService>();
  final _navigator = NavigationService.instance.retrieveNavigator("/");

  late User _user;
  late String _firstName;
  late String? _lastName;
  late File? _profilePicture;

  bool _isReady = false;
  bool _isFirstNameEditable = false;
  bool _isLastNameEditable = false;

  bool get isReady => this._isReady;
  String get phone => this._user.phone;

  String get firstName => this._firstName;
  set firstName(String value) => (this.._firstName = value).triggerStateChange();

  String? get lastName => this._lastName;
  set lastName(String? value) => (this.._lastName = value).triggerStateChange();

  File? get profilePicture => this._profilePicture;
  set profilePicture(File? value) => (this.._profilePicture = value).triggerStateChange();

  bool get isFirstNameEditable => this._isFirstNameEditable;
  set isFirstNameEditable(bool val) => (this.._isFirstNameEditable = val).triggerStateChange();

  bool get isLastNameEditable => this._isLastNameEditable;
  set isLastNameEditable(bool val) => (this.._isLastNameEditable = val).triggerStateChange();

  UserPageState() : super() {
    this.onInitState(() async {
      this._user = await this._userService.getAuthenticatedUser();
      this._firstName = this._user.firstName;
      this._lastName = this._user.lastName;
      this._profilePicture = this._user.profilePicture;
      this._isReady = true;
      this.triggerStateChange();
    });
  }

  void saveFirstName() async {
    if (this._firstName.isEmptyOrWhiteSpace) return;
    try {
      await this._user.changeName(this.firstName, this._user.lastName);
      this.triggerStateChange();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void saveLastName() async {
    if (this.lastName != null && this.lastName!.isEmptyOrWhiteSpace) this.lastName = null;

    try {
      this._user.changeName(this._user.firstName, this.lastName);
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
      this._user.changeProfilePicture(File(pickedFile.path));
      this.profilePicture = File(pickedFile.path);
    }
  }

  ImageProvider<Object> getImage() {
    if (this.profilePicture != null) {
      return FileImage(this.profilePicture!);
    } else {
      return const NetworkImage(
          "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgPp7AelDxUJQ_t928VVlyIqM4sAMLIOsHyWkVgVRPzvFaUuJkNZG6U7DV8oYjIwpwzVKWwEGOFqQ_8jBTwiz8iDrR0GlQUVom65RMzoaLrYvNhVbwcFdgo2glP2lgp076Dvl6oNjrOuQp5oQstI1SCbVXITSPofI12AdM-KaB0rQBPAyRR5qpE-z8hDg/s16000-rw/blank-profile-picture-hd-images-photo-5.JPG");
    }
  }

  void goToSettings() {
    this._navigator.pushNamed(Routes.settings);
  }
}
