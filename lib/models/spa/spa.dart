import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/spa/spa_detail.dart';
import 'package:skin_detective/models/spa/spa_service.dart';

import '../../utils/helper/helper.dart';
part 'spa.g.dart';

@JsonSerializable()
class Spa {
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
  SpaDetail? detail;

  @JsonKey(name: 'services')
  List<SpaServiceResponse>? services;

  Spa(
      {required this.id,
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
      this.services});

  String get serviceFee {
    if (detail!.price!.isNotEmpty) {
      return '${Helper.toMoneyFormat(detail!.price!)}${Helper.currencySymbol(detail!.currency!)}';
    } else {
      return 'Liên hệ spa';
    }
  }

  factory Spa.fromJson(Map<String, dynamic> json) => _$SpaFromJson(json);

  Map<String, dynamic> toJson() => _$SpaToJson(this);
}

@JsonSerializable()
class Location {
  @JsonKey(name: 'latitude')
  String? latitude;

  @JsonKey(name: 'longitude')
  String? longitude;

  Location({this.latitude, this.longitude});
  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
