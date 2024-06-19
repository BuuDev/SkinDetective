import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/cosmetic_user/cosmetic_user_post.dart';
part 'cosmetic_user_data.g.dart';

@JsonSerializable()
class CosmeticUserData {
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'post_id')
  int postId;
  int? status;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'updated_at')
  String updatedAt;
  CosmeticUserPost posts;

  CosmeticUserData({
    required this.id,
    required this.userId,
    required this.postId,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.posts,
  });

  factory CosmeticUserData.fromJson(Map<String, dynamic> json) =>
      _$CosmeticUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$CosmeticUserDataToJson(this);
}
