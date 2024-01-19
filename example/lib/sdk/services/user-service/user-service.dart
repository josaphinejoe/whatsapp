import 'package:example/sdk/proxies/user/user.dart';

abstract class UserService {
  User get authenticatedUser;
  bool get isAuthenticated;

  Future<void> createUser(String firstName, String? lastName, String phone, String password);

  Future<User> authenticate(String phone, String password);
  Future<void> logout();

  Future<void> updateStorage(); // in order to persist changes
  Future<void> loadUser();
}
