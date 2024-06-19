import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/spa/spa.dart';
part 'spa_response.g.dart';

@JsonSerializable()
class SpaResponse {
  @JsonKey(name: 'current_page')
  int? currentPage;
  @JsonKey(name: 'data')
  List<Spa>? data;
  @JsonKey(name: 'first_page_url')
  String? firstPageUrl;
  @JsonKey(name: 'from')
  int? from;
  @JsonKey(name: 'last_page')
  int? lastPage;
  @JsonKey(name: 'last_page_url')
  String? lastPageUrl;
  @JsonKey(name: 'next_page_url')
  String? nextPageUrl;
  @JsonKey(name: 'path')
  String? path;
  @JsonKey(name: 'per_page')
  String? perPage;
  @JsonKey(name: 'prev_page_url')
  String? prevPageUrl;
  @JsonKey(name: 'to')
  int? to;
  @JsonKey(name: 'total')
  int? total;

  SpaResponse(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  factory SpaResponse.fromJson(Map<String, dynamic> json) =>
      _$SpaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SpaResponseToJson(this);
}
