import 'package:json_annotation/json_annotation.dart';
part 'spa_detail.g.dart';

@JsonSerializable()
class SpaDetail {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'doctor_id')
  int doctorId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'experience')
  int experience;

  @JsonKey(name: 'unit')
  String? unit;

  @JsonKey(name: 'specialize')
  String? specialize;

  @JsonKey(name: 'description')
  String? description;

  @JsonKey(name: 'language')
  String? language;

  @JsonKey(name: 'price')
  String? price;

  @JsonKey(name: 'currency')
  String? currency;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'updated_at')
  String? updatedAt;

  @JsonKey(name: 'deleted_at')
  String? deletedAt;

  String get unitExperience {
    if (language == 'en') {
      unit = 'năm';
    }
    switch (unit) {
      case "year":
        return "năm";

      case "month":
        return "tháng";

      case "năm":
        return "year";

      default:
        return "";
    }
  }

  SpaDetail(
      {required this.address,
      required this.doctorId,
      required this.experience,
      required this.id,
      required this.name,
      this.createdAt,
      this.currency,
      this.deletedAt,
      this.description,
      this.language,
      this.price,
      this.specialize,
      this.unit,
      this.updatedAt});

  factory SpaDetail.fromJson(Map<String, dynamic> json) =>
      _$SpaDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SpaDetailToJson(this);
}
