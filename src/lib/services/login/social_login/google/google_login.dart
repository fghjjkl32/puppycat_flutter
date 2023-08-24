import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/social_login_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginService implements SocialLoginService {
  late GoogleSignIn _googleSignIn;
  late GoogleSignInAccount? _accountResult;
  late GoogleSignInAuthentication _authentication;

  GoogleLoginService() {
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
  }

  @override
  Future<UserModel?> getUserInfo() async {
    if (_authentication == null || _accountResult == null) {
      return null;
    }

    UserModel? userModel = UserModel(
      loginStatus: LoginStatus.none,
      idx: 0,
      nick: '',

      id: _accountResult!.email,
      // id: "thirdnso2v@gmail.com",
      simpleId: _accountResult!.id,
      refreshToken: _authentication!.idToken ?? '',
      isSimple: 1,
      simpleType: 'google',
      accessToken: _authentication!.accessToken ?? '',
      password: _accountResult!.id,
      passwordConfirm: _accountResult!.id, isBadge: 0,
    );

    return userModel;
  }

  @override
  Future<bool> login() async {
    try {
      _accountResult = await _googleSignIn.signIn();
      if (_accountResult == null) {
        return false;
      }
      _authentication = await _accountResult!.authentication;
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
