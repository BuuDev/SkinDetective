import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/spa/spa.dart';

import '../../utils/helper/helper.dart';
import 'doctor_detail.dart';
part 'doctor.g.dart';

@JsonSerializable()
class Doctor {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'status')
  String status;

  @JsonKey(name: 'location')
  Location? location;

  @JsonKey(name: 'website')
  String? website;

  @JsonKey(name: 'phone')
  String? phone;

  @JsonKey(name: 'image')
  String? image;

  @JsonKey(name: 'rating')
  double? rating;

  @JsonKey(name: 'hashtag')
  String? hashtag;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'updated_at')
  String? updatedAt;

  @JsonKey(name: 'deleted_at')
  String? deletedAt;

  @JsonKey(name: 'type')
  String? type;

  @JsonKey(name: 'detail')
  DoctorDetail? detail;

  Doctor({
    required this.id,
    required this.status,
    this.location,
    this.website = '',
    this.phone = '',
    this.image = '',
    this.rating = 0.0,
    this.hashtag = '',
    this.createdAt = '',
    this.updatedAt = '',
    this.deletedAt = '',
    this.type = '',
    this.detail,
  });

  String get serviceFee {
    if (detail!.price!.isNotEmpty) {
      return '${Helper.toMoneyFormat(detail!.price!)}${Helper.currencySymbol(detail!.currency!)} / lượt';
    } else {
      return 'Liên hệ Bác sĩ';
    }
  }

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
