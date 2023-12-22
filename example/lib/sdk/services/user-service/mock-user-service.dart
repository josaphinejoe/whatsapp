import 'dart:convert';

import 'package:example/events/user-updated-event.dart';
import 'package:example/sdk/models/user-status.dart';
import 'package:example/sdk/proxies/user/user-credentials.dart';
import 'package:example/sdk/proxies/user/user-proxy.dart';
import 'package:example/sdk/proxies/user/user-dto.dart';
import 'package:example/sdk/proxies/user/user.dart';
import 'package:example/sdk/services/user-service/user-service.dart';
import 'package:floater/floater.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockUserService implements UserService
{
  final _eventAggregator = ServiceLocator.instance.resolve<EventAggregator>();
  final FlutterSecureStorage _userStorage = FlutterSecureStorage();
  final _storageKey = "user";

  User? _user;
  String? _password;
  bool _isAuthenticated =false;


  @override
  Future<void> createUser(String firstName,String? lastName, String phone, String password ) async {

    final userDto = UserDto(firstName, lastName, null, phone);
    this._user = UserProxy(userDto);
    this._password=password;

    final String? storedUser = await this._userStorage.read(key: this._storageKey);

    if(storedUser == null)
    {
      final userCredentials = UserCredentials(userDto, password,false);
      await this._userStorage.write(key: this._storageKey, value: json.encode(userCredentials.toJson()));
    }
  }

  @override
  Future<User> getUser() async{

    await this._loadUserCredentials();
    if(this._user!=null)
      return this._user!;
    else
      throw Exception("User not found");
  }

  Future<UserStatus> getUserStatus() async {
    await this._loadUserCredentials();

    if(this._isAuthenticated)
      return UserStatus.authenticated;
    return this._user!=null?UserStatus.created:UserStatus.notCreated;
  }


  @override
  Future<void> updateUser(UserDto userDto)async {
    
    this._user =UserProxy(userDto);
    this._eventAggregator.publish(UserUpdatedEvent(this._user!));

    final userCredentials = UserCredentials(userDto, this._password!, this._isAuthenticated);
    await this._userStorage.write(key: this._storageKey, value: json.encode(userCredentials.toJson()));
  }

  Future<User> authenticate(String phone, String password) async {

    await this._loadUserCredentials();

    if(this._user!=null)
      {
        if(this._user!.phone==phone && this._password == password){
          this._isAuthenticated=true;
          this._updateAuthentication(true);
          return this._user!;
        }
        else
          throw Exception("Authentication failed.");
        }
    else
        throw Exception("User not found");

    }

    Future<void> logout() async {
      this._isAuthenticated=false;
      await this._updateAuthentication(false);
    }

    Future<void> clearUser() async{
      await this._userStorage.delete(key: this._storageKey);
    }

    Future<void> _updateAuthentication(bool isAuthenticated) async{
      final userDto = UserDto(this._user!.firstName, this._user!.lastName, this._user!.displayPicture, this._user!.phone);

      final userCredentials = UserCredentials(userDto, this._password!, isAuthenticated);
      await this._userStorage.write(key: this._storageKey, value: json.encode(userCredentials.toJson()));
    }

    Future<void> _loadUserCredentials() async{
      if(this._user!=null)
        return;
      
      final String? storedUser = await this._userStorage.read(key: this._storageKey);

      if(storedUser!=null)
      {
        final Map<String, dynamic> userCredentialsJson = json.decode(storedUser);
        final userCredentials = UserCredentials.fromJson(userCredentialsJson);
        this._user = UserProxy(userCredentials.user);
        this._password=userCredentials.password;
        this._isAuthenticated=userCredentials.isAuthenticated;
      }
    }
}