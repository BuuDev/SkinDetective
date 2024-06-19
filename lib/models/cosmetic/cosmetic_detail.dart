import 'package:easy_localization/easy_localization.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/services/local_storage.dart';
import 'package:skin_detective/theme/format_datetime.dart';
part 'cosmetic_detail.g.dart';

@JsonSerializable()
class ConsMeticDetail {
  int id;
  @JsonKey(name: 'post_id')
  int postId;
  String? brand;

  String title;
  String content;
  String language;

  String? description;
  @JsonKey(name: 'created_at')
  String createdAt;

  ConsMeticDetail(
      {required this.id,
      required this.postId,
      required this.brand,
      required this.title,
      required this.content,
      this.description,
      required this.language,
      required this.createdAt});

  String getDateCreated() {
    String lang = LocalStorage().store.getString('lang').toString();
    DateTime _date = DateTime.parse(createdAt);

    return lang == 'vn'
        ? DateFormat(FormatDate.formatDateTime).format(_date)
        : DateFormat.yMMMMd('en_US').format(_date);
  }

  factory ConsMeticDetail.fromJson(Map<String, dynamic> json) =>
      _$ConsMeticDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ConsMeticDetailToJson(this);
}
