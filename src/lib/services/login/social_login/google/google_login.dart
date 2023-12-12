import 'package:google_sign_in/google_sign_in.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/social_login_service.dart';

class GoogleLoginService implements SocialLoginService {
  late GoogleSignIn _googleSignIn;
  late GoogleSignInAccount? _accountResult;
  late GoogleSignInAuthentication _authentication;

  GoogleLoginService() {
    _googleSignIn = GoogleSignIn(
      // forceCodeForRefreshToken: true,
      clientId: "14263543464-mt3majukl2io6fqllr24eh6egoc1fv5a.apps.googleusercontent.com",
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    ///NOTE
    ///구글 계정 여러개 사용 시 계정 선택을 할 수 있게 하기 위함
    _googleSignIn.disconnect();
  }

  @override
  Future<UserModel?> getUserInfo() async {
    if (_authentication == null || _accountResult == null) {
      return null;
    }

    UserModel? userModel = UserModel(
      // loginStatus: LoginStatus.none,
      idx: 0,
      nick: '',

      id: _accountResult!.email,
      // id: "thirdnso2v@gmail.com",
      simpleId: _accountResult!.id,
      refreshToken: _accountResult!.serverAuthCode ?? '',
      isSimple: 1,
      simpleType: 'google',
      accessToken: _authentication!.accessToken ?? '',
      password: _accountResult!.id,
      passwordConfirm: _accountResult!.id,
      isBadge: 0,
      uuid: "",
      channelTalkHash: '',
    );

    return userModel;
  }

  @override
  Future<bool> login() async {
    try {
      _accountResult = await _googleSignIn.signIn();
      print("_authentication!.idToken ${_accountResult!.serverAuthCode}");
      if (_accountResult == null) {
        return false;
      }
      _authentication = await _accountResult!.authentication;

      print('_authentication $_authentication');

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  @override
  Future logout() async {
    await _googleSignIn.signOut();
  }
}
