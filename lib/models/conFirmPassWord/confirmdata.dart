import 'package:json_annotation/json_annotation.dart';
part 'confirmdata.g.dart';

@JsonSerializable()
class Data {
  
  String token;
  String email;

  Data({required this.email,required this.token});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}