import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/utils/helper/helper.dart';
part 'doctor_detail.g.dart';

@JsonSerializable()
class DoctorDetail {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'doctor_id')
  int doctorId;

  @JsonKey(name: 'name')
  String name;

  @JsonKey(name: 'address')
  String address;

  @JsonKey(name: 'work_place')
  String? workPlace;

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
    switch (unit) {
      case "year":
        return "năm";

      case "month":
        return "tháng";

      default:
        return "";
    }
  }

  String get serviceFee {
    if (price!.isNotEmpty) {
      return language == 'vn'
          ? '${Helper.toMoneyFormat(price!)}${Helper.currencySymbol(currency!)} / lượt'
          : '$price${Helper.currencySymbol(currency!)} / session';
    } else {
      return 'Liên hệ Bác sĩ';
    }
  }

  DoctorDetail(
      {required this.address,
      required this.doctorId,
      required this.experience,
      required this.id,
      required this.name,
      this.workPlace,
      this.createdAt,
      this.currency,
      this.deletedAt,
      this.description,
      this.language,
      this.price,
      this.specialize,
      this.unit,
      this.updatedAt});

  factory DoctorDetail.fromJson(Map<String, dynamic> json) =>
      _$DoctorDetailFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorDetailToJson(this);
}
