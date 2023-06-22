
import 'package:pet_mobile_social_flutter/models/login/login_request_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';

abstract class SocialLoginService {
  Future<bool> login();
  Future<dynamic> logout();
  Future<UserModel?> getUserInfo();
}