import 'dart:io';
import 'package:json_annotation/json_annotation.dart';

part 'user-dto.g.dart';

@JsonSerializable()
class UserDto {
  String firstName;
  String? lastName;

  @FileConverter()
  File? profilePicture;

  final String phone;

  UserDto(this.firstName, this.lastName, this.profilePicture, this.phone);

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

class FileConverter implements JsonConverter<File?, String?> {
  const FileConverter();

  @override
  File? fromJson(String? json) {
    return json != null ? File(json) : null;
  }

  @override
  String? toJson(File? file) {
    return file?.path;
  }
}
