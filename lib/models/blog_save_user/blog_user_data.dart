import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/blog_save_user/blog_user_post.dart';
part 'blog_user_data.g.dart';

@JsonSerializable()
class BlogUserData {
  int id;

  @JsonKey(name: 'user_id')
  int userId;

  @JsonKey(name: 'post_id')
  int postId;

  int? status;

  @JsonKey(name: 'created_at')
  String createdAt;

  BlogUserPost posts;

  BlogUserData({
    required this.id,
    required this.userId,
    required this.postId,
    required this.createdAt,
    this.status,
    required this.posts,
  });

  factory BlogUserData.fromJson(Map<String, dynamic> json) =>
      _$BlogUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$BlogUserDataToJson(this);
}
