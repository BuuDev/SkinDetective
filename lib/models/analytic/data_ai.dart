import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/analytic/analyze_detail.dart';
part 'data_ai.g.dart';

@JsonSerializable()
class DataAI {
  DataAI({
    required this.id,
    required this.url,
    required this.type,
    required this.name,
    required this.detailId,
    required this.resultAi,
    required this.createdAt,
  });

  int id;
  String url;
  TypeAnalyze type;
  String name;

  @JsonKey(name: 'detail_id')
  int detailId;

  @JsonKey(name: 'result_ai')
  ResultAI resultAi;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  factory DataAI.fromJson(Map<String, dynamic> json) => _$DataAIFromJson(json);

  Map<String, dynamic> toJson() => _$DataAIToJson(this);
}

@JsonSerializable()
class ResultAI {
  ResultAI({
    required this.acneBox,
    required this.acneBoxClass,
    required this.grading,
  });

  @JsonKey(name: 'acne_box')
  List<List<int>> acneBox;

  @JsonKey(name: 'acne_box_class')
  List<int> acneBoxClass;

  int grading;

  factory ResultAI.fromJson(Map<String, dynamic> json) =>
      _$ResultAIFromJson(json);

  Map<String, dynamic> toJson() => _$ResultAIToJson(this);
}
