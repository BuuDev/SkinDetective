part of 'sign_up_authen_otp.dart';

class LogicAuthen extends ChangeNotifier {
  final BuildContext context;
  LogicAuthen({required this.context});

  final UserService _userService = UserService.client();

  OtpFieldController otpController1 = OtpFieldController();

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

  Future<void> authenOtp(String emailController, String otpAuthenController,
      String passwordController) async {
    try {
      var info1 =
          await _userService.verifyOtp(emailController, otpAuthenController);
      GetIt.instance<AppVM>().loginSuccess(info1);
    } catch (err) {
      NotifyHelper.showSnackBar(LocaleKeys.signupEmailFalseOTP.tr());
    }
    notifyListeners();
  }

  Future<void> confirmEmail(String email, String pass) async {
    try {
      await _userService.register(email, pass);
    } catch (err) {
      //NotifyHelper.showSnackBar('nhập sai định dạng');
    }
    notifyListeners();
  }
}
