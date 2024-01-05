import 'dart:convert';

import 'package:example/sdk/proxies/user/user-credentials.dart';
import 'package:example/sdk/proxies/user/user-proxy.dart';
import 'package:example/sdk/proxies/user/user-dto.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockUserService implements UserService {
  final FlutterSecureStorage _userStorage = FlutterSecureStorage();
  final String _storageKey = "userCredentials";

  List<UserCredentials> _userCredentialList = [];
  User? _user;
  String? _password;
  bool _isAuthenticated = false;

  User get authenticatedUser => this._user!;
  bool get isAuthenticated => this._isAuthenticated;

  @override
  Future<void> createUser(String firstName, String? lastName, String phone, String password) async {
    given(firstName, "firstName").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(phone, "phone").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(password, "password").ensure((t) => t.isNotEmptyOrWhiteSpace);

    if (this._userCredentialList.any((t) => t.user.phone == phone)) {
      throw Exception("User with the same phone number already exists");
    }

    final userDto = UserDto(firstName, lastName, null, phone, []);
    final userCredentials = UserCredentials(userDto, password, false);
    this._userCredentialList.add(userCredentials);

    await this._userStorage.write(
          key: this._storageKey,
          value: json.encode(this._userCredentialList.map((t) => t.toJson()).toList()),
        );
  }

  Future<User> authenticate(String phone, String password) async {
    given(phone, "phone").ensure((t) => t.isNotEmptyOrWhiteSpace);
    given(password, "password").ensure((t) => t.isNotEmptyOrWhiteSpace);

    final userCredentials = this._userCredentialList.firstWhere(
          (t) => t.user.phone == phone && t.password == password,
          orElse: () => throw Exception("Authentication failed."),
        );

    this._user = UserProxy(userCredentials.user);
    this._password = userCredentials.password;
    this._isAuthenticated = true;
    await this.updateStorage();
    return this._user!;
  }

  Future<void> logout() async {
    this._isAuthenticated = false;
    await this.updateStorage();
    this._user = null;
    this._password = null;
  }

  Future<void> updateStorage() async {
    final userDto = UserDto(
      this._user!.firstName,
      this._user!.lastName,
      this._user!.profilePicture,
      this._user!.phone,
      this._user!.contactList,
    );

    final userCredentials = UserCredentials(userDto, this._password!, this._isAuthenticated);

    final index = this._userCredentialList.indexWhere((t) => t.user.phone == _user!.phone);

    if (index != -1) {
      this._userCredentialList[index] = userCredentials;
    } else {
      throw Exception("User not found in user credentials list.");
    }

    await this._userStorage.write(
          key: this._storageKey,
          value: json.encode(this._userCredentialList.map((t) => t.toJson()).toList()),
        );
  }

  Future<void> loadUserStorage() async {
    final storedUser = await this._userStorage.read(key: this._storageKey);
    if (storedUser != null) {
      final List<dynamic> userCredentialsJsonList = json.decode(storedUser);
      this._userCredentialList = userCredentialsJsonList.map((json) => UserCredentials.fromJson(json)).toList();

      final loggedUser = this._userCredentialList.find((t) => t.isAuthenticated == true) ?? null;
      if (loggedUser != null) {
        this._user = UserProxy(loggedUser.user);
        this._isAuthenticated = true;
        this._password = loggedUser.password;
      }
    }
  }
}
