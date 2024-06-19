import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/spa/spa_service_id_data.dart';
part 'spa_service_id.g.dart';

@JsonSerializable()
class SpaServiceResponse {
  @JsonKey(name: 'current_page')
  int? currentPage;
  @JsonKey(name: 'data')
  List<ServiceIdDetail> data;

  @JsonKey(name: 'to')
  int? to;
  @JsonKey(name: 'total')
  int? total;

  SpaServiceResponse(
      {this.currentPage, required this.data, this.to, this.total});

  factory SpaServiceResponse.fromJson(Map<String, dynamic> json) =>
      _$SpaServiceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpaServiceResponseToJson(this);
}
