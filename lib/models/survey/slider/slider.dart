import 'package:json_annotation/json_annotation.dart';
part 'slider.g.dart';

@JsonSerializable()
class SliderModel {
  int id;

  @JsonKey(name: 'question_id')
  int questionId;

  String language;

  String title;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  List<OptionSlider> options;

  SliderModel({
    required this.id,
    required this.questionId,
    required this.language,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.options,
  });

  factory SliderModel.fromJson(Map<String, dynamic> json) =>
      _$SliderModelFromJson(json);

  Map<String, dynamic> toJson() => _$SliderModelToJson(this);
}

@JsonSerializable()
class OptionSlider {
  OptionSlider({
    required this.id,
    required this.text,
  });

  int id;

  String text;

  factory OptionSlider.fromJson(Map<String, dynamic> json) =>
      _$OptionSliderFromJson(json);

  Map<String, dynamic> toJson() => _$OptionSliderToJson(this);
}
