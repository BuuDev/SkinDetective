import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/article_detail/article_detail_image.dart';
import 'package:skin_detective/models/cosmetic_detail/cosmetic_detail_response.dart';
part 'cosmetic_detail_data.g.dart';

@JsonSerializable()
class CosmeticDetailData {
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  TypePost type;
  String? thumbnail;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'save_status')
  bool saveStatus;
  CosmeticDetailResponse detail;
  List<ArticleDetailImage>? images;

  CosmeticDetailData(
      {required this.id,
      required this.userId,
      required this.type,
      required this.thumbnail,
      required this.createdAt,
      required this.saveStatus,
      required this.detail,
      required this.images});

  factory CosmeticDetailData.fromJson(Map<String, dynamic> json) =>
      _$CosmeticDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$CosmeticDetailDataToJson(this);
}

enum TypePost {
  @JsonValue('cosmetics')
  cosmetics,
  @JsonValue('blog')
  blog,
  @JsonValue('post')
  post
}
