import 'package:json_annotation/json_annotation.dart';

import 'package:skin_detective/models/posts/posts_data_detail.dart';

import 'package:skin_detective/models/posts/posts_data_user.dart';

part 'posts.g.dart';

@JsonSerializable()
class Posts {
  PostDataDetail detail;
  PostsDataUser user;
  TypePost type;
  int id;

  @JsonKey(name: "user_id")
  int userId;
  @JsonKey(name: "created_at")
  String createdAt;
  String? thumbnail;

  Posts({
    required this.detail,
    required this.user,
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.thumbnail,
    required this.type,
  });

  factory Posts.fromJson(Map<String, dynamic> json) => _$PostsFromJson(json);

  Map<String, dynamic> toJson() => _$PostsToJson(this);
}

enum TypePost {
  @JsonValue('cosmetics')
  cosmetics,
  @JsonValue('blog')
  blog,
  @JsonValue('post')
  post,
}
