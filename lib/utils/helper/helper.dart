import 'package:flutter/material.dart'
    show BuildContext, MediaQuery, Size, Widget, WidgetsBinding, debugPrint;
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/widgets/loading/loading.dart';
import 'package:jose/jose.dart';
import 'dart:io';
import 'package:intl/intl.dart';

part './apple_helper.dart';

class Helper {
  static Size screenOfDesigner = const Size(375, 812);

  static String getValueEnum(Enum _enum) {
    return _enum.toString().split(".").last;
  }

  static String toMoneyFormat(String x) {
    var f = NumberFormat("###,###,###,###", "en_US");
    return f.format(double.parse(x));
  }

  static String currencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'VND':
        return 'đ';
      default:
        return '';
    }
  }

  static double percentHeight({
    required double pixel,
    BuildContext? context,
  }) {
    double screenHeight;

    if (context != null) {
      screenHeight = MediaQuery.of(context).size.height;
    } else {
      screenHeight = WidgetsBinding.instance!.window.physicalSize.height;
    }

    return (pixel / screenOfDesigner.height) * screenHeight;
  }

  static double percentWidth({
    required double pixel,
    BuildContext? context,
  }) {
    double screenWidth;

    if (context != null) {
      screenWidth = MediaQuery.of(context).size.width;
    } else {
      screenWidth = WidgetsBinding.instance!.window.physicalSize.width;
    }

    return (pixel / screenOfDesigner.width) * screenWidth;
  }

  static double percentWidth2({
    BuildContext? context,
  }) {
    double screenWidth;

    if (context != null) {
      screenWidth = MediaQuery.of(context).size.width;
    } else {
      screenWidth = WidgetsBinding.instance!.window.physicalSize.width;
    }

    return screenWidth / 3;
  }

  static Future<GoogleSignInAuthentication?> loginByGoogle(
      BuildContext context) async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );
      Loading.show();
      await _googleSignIn.signOut();
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        debugPrint('User cancel');
        Loading.hide();
        return Future.value();
      }

      var auth = await account.authentication;
      debugPrint('token: ${auth.accessToken}');
      Loading.hide();
      if (auth.accessToken == null) {
        return Future.value();
      }

      return Future.value(auth);
    } on PlatformException catch (error) {
      debugPrint('PlatformException: $error');
      Loading.hide();
      throw 'Đã xảy ra lỗi';
    } catch (error) {
      Loading.hide();
      throw 'Đã xảy ra lỗi';
    }
  }

  static Future<AuthorizationCredentialAppleID?> loginApple(
      BuildContext context) async {
    try {
      Loading.show();
      if (await SignInWithApple.isAvailable()) {
        var info = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );
        Loading.hide();
        return Future.value(info);
      }
    } on PlatformException catch (error) {
      debugPrint('${error.stacktrace}');
    } catch (error) {
      debugPrint('$error');
    }
    Loading.hide();
    throw 'Đăng nhập thất bại';
  }

  static Future<AccessToken?> loginWithFacebook(BuildContext context) async {
    try {
      Loading.show();
      await FacebookAuth.instance.logOut();
      final LoginResult result = await FacebookAuth.instance.login();
      Loading.hide();
      if (result.status == LoginStatus.success) {
        // you are logged
        final AccessToken accessToken = result.accessToken!;
        debugPrint('token: ${accessToken.token}');
        return Future.value(accessToken);
      } else {
        debugPrint('Login fail: ${result.message}');
        return Future.value();
      }
    } on PlatformException catch (error) {
      debugPrint('${error.stacktrace}');
    } catch (error) {
      debugPrint('$error');
    }
    Loading.hide();
    throw 'Đăng nhập thất bại';
  }

  // Getting project folder using introspection instead of Platform.script
  // so that it works with unit testing as well
  static Future<String> projectFolder() async {
    String path = (await getApplicationDocumentsDirectory()).path;
    return path;
  }

  static Future<File> convertByteDataToFile(ByteData data) async {
    var tempDir = await getTemporaryDirectory();
    final buffer = data.buffer;
    return File('${tempDir.path}/${DateTime.now().toIso8601String()}.jpg')
        .writeAsBytes(
            buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  static Future<ByteData> convertFileToByteData(File file) async {
    return (await file.readAsBytes()).buffer.asByteData();
  }

  static List<Widget> mapWidgets<T>({
    required List<T> data,
    required Widget Function(T item, int index) render,
  }) {
    List<Widget> widgets = [];
    for (var i = 0; i < data.length; i++) {
      widgets.add(render(data[i], i));
    }
    return widgets;
  }

  static double ratingRound(double _input, [int bc = 5]) {
    int input = (_input * 10).toInt();

    int mod = input % bc;

    num result = input ~/ bc * bc + (mod > 0 ? bc : 0);

    return result / 10;
  }
}

double insetsBottom([BuildContext? context]) {
  if (context == null) {
    return WidgetsBinding.instance!.window.padding.bottom;
  }
  return MediaQuery.of(context).viewPadding.bottom;
}

double insetsTop([BuildContext? context]) {
  if (context == null) {
    return WidgetsBinding.instance!.window.padding.top;
  }
  return MediaQuery.of(context).viewPadding.bottom;
}
