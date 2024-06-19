import 'package:json_annotation/json_annotation.dart';
part 'system_param.g.dart';

@JsonSerializable()
class SystemParam {
  int id;

  @JsonKey(name: 'month_required_survey')
  int monthRequired;

  @JsonKey(name: 'is_active_new_post')
  ActivePost activePost;

  @JsonKey(name: 'total_new_post')
  int totalPost;

  SystemParam(
      {required this.id,
      required this.monthRequired,
      required this.activePost,
      required this.totalPost});

  factory SystemParam.fromJson(Map<String, dynamic> json) =>
      _$SystemParamFromJson(json);

  Map<String, dynamic> toJson() => _$SystemParamToJson(this);
}

enum ActivePost {
  @JsonValue('on')
  on,

  @JsonValue('off')
  off,
}
