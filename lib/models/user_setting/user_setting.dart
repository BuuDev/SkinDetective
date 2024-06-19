import 'package:json_annotation/json_annotation.dart';
part 'user_setting.g.dart';

@JsonSerializable()
class UserSetting {
  int id;
  @JsonKey(name: "user_id")
  int userId;
  @JsonKey(name: "new_category")
  bool newCategory;
  @JsonKey(name: "your_writing")
  bool yourWriting;
  String language;

  UserSetting(
      {required this.id,
      required this.userId,
      required this.newCategory,
      required this.yourWriting,
      required this.language});

  factory UserSetting.fromJson(Map<String, dynamic> json) =>
      _$UserSettingFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingToJson(this);
}
