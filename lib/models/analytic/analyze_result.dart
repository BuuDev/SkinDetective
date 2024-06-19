import 'package:json_annotation/json_annotation.dart';
part 'analyze_result.g.dart';

@JsonSerializable()
class AnalyzeResult {
  AnalyzeResult({
    required this.cysticAcne,
    required this.atrophicScars,
    required this.redAcne,
    required this.blackhead,
  });

  @JsonKey(name: 'cystic_acne')
  int? cysticAcne;

  @JsonKey(name: 'atrophic_scars')
  int? atrophicScars;

  @JsonKey(name: 'red_acne')
  int? redAcne;

  @JsonKey(name: 'blackhead')
  int? blackhead;

  factory AnalyzeResult.fromJson(Map<String, dynamic> json) =>
      _$AnalyzeResultFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyzeResultToJson(this);
}
