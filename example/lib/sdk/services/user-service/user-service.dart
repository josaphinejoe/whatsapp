import 'package:example/sdk/models/user-status.dart';
import 'package:example/sdk/proxies/user/user-dto.dart';
import 'package:example/sdk/proxies/user/user.dart';

abstract class UserService
{
Future<void> createUser(String firstName,String? lastName, String phone, String password );
 Future<User> getUser();
 Future<void> updateUser(UserDto user);
 Future<UserStatus> getUserStatus();
 Future<User> authenticate(String phone, String password);
 Future<void> logout();
 Future<void> clearUser(); // for testing purpose only
}