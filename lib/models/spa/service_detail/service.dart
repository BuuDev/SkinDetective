import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/spa/service_detail/service_data.dart';
part 'service.g.dart';

@JsonSerializable()
class Service {
  ServiceData data;
  Service({required this.data});

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
