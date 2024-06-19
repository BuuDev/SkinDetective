import 'package:json_annotation/json_annotation.dart';
part 'article_detail.g.dart';

@JsonSerializable()
class ArticleDetailResponse {
  int id;
  @JsonKey(name: "post_id")
  int postId;
  String title;
  String content;

  ArticleDetailResponse({
    required this.id,
    required this.postId,
    required this.title,
    required this.content,
  });

  factory ArticleDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ArticleDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDetailResponseToJson(this);
}
