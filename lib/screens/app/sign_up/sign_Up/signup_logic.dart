part of '../signup_email_test_error.dart';

class SignUpLogic with ChangeNotifier {
  final BuildContext context;
  SignUpLogic({required this.context});
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String? errorPassword;
  String? errorConfirmPassword;
  String? errorEmail;
  bool enable = false;
  final UserService _userSv = UserService.client();

  ValueNotifier<bool> check = ValueNotifier(false);
  bool checkError = false;

  void validatePass() {
    if (passwordController.text.length < 6 && passwordController.text != "") {
      if (passwordController.text.contains(" ")) {
        errorPassword = LocaleKeys.signupMessagePasswordNull.tr();
        return;
      }

      errorPassword = LocaleKeys.signupMessagePasswordMaxLength6.tr();
      notifyListeners();
    } else if (passwordController.text.isEmpty ||
        passwordController.text.length >= 6) {
      if (passwordController.text.contains(" ")) {
        errorPassword = LocaleKeys.signupMessagePasswordNull.tr();
        return;
      }
      errorPassword = null;
      notifyListeners();
    }
  }

  dynamic validateConfirmPass() {
    if (passwordController.text != confirmPasswordController.text) {
      if (confirmPasswordController.text.isEmpty ||
          passwordController.text.isEmpty) {
        errorConfirmPassword = null;
        notifyListeners();
        return false;
      }
      checkError = true;

      errorConfirmPassword = LocaleKeys.signupMessagePasswordConfirm.tr();
    } else {
      if (confirmPasswordController.text.contains(" ")) {
        errorConfirmPassword = LocaleKeys.signupMessagePasswordConfirm.tr();
        notifyListeners();
        return;
      }
      checkError = false;
      errorConfirmPassword = null;
    }
    notifyListeners();
  }

  void validateSignUp() {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
    } else {
      if (!check.value) {}
    }
  }

  void validateEmail() {
    if (!Validate.isEmail(emailController.text)) {
      errorEmail = LocaleKeys.emailFormatErrorMess.tr();
      notifyListeners();
    } else {
      errorEmail = null;
      notifyListeners();
    }
    if (emailController.text.isEmpty) {
      errorEmail = null;
      notifyListeners();
    }
  }

  void enableBtnRegister() {
    if (errorEmail == null &&
        errorPassword == null &&
        errorConfirmPassword == null &&
        check.value &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      enable = true;
      notifyListeners();
    } else {
      enable = false;
      notifyListeners();
    }
  }

  void checkedSuccessSignUp() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      return;
    }
    if (!checkError &&
        check.value &&
        errorEmail == null &&
        errorPassword == null &&
        errorConfirmPassword == null) {
      try {
        await _userSv.register(
          emailController.text,
          passwordController.text,
        );
        Navigator.pushNamed(context, AppRoutes.authenOtp,
            arguments: [emailController.text, passwordController.text]);
      } catch (e) {
        debugPrint(e.toString());
        NotifyHelper.showSnackBar(
            LocaleKeys.signupMessageEmailAlreadyExists.tr());
      }
    } else {
      return null;
    }
    notifyListeners();
  }
}
