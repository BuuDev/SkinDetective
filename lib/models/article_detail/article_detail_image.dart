import 'package:json_annotation/json_annotation.dart';
part 'article_detail_image.g.dart';

@JsonSerializable()
class ArticleDetailImage {
  int id;
  String url;

  ArticleDetailImage({required this.id, required this.url});

  factory ArticleDetailImage.fromJson(Map<String, dynamic> json) =>
      _$ArticleDetailImageFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDetailImageToJson(this);
}
