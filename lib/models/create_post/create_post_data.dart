import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/create_post/create_post_detail.dart';
import 'package:skin_detective/models/create_post/image.dart';
part 'create_post_data.g.dart';

@JsonSerializable()
class CreatePostData {
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  String? type;
  String? thumbnail;
  String? status;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;

  int? agree;
  CreatePostDetail detail;
  List<Images>? images;

  CreatePostData({
    required this.id,
    required this.userId,
    this.type,
    this.thumbnail,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.agree,
    required this.detail,
    this.images,
  });

  factory CreatePostData.fromJson(Map<String, dynamic> json) =>
      _$CreatePostDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePostDataToJson(this);
}
