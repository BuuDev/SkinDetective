import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/home_consMetic/home_cosmetic_detail.dart';
part 'home_cosmetic_data.g.dart';

@JsonSerializable()
class HomeCosmeticData {
  @JsonKey(name: 'current_page')
  int currentPage;

  @JsonKey(name: 'data')
  List<HomeConsMeticDetail> data;

  @JsonKey(name: 'first_page_url')
  String firstPageUrl;

  @JsonKey(name: 'from')
  int from;
  @JsonKey(name: 'last_page')
  int lastPage;
  @JsonKey(name: 'last_page_url')
  String lastPageUrl;
  @JsonKey(name: 'path')
  String path;
  @JsonKey(name: 'per_page')
  String perPage;
  @JsonKey(name: 'to')
  int to;
  @JsonKey(name: 'total')
  int total;
  HomeCosmeticData({
    required this.data,
    required this.currentPage,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory HomeCosmeticData.fromJson(Map<String, dynamic> json) =>
      _$HomeCosmeticDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeCosmeticDataToJson(this);
}
