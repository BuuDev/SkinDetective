import 'package:json_annotation/json_annotation.dart';
part 'create_post_detail.g.dart';

@JsonSerializable()
class CreatePostDetail {
  int id;
  @JsonKey(name: 'post_id')
  int postId;
  String? brand;
  String title;
  String content;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'deleted_at')
  String? updatedAt;

  String? description;

  CreatePostDetail({
    required this.id,
    required this.postId,
    this.brand,
    required this.title,
    required this.content,
    this.createdAt,
    this.updatedAt,
    this.description,
  });

  factory CreatePostDetail.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDetailFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostDetailToJson(this);
}
