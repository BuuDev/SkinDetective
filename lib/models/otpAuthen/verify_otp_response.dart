import 'package:json_annotation/json_annotation.dart';

part 'verify_otp_response.g.dart';

@JsonSerializable()
class AuthenOtp {
  String status;
  String message;

  AuthenOtp({required this.status, required this.message});

  factory AuthenOtp.fromJson(Map<String, dynamic> json) =>
      _$AuthenOtpFromJson(json);

  Map<String, dynamic> toJson() => _$AuthenOtpToJson(this);
}
