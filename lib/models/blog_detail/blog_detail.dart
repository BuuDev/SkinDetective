import 'package:json_annotation/json_annotation.dart';
part 'blog_detail.g.dart';

@JsonSerializable()
class BlogDetailResponse {
  int id;
  @JsonKey(name: "post_id")
  int postId;
  String title;
  String content;
  String description;

  BlogDetailResponse({
    required this.id,
    required this.postId,
    required this.title,
    required this.content,
    required this.description,
  });

  factory BlogDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$BlogDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BlogDetailResponseToJson(this);
}
