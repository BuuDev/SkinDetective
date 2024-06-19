import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/cosmetic_user/cosmetic_user_data.dart';
part 'cosmetic_user_response.g.dart';

@JsonSerializable()
class CosmeticUser {
  int? currentPage;
  int? perPage;
  int? total;
  List<CosmeticUserData>? data;

  CosmeticUser({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.data,
  });

  factory CosmeticUser.fromJson(Map<String, dynamic> json) =>
      _$CosmeticUserFromJson(json);

  Map<String, dynamic> toJson() => _$CosmeticUserToJson(this);
}
