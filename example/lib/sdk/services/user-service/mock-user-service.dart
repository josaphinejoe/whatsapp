import 'dart:convert';

import 'package:example/sdk/models/message-info.dart';
import 'package:example/sdk/proxies/contact/contact-dto.dart';
import 'package:example/sdk/proxies/contact/contact-proxy.dart';
import 'package:example/sdk/proxies/contact/contact.dart';
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

    final mockContactList = this._mockContactList();
    final userDto = UserDto(firstName, lastName, null, phone, mockContactList);
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

  Future<void> loadUser() async {
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

  List<Contact> _mockContactList() {
    final contacts = <Contact>[];

    final annaContact = ContactProxy(
      ContactDto(
        'anna',
        'Jose',
        "9947367459",
        "https://miro.medium.com/v2/resize:fit:800/1*avN_YJhMr_MJZ48a-RbZzw.jpeg",
        [],
      ),
    );

    annaContact.chats.add(
      MessageInfo(
        message: 'send me 2k',
        time: 1702009124942,
        isMyMsg: false,
      ),
    );
    annaContact.chats.add(
      MessageInfo(
        message: 'ok',
        time: 1702009124942,
        isMyMsg: true,
      ),
    );
    contacts.add(annaContact);

    final johnlyContact = ContactProxy(
      ContactDto(
        'Johnly',
        'Jose',
        "9123456789",
        "https://mastimorning.com/wp-content/uploads/2023/07/Download-hd-girls-whatsapp-dp-Pics-images-Download.jpg",
        [],
      ),
    );

    johnlyContact.chats.add(
      MessageInfo(
        message: 'Hello Johnly, How is the flood? Hope you are safe',
        time: 1701943200000,
        isMyMsg: true,
      ),
    );
    johnlyContact.chats.add(
      MessageInfo(
        message: 'I am safe only, still pouring outside.',
        time: 1701946800000,
        isMyMsg: false,
      ),
    );
    johnlyContact.chats.add(
      MessageInfo(
        message: 'so WFH only right?',
        time: 1701946800000,
        isMyMsg: true,
      ),
    );
    contacts.add(johnlyContact);

    final meghanContact = ContactProxy(
      ContactDto(
        'Meghana',
        'Dhaware',
        "9876543210",
        "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/d4af53c8-66ff-403f-bf37-92c23c3e540c/dfb4k01-be3fbe9c-7814-41d8-89d9-522af3d9c123.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2Q0YWY1M2M4LTY2ZmYtNDAzZi1iZjM3LTkyYzIzYzNlNTQwY1wvZGZiNGswMS1iZTNmYmU5Yy03ODE0LTQxZDgtODlkOS01MjJhZjNkOWMxMjMuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.W0s7AfSUNUfNcyFMf4Tw7l-II9_sIXfYfJl3siRrBvc",
        [],
      ),
    );

    meghanContact.chats.add(
      MessageInfo(
        message: 'Hi Meghana, Happy Birthday',
        time: 1701936000000,
        isMyMsg: true,
      ),
    );
    meghanContact.chats.add(
      MessageInfo(
        message: 'Thank you very much Irene',
        time: 1701940815000,
        isMyMsg: false,
      ),
    );
    contacts.add(meghanContact);

    final roseContact = ContactProxy(
      ContactDto(
        'Rose',
        'Mary',
        "98765432345",
        "https://mastimorning.com/wp-content/uploads/2023/07/Best-HD-girls-whatsapp-dp-Pics-Images-2023.jpg",
        [],
      ),
    );

    roseContact.chats.add(
      MessageInfo(
        message: 'Hi Irene',
        time: 1702006038985,
        isMyMsg: false,
      ),
    );
    roseContact.chats.add(
      MessageInfo(
        message: 'Hi Rose',
        time: 1702006038985,
        isMyMsg: true,
      ),
    );
    contacts.add(roseContact);

    return contacts;
  }
}
