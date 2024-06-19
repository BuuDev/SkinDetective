part of 'reset_password.dart';

class ResetPassWordLogic extends ChangeNotifier {
  final BuildContext context;
  ResetPassWordLogic({required this.context});

  TextEditingController txtOldPass = TextEditingController();
  TextEditingController txtNewPass = TextEditingController();
  TextEditingController txtConfirmPass = TextEditingController();
  final UserService _userService = UserService.client();
  String? err;
  bool enable = false;
  String? err1;
  String? err2;

  void validatePassWord() {
    if (txtNewPass.text.length < 6) {
      if (txtNewPass.text.contains(" ")) {
        err = LocaleKeys.rePasswordErrorMessSpace.tr();
        enable = false;
      } else if (txtNewPass.text.tr().isEmpty) {
        err = null;
        enable = false;
      } else {
        err = LocaleKeys.rePasswordErrorMess6.tr();
        enable = false;
      }
    } else if (txtNewPass.text.length >= 6) {
      validateConfirmPassWord();
      err = null;
    } else {
      if (txtOldPass.text.isEmpty ||
          txtNewPass.text.contains(" ") ||
          txtConfirmPass.text.isEmpty ||
          txtNewPass.text.isEmpty) {
        enable = false;
      } else {
        enable = true;
        err = null;
      }
    }

    notifyListeners();
  }

  void validateOldPassWord() {
    if (txtOldPass.text.isEmpty ||
        txtNewPass.text.contains(" ") ||
        txtConfirmPass.text.isEmpty ||
        txtNewPass.text.isEmpty) {
      enable = false;
    } else {
      enable = true;
    }
    notifyListeners();
  }

  void validateConfirmPassWord() {
    if (txtNewPass.text != txtConfirmPass.text) {
      enable = false;

      err1 = LocaleKeys.rePasswordErrorMess.tr();
      if (txtConfirmPass.text.tr().isEmpty) {
        err1 = null;
        enable = false;
      }
    } else {
      enable = true;
      err1 = null;
    }
    notifyListeners();
  }

  void changePassword() async {
    try {
      await _userService.changePassWord(
          txtOldPass.text, txtNewPass.text, txtConfirmPass.text);
      clear();

      FocusScope.of(context).unfocus();

      NotifyHelper.showSnackBar(LocaleKeys.rePasswordSuccess.tr());
      notifyListeners();
    } catch (err) {
      NotifyHelper.showSnackBar(LocaleKeys.rePasswordErrOld.tr());
      debugPrint('$err');
    }
  }

  void clear() async {
    txtNewPass.clear();
    txtOldPass.clear();
    txtConfirmPass.clear();

    enable = false;
    notifyListeners();
  }
}
