import 'package:json_annotation/json_annotation.dart';
part 'tips_detail.g.dart';

@JsonSerializable()
class TipsDetail {
  int id;
  @JsonKey(name: "tips_id")
  int tipsId;
  String title;
  String content;
  String description;

  TipsDetail(
      {required this.id,
      required this.tipsId,
      required this.title,
      required this.content,
      required this.description});

  factory TipsDetail.fromJson(Map<String, dynamic> json) =>
      _$TipsDetailFromJson(json);

  Map<String, dynamic> toJson() => _$TipsDetailToJson(this);
}
