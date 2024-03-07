import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/social_login_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginService implements SocialLoginService {
  late AuthorizationCredentialAppleID _accountResult;
  late String? email;
  late String? simpleId;

  @override
  Future<UserModel?> getUserInfo() async {
    try {
      List<String> jwt = _accountResult.identityToken?.split('.') ?? [];
      String payload = jwt[1];
      payload = base64.normalize(payload);

      final List<int> jsonData = base64.decode(payload);
      final Map<String, dynamic> userInfo = jsonDecode(utf8.decode(jsonData));

      if (userInfo.containsKey('email')) {
        email = userInfo['email'];
      }

      if (userInfo.containsKey('sub')) {
        simpleId = userInfo['sub'];
      }

      if (email == null || simpleId == null) {
        print('Apple login getUserInfo Error.(1)');
        return null;
      }

      print('userInfo11111 $userInfo');
      print('identityToken ${_accountResult.identityToken}');
      print('authorizationCode ${_accountResult.authorizationCode}');

      UserModel? userModel = UserModel(
        nick: "",
        id: email!,
        // id: "thirdnso2v@gmail.com",
        simpleId: simpleId!,
        refreshToken: _accountResult.authorizationCode,
        isSimple: 1,
        simpleType: 'apple',
        accessToken: _accountResult.authorizationCode,
        password: simpleId!,
        passwordConfirm: simpleId!,
        isBadge: 0,
        uuid: "",
        channelTalkHash: '',
      );

      return userModel;
    } catch (e) {
      print('Apple login getUserInfo Error $e');
      return null;
    }
  }

  @override
  Future<bool> login() async {
    try {
      final token = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: dotenv.env['APPLE_CLIENT_ID']!,
          redirectUri: Uri.parse(dotenv.env['APPLE_REDIRECT_URI']!),
        ),
      );
      print('tokenaaaa : $token');
      _accountResult = token;
      // email = token.email;

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  @override
  Future logout() async {
    await Duration.zero;
  }
}
