import 'package:json_annotation/json_annotation.dart';
part 'service_data_image.g.dart';

@JsonSerializable()
class ServiceImage {
  @JsonKey(name: 'service_id')
  int serviceId;
  int id;
  String url;

  ServiceImage({required this.serviceId, required this.id, required this.url});

  factory ServiceImage.fromJson(Map<String, dynamic> json) =>
      _$ServiceImageFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceImageToJson(this);
}
