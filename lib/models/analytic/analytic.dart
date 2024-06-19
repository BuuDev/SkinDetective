import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/analytic/analyze_detail.dart';
part 'analytic.g.dart';

@JsonSerializable()
class Analytic {
  int id;

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'created_at')
  DateTime createdAt;

  AnalyzeDetail frontal;

  Analytic({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.frontal,
  });

  factory Analytic.fromJson(Map<String, dynamic> json) =>
      _$AnalyticFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticToJson(this);
}
