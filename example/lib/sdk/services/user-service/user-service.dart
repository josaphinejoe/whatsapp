import 'package:example/sdk/proxies/user/user-dto.dart';
import 'package:example/sdk/proxies/user/user.dart';

abstract class UserService {
  Future<void> createUser(String firstName, String? lastName, String phone, String password);
  Future<User> getAuthenticatedUser();
  Future<void> updateUser(UserDto user);
  Future<bool> isUserExist();
  Future<bool> isAuthenticated();
  Future<User> authenticate(String phone, String password);
  Future<void> logout();
  Future<void> clearUser(); // for testing purpose only
}
