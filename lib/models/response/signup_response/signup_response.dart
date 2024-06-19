import 'package:json_annotation/json_annotation.dart';
import 'package:skin_detective/models/user/user.dart';
part 'signup_response.g.dart';

@JsonSerializable()
class SignUpResponse {
  String status;
  String message;
  User data;

  SignUpResponse(
      {required this.status, required this.message, required this.data});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpResponseToJson(this);
}
