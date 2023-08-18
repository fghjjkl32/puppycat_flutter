import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/social_login_service.dart';

class NaverLoginService implements SocialLoginService {
  late NaverAccountResult _accountResult;
  late NaverAccessToken _accessToken;

  @override
  Future<UserModel?> getUserInfo() async {
    if (_accessToken == null || _accountResult == null) {
      return null;
    }

    UserModel? userModel = UserModel(
      loginStatus: LoginStatus.none,
      idx: 0,
      nick: _accountResult.nickname,

      id: _accountResult.email,
      // id: "thirdnso2v@gmail.com",
      simpleId: _accountResult.id,
      refreshToken: _accessToken.refreshToken,
      isSimple: 1,
      simpleType: 'naver',
      accessToken: _accessToken.accessToken,
      password: _accountResult.id,
      passwordConfirm: _accountResult.id, isBadge: 0,
    );

    return userModel;
  }

  @override
  Future<bool> login() async {
    NaverLoginResult res = await FlutterNaverLogin.logIn();
    if (res.status != NaverLoginStatus.loggedIn) {
      return false;
    }
    _accountResult = res.account;
    _accessToken = await FlutterNaverLogin.currentAccessToken;

    return true;
  }

  @override
  Future logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
