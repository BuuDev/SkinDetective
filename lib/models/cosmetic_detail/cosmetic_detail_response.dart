import 'package:json_annotation/json_annotation.dart';
part 'cosmetic_detail_response.g.dart';

@JsonSerializable()
class CosmeticDetailResponse {
  String title;
  String content;
  String brand;
  String? website;

  CosmeticDetailResponse({
    required this.title,
    required this.content,
    required this.brand,
    this.website,
  });

  factory CosmeticDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$CosmeticDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CosmeticDetailResponseToJson(this);
}
