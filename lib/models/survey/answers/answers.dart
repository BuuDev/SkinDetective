import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/survey/answers/answers_option.dart';
part 'answers.g.dart';

@JsonSerializable()
class Answers {
  @JsonKey(name: 'question_id')
  int questionId;
  List<OptionAnswer>? options;

  Answers({required this.questionId, required this.options});
  @override
  String toString() {
    return toJson().toString();
  }

  factory Answers.fromJson(Map<String, dynamic> json) =>
      _$AnswersFromJson(json);

  Map<String, dynamic> toJson() => _$AnswersToJson(this);
}
