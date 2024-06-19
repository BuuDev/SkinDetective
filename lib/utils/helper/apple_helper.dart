part of './helper.dart';

class AppleAuthHelper {
  static const keyId = '4GKAF2NUL3';
  static const teamId = '62T4L8KE75';
  static const audience = 'https://appleid.apple.com';
  static const algorithm = 'ES256';
  static const validDuration = 3600 * 10;

  static Future<String> pemKey() async {
    var bytes = await rootBundle.load(Assets.keys.authKey);
    String dir = await Helper.projectFolder();
    final buffer = bytes.buffer;
    return (await File('$dir/AuthKey').writeAsBytes(
            buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes)))
        .readAsStringSync();
  }

  static Future<String> appleClientSecret(String clientId) async {
    String privateKey = (await pemKey());

    final jwk = JsonWebKey.fromPem(privateKey, keyId: keyId);

    final claims = JsonWebTokenClaims.fromJson({
      'iss': teamId,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 + validDuration,
      'aud': audience,
      'sub': clientId,
    });

    final builder = JsonWebSignatureBuilder()
      ..jsonContent = claims.toJson()
      ..addRecipient(jwk, algorithm: algorithm);
    return builder.build().toCompactSerialization();
  }
}
