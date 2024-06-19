import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/article_detail/article_data_user.dart';
import 'package:skin_detective/models/article_detail/article_detail.dart';
import 'package:skin_detective/models/article_detail/article_detail_image.dart';

import '../cosmetic_detail/cosmetic_detail_data.dart';
part 'article_detail_data.g.dart';

@JsonSerializable()
class ArticleDetailData {
  int id;
  @JsonKey(name: 'user_id')
  int userId;
  TypePost type;
  String? thumbnail;
  StatusPostUser status;
  @JsonKey(name: 'created_at')
  String createdAt;
  @JsonKey(name: 'save_status')
  bool saveStatus;
  ArticleDetailResponse detail;
  ArticleDataUser user;
  List<ArticleDetailImage>? images;

  ArticleDetailData({
    required this.id,
    required this.userId,
    required this.type,
    required this.thumbnail,
    required this.status,
    required this.createdAt,
    required this.saveStatus,
    required this.detail,
    required this.user,
    required this.images,
  });

  factory ArticleDetailData.fromJson(Map<String, dynamic> json) =>
      _$ArticleDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleDetailDataToJson(this);

  String? get getFiledStatus {
    return _$StatusPostUserEnumMap[status];
  }
}

enum StatusPostUser {
  @JsonValue("waiting")
  waiting,

  @JsonValue('active')
  active,

  @JsonValue('draft')
  draft,

  @JsonValue('disabled')
  disabled
}
