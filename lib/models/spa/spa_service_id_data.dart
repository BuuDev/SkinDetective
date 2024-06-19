import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/spa/service_detail/service_data_detail.dart';
import 'package:skin_detective/utils/helper/helper.dart';
part 'spa_service_id_data.g.dart';

@JsonSerializable()
class ServiceIdDetail {
  int? id;
  @JsonKey(name: 'doctor_id')
  int? doctorId;
  @JsonKey(name: 'created_at')
  String? createdAt;
  String? thumbnail;
  ServiceDetail? detail;

  ServiceIdDetail(
      {this.id, this.doctorId, this.createdAt, this.thumbnail, this.detail});

  factory ServiceIdDetail.fromJson(Map<String, dynamic> json) =>
      _$ServiceIdDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceIdDetailToJson(this);
  String get serviceFee {
    if (detail!.price.isNotEmpty) {
      return '${Helper.toMoneyFormat(detail!.price)}${Helper.currencySymbol(detail!.currency)}';
    } else {
      return 'Liên hệ spa';
    }
  }
}
