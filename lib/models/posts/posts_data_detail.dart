import 'package:json_annotation/json_annotation.dart';
part 'posts_data_detail.g.dart';

@JsonSerializable()
class PostDataDetail {
  int id;
  @JsonKey(name : "post_id")
  int postId;
  String title;
  String content;
  

  PostDataDetail({
    required this.id,
    required this.postId,
    required this.content,
    required this.title,
  });

  factory PostDataDetail.fromJson(Map<String, dynamic> json) =>
      _$PostDataDetailFromJson(json);

  Map<String, dynamic> toJson() => _$PostDataDetailToJson(this);
}
