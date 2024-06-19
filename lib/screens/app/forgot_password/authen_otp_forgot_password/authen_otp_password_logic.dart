part of 'authen_otp_password.dart';

class LogicAuthenPassword extends ChangeNotifier {
  final BuildContext context;
  LogicAuthenPassword({required this.context});
  final UserService _userService = UserService.client();
  OtpFieldController otpController = OtpFieldController();
  String? otp;
  bool enable = false;

  void validateOtp() async {
    if (otp != null) {
      if (otp!.length == 6) {
        enable = true;
      } else {
        enable = false;
      }
    }
    notifyListeners();
  }

  Future<void> authenOtp(
      String emailController, String otpAuthenController) async {
    try {
      var otp = await _userService.verityOtpPassword(
          emailController, otpAuthenController);
      Navigator.pushNamed(context, AppRoutes.confirmPassword,
          arguments: [otp.email, otp.token]);
    } catch (err) {
      NotifyHelper.showSnackBar(LocaleKeys.signupEmailFalseOTP.tr());
    }
    notifyListeners();
  }

  Future<void> confirmEmail(String email) async {
    try {
      var confirm = await _userService.confirmEmail(email);

      if (confirm.status == 'success') {
        NotifyHelper.showSnackBar(LocaleKeys.confirmcodeContentSent.tr());
      } else {
        //NotifyHelper.showSnackBar('Gữi mã thất bại');
      }
    } catch (err) {
      //NotifyHelper.showSnackBar('nhập sai định dạng');
    }
    notifyListeners();
  }
}
