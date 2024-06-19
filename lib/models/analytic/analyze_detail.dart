import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/analytic/analyze_result.dart';
import 'package:skin_detective/models/analytic/data_ai.dart';
part 'analyze_detail.g.dart';

enum TypeAnalyze {
  @JsonValue('frontal')
  frontal,

  @JsonValue('left')
  left,

  @JsonValue('right')
  right
}

@JsonSerializable()
class AnalyzeDetail {
  AnalyzeDetail({
    required this.id,
    required this.skinAnalysisId,
    required this.analysisResultId,
    required this.result,
    required this.type,
    required this.createdAt,
    required this.dataAI,
    required this.skinAnalysisDetail,
  });

  int id;

  @JsonKey(name: 'skin_analysis_id')
  int skinAnalysisId;

  @JsonKey(name: 'analysis_result_id')
  int analysisResultId;

  AnalyzeResult result;

  TypeAnalyze type;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  @JsonKey(name: 'image')
  DataAI dataAI;

  @JsonKey(name: 'skin_analysis_detail')
  SkinAnalyzeSpec skinAnalysisDetail;

  factory AnalyzeDetail.fromJson(Map<String, dynamic> json) =>
      _$AnalyzeDetailFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyzeDetailToJson(this);
}

@JsonSerializable()
class SkinAnalyzeSpec {
  SkinAnalyzeSpec({
    required this.id,
    required this.title,
    required this.content,
    required this.description,
    this.shortTitle,
  });

  int id;
  String title;
  String content;
  @JsonKey(name: "short_title")
  String? shortTitle;
  String description;

  factory SkinAnalyzeSpec.fromJson(Map<String, dynamic> json) =>
      _$SkinAnalyzeSpecFromJson(json);

  Map<String, dynamic> toJson() => _$SkinAnalyzeSpecToJson(this);
}
