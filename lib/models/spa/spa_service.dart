import 'package:json_annotation/json_annotation.dart';

import '../../utils/helper/helper.dart';
part 'spa_service.g.dart';

@JsonSerializable()
class SpaServiceResponse {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'doctor_id')
  int doctorId;

  @JsonKey(name: 'name')
  String? name;

  @JsonKey(name: 'price')
  String? price;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'updated_at')
  String? updatedAt;

  @JsonKey(name: 'deleted_at')
  String? deletedAt;

  @JsonKey(name: 'thumbnail')
  String? thumbnail;

  @JsonKey(name: 'detail')
  SpaServiceDetail? detail;

  SpaServiceResponse({
    required this.id,
    required this.doctorId,
    this.name,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.thumbnail,
    this.detail,
  });
  String get serviceFee {
    if (detail!.price!.isNotEmpty) {
      return '${Helper.toMoneyFormat(detail!.price!)}${Helper.currencySymbol(detail!.currency!)}';
    } else {
      return 'Liên hệ spa';
    }
  }

  factory SpaServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$SpaServiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpaServiceResponseToJson(this);
}

@JsonSerializable()
class SpaServiceDetail {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'service_id')
  int serviceId;

  @JsonKey(name: 'content')
  String? content;

  @JsonKey(name: 'currency')
  String? currency;

  @JsonKey(name: 'language')
  String? language;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'updated_at')
  String? updatedAt;

  @JsonKey(name: 'deleted_at')
  String? deletedAt;

  @JsonKey(name: 'title')
  String? title;

  @JsonKey(name: 'price')
  String? price;

  String? description;

  SpaServiceDetail({
    required this.id,
    required this.serviceId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.title,
    this.description,
    this.content,
    this.currency,
    this.language,
    this.price,
  });

  factory SpaServiceDetail.fromJson(Map<String, dynamic> json) =>
      _$SpaServiceDetailFromJson(json);

  Map<String, dynamic> toJson() => _$SpaServiceDetailToJson(this);
}
