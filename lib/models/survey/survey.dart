import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/survey/question_survey.dart';
part 'survey.g.dart';

@JsonSerializable()
class SurveyModel {
  SurveyModel({
    required this.id,
    required this.name,
    required this.creator,
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    required this.partOne,
    required this.partTwo,
    required this.partThree,
  });

  int id;
  String name;
  int creator;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'updated_at')
  DateTime updatedAt;

  SurveyStatus status;

  @JsonKey(name: 'part_1')
  List<QuestionSurvey> partOne;

  @JsonKey(name: 'part_2')
  List<QuestionSurvey> partTwo;

  @JsonKey(name: 'part_3')
  List<QuestionSurvey> partThree;

  factory SurveyModel.fromJson(Map<String, dynamic> json) =>
      _$SurveyModelFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyModelToJson(this);
}

enum SurveyStatus {
  @JsonValue('active')
  active,

  @JsonValue('deactive')
  deActive,
}
