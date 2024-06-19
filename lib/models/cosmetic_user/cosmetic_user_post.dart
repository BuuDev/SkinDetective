import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/cosmetic_user/cosmetic_user_detail.dart';
part 'cosmetic_user_post.g.dart';

@JsonSerializable()
class CosmeticUserPost {
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  String type;
  String? thumbnail;
  String? status;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  CosmeticUserDetail detail;

  CosmeticUserPost({
    required this.id,
    required this.userId,
    required this.type,
    this.thumbnail,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.detail,
  });

  factory CosmeticUserPost.fromJson(Map<String, dynamic> json) =>
      _$CosmeticUserPostFromJson(json);

  Map<String, dynamic> toJson() => _$CosmeticUserPostToJson(this);
}
