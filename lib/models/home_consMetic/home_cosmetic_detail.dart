import 'package:json_annotation/json_annotation.dart';

part 'home_cosmetic_detail.g.dart';

@JsonSerializable()
class HomeConsMeticDetail {
  @JsonKey(name: 'id')
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'type')
  String type;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'thumbnail')
  String thumbnail;

  HomeConsMeticDetail({
    required this.id,
    required this.userId,
    required this.type,
    required this.createdAt,
    required this.thumbnail,
  });

  factory HomeConsMeticDetail.fromJson(Map<String, dynamic> json) =>
      _$HomeConsMeticDetailFromJson(json);

  Map<String, dynamic> toJson() => _$HomeConsMeticDetailToJson(this);
}
