import 'dart:convert';

import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/social_login_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginService implements SocialLoginService {
  late AuthorizationCredentialAppleID _accountResult;
  late String? email;
  late String? simpleId;

  @override
  Future<UserModel?> getUserInfo() async {
    if (email == null) {
      List<String> jwt = _accountResult.identityToken?.split('.') ?? [];
      String payload = jwt[1];
      payload = base64.normalize(payload);

      final List<int> jsonData = base64.decode(payload);
      final userInfo = jsonDecode(utf8.decode(jsonData));
      email = userInfo['email'];
      simpleId = userInfo['sub'];
    }

    if (_accountResult == null) {
      return null;
    }

    UserModel? userModel = UserModel(
      // loginStatus: LoginStatus.none,
      idx: 0,
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
      isBadge: 0, uuid: "",
      channelTalkHash: '',
    );

    return userModel;
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
          clientId: "io.services",
          redirectUri: Uri.parse(
            "https://lime-peppermint-poppy.glitch.me/callbacks/sign_in_with_apple",
          ),
        ),
      );
      _accountResult = token;
      email = token.email;

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
