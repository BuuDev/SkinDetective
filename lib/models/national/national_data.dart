import 'package:json_annotation/json_annotation.dart';
part 'national_data.g.dart';

@JsonSerializable()
class DataNational {
  int id;
  String name;
  String code;

  DataNational({required this.id, required this.name, required this.code});

  factory DataNational.fromJson(Map<String, dynamic> json) =>
      _$DataNationalFromJson(json);

  Map<String, dynamic> toJson() => _$DataNationalToJson(this);
}
