import 'package:json_annotation/json_annotation.dart';
part 'radio.g.dart';

@JsonSerializable()
class RadioModel {
  int id;

  @JsonKey(name: 'question_id')
  int questionId;

  String language;

  String title;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  List<OptionRadio> options;

  RadioModel({
    required this.id,
    required this.questionId,
    required this.language,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.options,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) =>
      _$RadioModelFromJson(json);

  Map<String, dynamic> toJson() => _$RadioModelToJson(this);
}

@JsonSerializable()
class OptionRadio {
  OptionRadio({
    required this.id,
    required this.text,
    required this.freeText,
  });

  int id;

  String text;

  @JsonKey(name: 'free_text')
  bool freeText;
  @override
  factory OptionRadio.fromJson(Map<String, dynamic> json) =>
      _$OptionRadioFromJson(json);

  Map<String, dynamic> toJson() => _$OptionRadioToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
