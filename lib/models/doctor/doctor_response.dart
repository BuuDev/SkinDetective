import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/doctor/doctor.dart';
part 'doctor_response.g.dart';

@JsonSerializable()
class DoctorResponse {
  @JsonKey(name: 'current_page')
  int? currentPage;
  @JsonKey(name: 'data')
  List<Doctor>? data;
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

  DoctorResponse(
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

  factory DoctorResponse.fromJson(Map<String, dynamic> json) =>
      _$DoctorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorResponseToJson(this);
}
