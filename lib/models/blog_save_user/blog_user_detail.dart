import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/theme/format_datetime.dart';
part 'blog_user_detail.g.dart';

@JsonSerializable()
class BlogUserDetail {
  int id;
  @JsonKey(name: "post_id")
  int postId;
  String title;
  String content;
  String description;
  String language;
  @JsonKey(name: "created_at")
  String createdAt;

  BlogUserDetail(
      {required this.id,
      required this.postId,
      required this.title,
      required this.content,
      required this.description,
      required this.language,
      required this.createdAt});

  factory BlogUserDetail.fromJson(Map<String, dynamic> json) =>
      _$BlogUserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$BlogUserDetailToJson(this);

  String getDateCreated() {
    DateTime _date = DateTime.parse(createdAt);

    return language == 'vn'
        ? DateFormat(FormatDate.formatDateTime).format(_date)
        : DateFormat.yMMMMd('en_US').format(_date);
  }
}
