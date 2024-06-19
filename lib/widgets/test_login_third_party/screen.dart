import 'package:flutter/material.dart';
import 'package:skin_detective/utils/helper/helper.dart';
import 'package:skin_detective/widgets/buttons_login/buttons_login.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TestLoginThirdParty extends StatefulWidget {
  const TestLoginThirdParty({Key? key}) : super(key: key);

  @override
  State<TestLoginThirdParty> createState() => _TestLoginThirdPartyState();
}

class _TestLoginThirdPartyState extends State<TestLoginThirdParty> {
  ValueNotifier<String> tokenGoogle = ValueNotifier('');
  ValueNotifier<String> tokenFacebook = ValueNotifier('');
  ValueNotifier<String> tokenApple = ValueNotifier('');

  void loginByGoogle() async {
    try {
      var token = await Helper.loginByGoogle(context);
      tokenGoogle.value = token?.accessToken ?? '';
    } catch (e) {
      debugPrint('$e');
    }
  }

  void loginByFacebook() async {
    try {
      var token = await Helper.loginWithFacebook(context);
      tokenFacebook.value = token?.token ?? '';
    } catch (e) {
      debugPrint('$e');
    }
  }

  void loginByApple() async {
    try {
      var credential = await Helper.loginApple(context);
      // tokenApple.value = credential?.authorizationCode ?? '';

      String clientId = (await PackageInfo.fromPlatform()).packageName;

      tokenApple.value = """{
        "client_secret": "${await AppleAuthHelper.appleClientSecret(clientId)}",
        "client_id": "$clientId",
        "grant_type": "authorization_code",
        "code": "${credential!.authorizationCode}",
        "user_identifier": "${credential.userIdentifier}",
        "email": "${credential.email ?? ''}",
        "firstName": "${credential.givenName ?? ''}",
        "lastName": "${credential.familyName ?? ''}",
      }""";
    } catch (e) {
      debugPrint('loginApple: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('Google token: '),
            const SizedBox(height: 20),
            ValueListenableBuilder<String>(
                valueListenable: tokenGoogle,
                builder: (_, token, __) {
                  return SelectableText(token);
                }),
            const SizedBox(height: 20),
            LoginButton(
              typeButton: ButtonLoginType.google,
              onPress: loginByGoogle,
            ),
            const SizedBox(height: 20),
            const Text('Facebook token: '),
            const SizedBox(height: 20),
            ValueListenableBuilder<String>(
                valueListenable: tokenFacebook,
                builder: (_, token, __) {
                  return SelectableText(token);
                }),
            const SizedBox(height: 20),
            LoginButton(
              typeButton: ButtonLoginType.facebook,
              onPress: loginByFacebook,
            ),
            const SizedBox(height: 20),
            const Text('Apple token: '),
            const SizedBox(height: 20),
            ValueListenableBuilder<String>(
                valueListenable: tokenApple,
                builder: (_, token, __) {
                  return SelectableText(token);
                }),
            const SizedBox(height: 20),
            LoginButton(
              typeButton: ButtonLoginType.apple,
              onPress: loginByApple,
            ),
          ],
        ),
      ),
    );
  }
}
