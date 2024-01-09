import 'package:example/sdk/proxies/user/user-dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user-credentials.g.dart';

@JsonSerializable()
class UserCredentials {
  final UserDto user;
  final String password;
  final bool isAuthenticated;

  UserCredentials(this.user, this.password, this.isAuthenticated);

  factory UserCredentials.fromJson(Map<String, dynamic> json) => _$UserCredentialsFromJson(json);

  Map<String, dynamic> toJson() => _$UserCredentialsToJson(this);
}
