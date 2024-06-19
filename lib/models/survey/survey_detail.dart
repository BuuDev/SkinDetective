import 'package:json_annotation/json_annotation.dart';
part 'survey_detail.g.dart';

@JsonSerializable()
class SurveyDetail<T> {
  int id;

  @JsonKey(name: 'question_id')
  int questionId;

  String language;

  String title;

  @JsonKey(name: 'created_at')
  String createdAt;

  @JsonKey(name: 'updated_at')
  String updatedAt;

  @JsonKey(ignore: true)
  List<T> options = [];

  SurveyDetail({
    required this.id,
    required this.questionId,
    required this.language,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SurveyDetail.fromJson(Map<String, dynamic> json) =>
      _$SurveyDetailFromJson<T>(json);

  Map<String, dynamic> toJson() => _$SurveyDetailToJson(this);
}
