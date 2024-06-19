import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/new_post/new_post_detail.dart';
part 'new_post.g.dart';

@JsonSerializable()
class NewPost {
  int id;
  int newPostId;
  String type;
  String createdAt;
  String updatedAt;
  int agree;
  NewPostDetail detail;

  NewPost(
      {required this.id,
      required this.newPostId,
      required this.type,
      required this.createdAt,
      required this.updatedAt,
      required this.agree,
      required this.detail});

  factory NewPost.fromJson(Map<String, dynamic> json) =>
      _$NewPostFromJson(json);

  Map<String, dynamic> toJson() => _$NewPostToJson(this);
}
