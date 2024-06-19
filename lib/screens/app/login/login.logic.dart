part of 'login.dart';

class LoginLogic with ChangeNotifier {
  final BuildContext context;
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: "");
  final UserService _userService = UserService.client();

  Timer? _timer;
  bool enableBtnLogin = ClientApi.mode() == EnvironmentMode.dev;

  LoginLogic({required this.context}) : super() {
    if (ClientApi.mode() == EnvironmentMode.dev) {
      _emailController.text = 'testskin2022@gmail.com';
      _passwordController.text = "abc@123";
    }
  }

  String? onValidatorEmail(String? text) {
    if (text!.isNotEmpty) {
      if (!Validate.isEmail(text)) {
        return LocaleKeys.emailFormatErrorMess.tr();
      }
    }
    return null;
  }

  Future<void> _loginUser() async {
    FocusScope.of(context).requestFocus(FocusNode());
    // Call API.
    try {
      var info = await _userService.getLogin(
          _emailController.text, _passwordController.text);
      GetIt.instance<AppVM>().loginSuccess(info);
    } on DioError catch (err) {
      debugPrint("In File: login.logic.dart, Line: 45 $err");
      NotifyHelper.showSnackBar(
          LocaleKeys.loginMessageErrorEmailOrPassword.tr());
    }
  }

  String? onValidatorPassword(String? text) {
    return null;
  }

  void updateEmail(String email) {
    enableBtnLogin =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    notifyListeners();
  }

  void updatePassword(String password) {
    enableBtnLogin =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    notifyListeners();
  }

  bool checkLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      NotifyHelper.showSnackBar(LocaleKeys.loginMessageErrorInfoNull.tr());
      return false;
    }
    return true;
  }

  void loginByGoogle() async {
    try {
      var googleInfo = await Helper.loginByGoogle(context);
      if (googleInfo != null && googleInfo.accessToken != null) {
        debugPrint('token: ${googleInfo.accessToken}');
        var info =
            await UserService.client().loginByGoogle(googleInfo.accessToken!);
        GetIt.instance<AppVM>().loginSuccess(info);
      } else {
        NotifyHelper.showSnackBar(LocaleKeys.loginMessageErrorLoginGmail.tr());
      }
    } on PlatformException catch (error) {
      debugPrint('$error');
    }
  }

  void loginWithFacebook() async {
    try {
      var facebookInfo = await Helper.loginWithFacebook(context);
      if (facebookInfo != null) {
        debugPrint('token: ${facebookInfo.token}');
        var info =
            await UserService.client().loginByFacebook(facebookInfo.token);
        GetIt.instance<AppVM>().loginSuccess(info);
      }
    } catch (_) {}
  }

  void loginWithApple() async {
    try {
      var credential = await Helper.loginApple(context);

      if ((credential?.authorizationCode ?? '').isNotEmpty) {
        String clientId = (await PackageInfo.fromPlatform()).packageName;
        var info = await UserService.client().loginByApple({
          "client_secret": await AppleAuthHelper.appleClientSecret(clientId),
          "client_id": clientId,
          "grant_type": "authorization_code",
          "code": credential!.authorizationCode,
          "user_identifier": credential.userIdentifier,
          "email": credential.email ?? '',
          "firstName": credential.givenName ?? '',
          "lastName": credential.familyName ?? '',
        });
        GetIt.instance<AppVM>().loginSuccess(info);
      }
    } catch (e) {
      debugPrint('login apple: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }
    super.dispose();
  }
}
