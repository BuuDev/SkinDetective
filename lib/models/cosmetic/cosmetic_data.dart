import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/cosmetic/cosmetic_detail.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/format_datetime.dart';
part 'cosmetic_data.g.dart';

@JsonSerializable()
class ConsMeticData {
  int id;
  @JsonKey(name: 'user_id')
  int userId;

  TypePost type;

  @JsonKey(name: 'thumbnail')
  String? thumbnail;

  StatusPostUser? status;

  @JsonKey(name: 'created_at')
  String createdAt;

  ConsMeticDetail detail;

  ConsMeticData({
    required this.id,
    required this.userId,
    required this.type,
    required this.thumbnail,
    required this.createdAt,
    required this.status,
    required this.detail,
  });

  String getDateCreated() {
    DateTime _date = DateTime.parse(createdAt);

    return DateFormat(FormatDate.formatDateTime).format(_date);
    //DateFormat.yMMMMd('en_US').format(_date);
  }

  factory ConsMeticData.fromJson(Map<String, dynamic> json) =>
      _$ConsMeticDataFromJson(json);

  Map<String, dynamic> toJson() => _$ConsMeticDataToJson(this);

  String? get fieldStatus {
    return _$StatusPostUserEnumMap[status];
  }
}

enum StatusPostUser {
  @JsonValue('waiting')
  waiting,

  @JsonValue('active')
  active,

  @JsonValue('draft')
  draft,

  @JsonValue('disabled')
  disabled
}

enum TypePost {
  @JsonValue('cosmetics')
  cosmetics,

  @JsonValue('blog')
  blog,

  @JsonValue('post')
  post,
}

extension ExStatusPostUser on StatusPostUser {
  Color get color {
    switch (this) {
      case StatusPostUser.waiting:
        return AppColors.red;
      case StatusPostUser.active:
        return AppColors.textBlue;
      case StatusPostUser.draft:
        return AppColors.textBlue;

      default:
        return AppColors.red;
    }
  }
}
