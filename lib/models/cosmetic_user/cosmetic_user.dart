import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/cosmetic_user/cosmetic_user_response.dart';
part 'cosmetic_user.g.dart';

@JsonSerializable()
class CosmeticUserResponse {
  String? success;
  String? message;
  CosmeticUser? data;

  CosmeticUserResponse({this.data, this.success, this.message});

  factory CosmeticUserResponse.fromJson(Map<String, dynamic> json) =>
      _$CosmeticUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CosmeticUserResponseToJson(this);
}
