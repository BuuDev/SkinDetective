import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/conFirmPassWord/confirmdata.dart';
part 'confirmpassword.g.dart';

@JsonSerializable()
class ResponseCF {
  
  String status;
  Data data;
  

  ResponseCF({required this.status,required this.data});

  factory ResponseCF.fromJson(Map<String, dynamic> json) => _$ResponseCFFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseCFToJson(this);
}