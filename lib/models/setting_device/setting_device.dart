import 'package:json_annotation/json_annotation.dart';
part 'setting_device.g.dart';

@JsonSerializable()
class SettingDevice {
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'new_category')
  bool newCategory;
  @JsonKey(name: 'your_writing')
  bool yourWriting;
  String language;
  bool direction;
  SettingDevice(
      {required this.id,
      required this.userId,
      required this.newCategory,
      required this.direction,
      required this.language,
      required this.yourWriting});

  factory SettingDevice.fromJson(Map<String, dynamic> json) =>
      _$SettingDeviceFromJson(json);

  Map<String, dynamic> toJson() => _$SettingDeviceToJson(this);
}
