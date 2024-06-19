import 'package:json_annotation/json_annotation.dart';
part 'save_cosmetic_response.g.dart';

@JsonSerializable()
class SaveCosmeticResponse {
  @JsonKey(name: 'user_id')
  int userId;
  @JsonKey(name: 'post_id')
  int postId;
  int status;

  SaveCosmeticResponse(
      {required this.userId, required this.postId, required this.status});

  factory SaveCosmeticResponse.fromJson(Map<String, dynamic> json) =>
      _$SaveCosmeticResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SaveCosmeticResponseToJson(this);
}
