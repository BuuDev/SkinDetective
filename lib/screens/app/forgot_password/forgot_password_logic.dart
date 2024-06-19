import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';

import '../../../routes/routes.dart';
import '../../../services/apis/user/user.dart';
import '../../../utils/notify_helper/notify_helper.dart';

class ForgotLogic extends ChangeNotifier {
  final BuildContext context;
  ForgotLogic({required this.context});
  TextEditingController emailController = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  OtpFieldController otpController = OtpFieldController();
  String? otp;
  final UserService _userService = UserService.client();

  Future<void> confirmEmail(String email) async {
    try {
      var confirm = await _userService.confirmEmail(email);
      if (confirm.status == 'success') {
        Navigator.pushNamed(context, AppRoutes.authenOtpPassword,
            arguments: emailController.text);
      } else {
        NotifyHelper.showSnackBar(LocaleKeys.profileYearErr.tr());
      }
    } catch (err) {
      NotifyHelper.showSnackBar(LocaleKeys.profileYearErr.tr());
    }
  }

  Future<void> otpAuthenPassword(
      String email, String otpauthenController) async {
    try {
      await _userService.verityOtpPassword(email, otpauthenController);

      Navigator.pushNamed(context, AppRoutes.confirmPassword);
    } catch (err) {
      NotifyHelper.showSnackBar(LocaleKeys.signupEmailFalseOTP.tr());
    }
  }
}
