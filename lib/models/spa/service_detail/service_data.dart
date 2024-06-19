import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/spa/service_detail/service_data_detail.dart';
import 'package:skin_detective/models/spa/service_detail/service_data_image.dart';
import 'package:skin_detective/utils/helper/helper.dart';
part 'service_data.g.dart';

@JsonSerializable()
class ServiceData {
  int id;
  ServiceDetail detail;
  
  String get serviceFee {
    if (detail.price.isNotEmpty) {
      return '${Helper.toMoneyFormat(detail.price)}${Helper.currencySymbol(detail.currency)}';
    } else {
      return 'Liên hệ spa';
    }
  }

  List<ServiceImage>? images;
  ServiceData({required this.detail, required this.images, required this.id});

  factory ServiceData.fromJson(Map<String, dynamic> json) =>
      _$ServiceDataFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDataToJson(this);
}
