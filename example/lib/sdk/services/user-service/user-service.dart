import 'package:example/sdk/proxies/user/user.dart';

abstract class UserService {
  User get authenticatedUser;
  bool get isAuthenticated;

  Future<void> createUser(String firstName, String? lastName, String phone, String password);

  Future<User> authenticate(String phone, String password);
  Future<void> updateStorage();
  Future<void> logout();
  Future<void> loadUserStorage();
}
