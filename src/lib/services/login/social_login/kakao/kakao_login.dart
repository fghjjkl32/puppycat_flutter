import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:pet_mobile_social_flutter/models/login/login_request_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/social_login_service.dart';

class KakaoLoginService implements SocialLoginService {
  OAuthToken? _accessToken;

  OAuthToken? get accessToken => _accessToken;

  KakaoLoginService() {
    KakaoSdk.init(
      nativeAppKey: '7c08c783bcbdb1ef34a88b51e2dc0fde',
      loggingEnabled: false,
    );
  }

  @override
  Future<dynamic> logout() async {
    try {
      await UserApi.instance.logout();
      print('로그아웃 성공, SDK에서 토큰 삭제');
    } catch (error) {
      print('로그아웃 실패, SDK에서 토큰 삭제 $error');
    }
  }

  @override
  Future<bool> login() async {
    if (await isKakaoTalkInstalled()) {
      try {
        _accessToken = await UserApi.instance.loginWithKakaoTalk();
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return false;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          _accessToken = await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공2');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
          return false;
        }
      }
    } else {
      try {
        _accessToken = await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공3');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
        return false;
      }
    }

    return true;
  }

  @override
  Future<UserModel?> getUserInfo() async {
    if (_accessToken == null) {
      return null;
    }

    User userInfo = await UserApi.instance.me();

    UserModel userModel = UserModel(
      loginStatus: LoginStatus.none,
      idx: 0,
      nick: userInfo.kakaoAccount?.name ?? '',

      id: userInfo.kakaoAccount?.email ?? 'thirdnsov.dev@gmail.com',
      // id: "thirdnso2v@gmail.com",
      simpleId: userInfo.id.toString(),
      refreshToken: _accessToken?.refreshToken?? '',
      isSimple: 1,
      simpleType: 'kakao',
      accessToken: _accessToken?.accessToken ?? '',
      password: userInfo.id.toString(),
      passwordConfirm: userInfo.id.toString(),
    );

    return userModel;
  }
}
