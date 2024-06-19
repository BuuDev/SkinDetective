import 'package:json_annotation/json_annotation.dart';
part 'levels.g.dart';

@JsonSerializable()
class Levels {
  int value;
  String? text;

  Levels({required this.value, required this.text});

  factory Levels.fromJson(Map<String, dynamic> json) => _$LevelsFromJson(json);

  Map<String, dynamic> toJson() => _$LevelsToJson(this);
}
