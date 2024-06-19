import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/user/user.dart';
part 'user_info.g.dart';

@JsonSerializable()
class UserInfo {
  @JsonKey(name: 'access_token')
  String? accessToken;

  @JsonKey(name: 'token_type')
  String? tokenType;

  @JsonKey(name: 'expires_in')
  int? expiresIn;

  @JsonKey(name: 'user')
  User user;

  UserInfo({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.user,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
