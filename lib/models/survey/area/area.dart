import 'package:json_annotation/json_annotation.dart';
part 'area.g.dart';

@JsonSerializable()
class AreaModel {
  int id;

  @JsonKey(name: 'question_id')
  int questionId;

  String language;

  String title;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  List<OptionArea> options;

  AreaModel({
    required this.id,
    required this.questionId,
    required this.language,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.options,
  });

  factory AreaModel.fromJson(Map<String, dynamic> json) =>
      _$AreaModelFromJson(json);

  Map<String, dynamic> toJson() => _$AreaModelToJson(this);
}

@JsonSerializable()
class OptionArea {
  OptionArea({
    required this.id,
    required this.text,
  });

  int id;

  String? text;

  factory OptionArea.fromJson(Map<String, dynamic> json) =>
      _$OptionAreaFromJson(json);

  Map<String, dynamic> toJson() => _$OptionAreaToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
