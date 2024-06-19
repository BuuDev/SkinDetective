import 'package:json_annotation/json_annotation.dart';
part 'change_pass.g.dart';

@JsonSerializable()
class ChangePass {
  bool success;
  String message;

  ChangePass({required this.success, required this.message});

  factory ChangePass.fromJson(Map<String, dynamic> json) =>
      _$ChangePassFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePassToJson(this);
}
