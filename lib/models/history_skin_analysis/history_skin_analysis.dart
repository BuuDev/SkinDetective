import 'package:json_annotation/json_annotation.dart';
part 'history_skin_analysis.g.dart';

@JsonSerializable()
class HistorySkinAnalysisResponse {
  final int id;
  final String title;
  final String? url;
  @JsonKey(name: 'created_at')
  final String createdAt;

  HistorySkinAnalysisResponse({
    required this.id,
    required this.title,
    required this.url,
    required this.createdAt,
  });

  factory HistorySkinAnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$HistorySkinAnalysisResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HistorySkinAnalysisResponseToJson(this);
}
