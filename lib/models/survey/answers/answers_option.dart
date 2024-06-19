import 'package:json_annotation/json_annotation.dart';
part 'answers_option.g.dart';

@JsonSerializable()
class OptionAnswer {
  int id;
  String? text;
  int? level;
  @JsonKey(name: 'free_text')
  bool? freeText;

  OptionAnswer(
      {required this.id,
      required this.text,
      required this.level,
      required this.freeText});
  @override
  String toString() {
    return toJson().toString();
  }

  factory OptionAnswer.fromJson(Map<String, dynamic> json) =>
      _$OptionAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$OptionAnswerToJson(this);
}
