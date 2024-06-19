import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/tips/tips_detail.dart';
part 'tips.g.dart';

@JsonSerializable()
class Tips {
  TipsDetail details;
  int id;
  String? image;

  Tips({required this.details, required this.id, required this.image});

  factory Tips.fromJson(Map<String, dynamic> json) => _$TipsFromJson(json);

  Map<String, dynamic> toJson() => _$TipsToJson(this);
}
