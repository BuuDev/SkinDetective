import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/survey/answers/answers.dart';
part 'survey_answers.g.dart';

@JsonSerializable()
class SurveyAnswers {
  @JsonKey(name: 'survey_id')
  int? surveyId;
  List<Answers>? answers;

  SurveyAnswers({required this.surveyId, required this.answers});
  factory SurveyAnswers.fromJson(Map<String, dynamic> json) =>
      _$SurveyAnswersFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyAnswersToJson(this);
}
