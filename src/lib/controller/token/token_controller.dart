import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///NOTE
///퍼피캣  JWT 관리
class TokenController {
  static const storage = FlutterSecureStorage();
  static const String refreshTokenName = 'REFRESH_TOKEN';
  static const String accessTokenName = 'ACCESS_TOKEN';
  static String? _refreshToken;

  static Future<bool> checkRefreshToken() async {
    if (await readRefreshToken() == null) {
      return false;
    } else {
      return true;
    }
  }

  static Future readStorage({required String key}) async {
    return await storage.read(key: key);
  }

  static Future writeRefreshToken(String token) async {
    await writeStorage(key: refreshTokenName, value: token);
  }

  static Future clearStorage({required String key}) async {
    await storage.delete(key: key);
  }

  static Future<String?> readRefreshToken() async {
    String? token = _refreshToken;

    token ??= await readStorage(key: refreshTokenName);

    if (token != null) {
      _refreshToken = token;
    }

    return token;
  }

  static Future<String?> readAccessToken() async {
    String? accessToken = await readStorage(key: accessTokenName);
    return accessToken;
  }

  static Future writeStorage({required String key, required String value}) async {
    await storage.write(key: key, value: value);
  }

  static Future writeAccessToken(String token) async {
    await writeStorage(key: accessTokenName, value: token);
  }

  static Future writeTokens(String accessToken, String refreshToken) async {
    await writeAccessToken(accessToken);
    await writeRefreshToken(refreshToken);
  }

  static Future clearAccessToken() async {
    await clearStorage(key: accessTokenName);
  }

  static Future clearRefreshToken() async {
    await clearStorage(key: refreshTokenName);
  }

  static Future clearTokens() async {
    await clearAccessToken();
    await clearRefreshToken();
  }
}
