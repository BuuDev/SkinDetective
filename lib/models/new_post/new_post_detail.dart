import 'package:json_annotation/json_annotation.dart';
part 'new_post_detail.g.dart';

@JsonSerializable()
class NewPostDetail {
  int id;
  int postId;

  String title;
  String content;
  String language;
  String createdAt;
  String updatedAt;


  NewPostDetail(
      {required this.id,
      required this.postId,

      required this.title,
      required this.content,
      required this.language,
      required this.createdAt,
      required this.updatedAt,
});

  factory NewPostDetail.fromJson(Map<String, dynamic> json) =>
      _$NewPostDetailFromJson(json);

  Map<String, dynamic> toJson() => _$NewPostDetailToJson(this);
}
