import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/survey/area/area.dart';
import 'package:skin_detective/models/survey/levels.dart';
import 'package:skin_detective/models/survey/radio/radio.dart';
import 'package:skin_detective/models/survey/slider/slider.dart';
part 'question_survey.g.dart';

@JsonSerializable()
class QuestionSurvey {
  QuestionSurvey({
    required this.id,
    required this.modalQuestion,
    required this.type,
    required this.levels,
    required this.laravelThroughKey,
    required this.details,
  });

  int id;

  @JsonKey(name: 'part')
  int modalQuestion;

  SurveyQuestionType type;

  List<Levels>? levels;

  @JsonKey(name: 'laravel_through_key')
  int laravelThroughKey;

  Map<String, dynamic> details;

  factory QuestionSurvey.fromJson(Map<String, dynamic> json) =>
      _$QuestionSurveyFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionSurveyToJson(this);

  dynamic get detailModel {
    switch (type) {
      case SurveyQuestionType.radio:
        return RadioModel.fromJson(details);
      case SurveyQuestionType.freeText:
        return AreaModel.fromJson(details);
      case SurveyQuestionType.slider:
        return SliderModel.fromJson(details);
      default:
        throw Exception('Khong tim thay type nao het');
    }
  }
}

enum SurveyQuestionType {
  @JsonValue('radio')
  radio,

  @JsonValue('free_text')
  freeText,

  @JsonValue('range_slide')
  slider,
}
