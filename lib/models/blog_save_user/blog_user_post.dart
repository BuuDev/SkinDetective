import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/blog_save_user/blog_user_detail.dart';
part 'blog_user_post.g.dart';

@JsonSerializable()
class BlogUserPost {
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  String? type;

  String? thumbnail;
  String? status;

  @JsonKey(name: 'created_at')
  String createdAt;
  BlogUserDetail detail;

  BlogUserPost(
      {required this.id,
      required this.userId,
      required this.type,
      this.thumbnail,
      this.status,
      required this.detail,
      required this.createdAt});

  factory BlogUserPost.fromJson(Map<String, dynamic> json) =>
      _$BlogUserPostFromJson(json);

  Map<String, dynamic> toJson() => _$BlogUserPostToJson(this);
}
