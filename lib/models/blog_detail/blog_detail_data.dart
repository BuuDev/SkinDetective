import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/article_detail/article_data_user.dart';
import 'package:skin_detective/models/article_detail/article_detail_image.dart';
import 'package:skin_detective/models/blog_detail/blog_detail.dart';

import '../cosmetic_detail/cosmetic_detail_data.dart';
part 'blog_detail_data.g.dart';

@JsonSerializable()
class BlogDetailData {
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  TypePost type;
  String? thumbnail;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'save_status')
  bool saveStatus;
  BlogDetailResponse detail;
  ArticleDataUser user;
  List<ArticleDetailImage>? images;

  BlogDetailData(
      {required this.id,
      required this.userId,
      required this.type,
      required this.thumbnail,
      required this.createdAt,
      required this.saveStatus,
      required this.detail,
      required this.user,
      required this.images});

  factory BlogDetailData.fromJson(Map<String, dynamic> json) =>
      _$BlogDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$BlogDetailDataToJson(this);
}
