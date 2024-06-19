import 'package:json_annotation/json_annotation.dart';
part 'cancel_analytic.g.dart';

@JsonSerializable()
class CancelAnalytic {
  bool success;

  CancelAnalytic({required this.success});

  factory CancelAnalytic.fromJson(Map<String, dynamic> json) =>
      _$CancelAnalyticFromJson(json);

  Map<String, dynamic> toJson() => _$CancelAnalyticToJson(this);
}
