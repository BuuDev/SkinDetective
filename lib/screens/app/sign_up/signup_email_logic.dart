import 'dart:io';

import 'package:get_it/get_it.dart';

import 'package:otp_text_field/otp_field.dart';

import 'package:flutter/material.dart';
import 'package:skin_detective/providers/app/app.dart';
import 'package:skin_detective/services/apis/user/user.dart';

class SignUp with ChangeNotifier {
  final BuildContext context;

  SignUp({required this.context});
  final UserService _userService = UserService.client();
  OtpFieldController otpController1 = OtpFieldController();

  String? otp;

  Future<void> authenOtp(String emailController, String otpAuthenController,
      String passwordController) async {
    try {
      var info1 =
          await _userService.verifyOtp(emailController, otpAuthenController);

      GetIt.instance<AppVM>().loginSuccess(info1);
    } catch (err) {
      debugPrint('$err');
    }
  }

  Future<void> updateAccount(String name, File image) async {
    try {
      //await _userService.updateAccount(name, image);
    } catch (err) {
      debugPrint('$err');
    }
  }
}
