import 'package:json_annotation/json_annotation.dart';
part 'service_data_detail.g.dart';

@JsonSerializable()
class ServiceDetail {
  int id;
  @JsonKey(name: "service_id")
  int serviceId;
  String content;
  String description;
  String currency;
  String title;
  String price;
  String language;

  ServiceDetail(
      {required this.id,
      required this.serviceId,
      required this.content,
      required this.currency,
      required this.title,
      required this.description,
      required this.language,
      required this.price});

  factory ServiceDetail.fromJson(Map<String, dynamic> json) =>
      _$ServiceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceDetailToJson(this);
}
