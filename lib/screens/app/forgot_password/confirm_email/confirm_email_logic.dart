part of 'confirm_email.dart';

class ConfirmEmailLogic extends ChangeNotifier {
  final BuildContext context;
  ConfirmEmailLogic({required this.context}); //note
  TextEditingController emailController = TextEditingController();
  String? err;
  bool enable = false;
  final UserService _userService = UserService.client();

  void validateEmail() {
    if (!Validate.isEmail(emailController.text)) {
      err = LocaleKeys.emailFormatErrorMess.tr();
      enable = false;
    } else {
      err = null;
      enable = true;
    }
    if (emailController.text.isEmpty) {
      err = null;
      enable = false;
    }
    notifyListeners();
  }

  Future<void> confirmEmail(String email) async {
    try {
      var confirm = await _userService.confirmEmail(email);

      if (confirm.status == 'success') {
        Navigator.pushNamed(context, AppRoutes.authenOtpPassword,
            arguments: emailController.text);
      } else {
        NotifyHelper.showSnackBar(LocaleKeys.signupEmailFalseRegistered.tr());
      }
    } catch (err) {
      //NotifyHelper.showSnackBar('nhập sai định dạng');
    }
    notifyListeners();
  }
}
