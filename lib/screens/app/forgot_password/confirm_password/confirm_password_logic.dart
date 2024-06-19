part of 'confirm_password.dart';

class ResetPassWord extends ChangeNotifier {
  final BuildContext context;
  ResetPassWord({required this.context});
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  final UserService _userService = UserService.client();
  String? err;
  String? err1;
  bool enable = false;

  Future<void> resetPassWord(
      String email, String token, String password) async {
    try {
      var confirm = await _userService.resetPassword(email, token, password);
      if (confirm.status == 'success') {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.loginPage, (route) => false);
      }
    } catch (err) {
      debugPrint('$err');
    }
    notifyListeners();
  }

  void validatePassWord() {
    if (password.text.length < 6) {
      if (password.text.contains(" ")) {
        err = LocaleKeys.rePasswordErrorMessSpace.tr();
        enable = false;
      }

      err = LocaleKeys.rePasswordErrorMess6.tr();
      enable = false;
    } else {
      err = null;
    }
    notifyListeners();
  }

  void validateConfirmPassWord() {
    if (password.text != confirmPassword.text) {
      enable = false;

      err1 = LocaleKeys.signupMessagePasswordConfirm.tr();
    } else {
      enable = true;
      err1 = null;
    }
    notifyListeners();
  }
}
