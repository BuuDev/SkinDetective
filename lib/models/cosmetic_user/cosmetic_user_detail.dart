import 'package:json_annotation/json_annotation.dart';
part 'cosmetic_user_detail.g.dart';

@JsonSerializable()
class CosmeticUserDetail {
  int id;

  @JsonKey(name: 'post_id')
  int postId;

  String? brand;

  String title;

  String content;

  String? description;

  @JsonKey(name: 'created_at')
  String createdAt;

  CosmeticUserDetail(
      {required this.id,
      required this.postId,
      required this.brand,
      required this.title,
      required this.content,
      this.description,
      required this.createdAt});

  factory CosmeticUserDetail.fromJson(Map<String, dynamic> json) =>
      _$CosmeticUserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$CosmeticUserDetailToJson(this);
}
