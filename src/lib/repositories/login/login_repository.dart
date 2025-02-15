import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/common/util/package_info/package_info_util.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_message_controller.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/login/login_request_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/restrain/restrain_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/login/login_service.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/apple/apple_login.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/google/google_login.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/kakao/kakao_login.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/naver/naver_login.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/social_login_service.dart';

class LoginRepository {
  late final LoginService _loginService; // = LoginService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);
  late SocialLoginService? _socialLoginService;
  final String provider;
  final Dio dio;

  // late UserModel? userModel;

  LoginRepository({
    required this.provider,
    required this.dio,
  }) {
    _loginService = LoginService(dio, baseUrl: memberBaseUrl);
    _socialLoginService = _setSocialLoginService(provider);
  }

  /// UserModel이 null이면 로그인 실패로 간주
  // Future<UserModel> login() async {
  //   if (await _socialLogin()) {
  //     UserModel? userModel = await _socialLoginService?.getUserInfo();
  //
  //     if (userModel == null) {
  //       // return null;
  //       ///TODO exception 고도화 필요
  //       throw 'Failed Social Login.(1)';
  //     }
  //
  //     return await loginByUserModel(userModel: userModel);
  //   } else {
  //     ///TODO exception 고도화 필요
  //     throw 'Failed Social Login.(2)';
  //   }
  // }

  Future<UserModel> socialLogin() async {
    if (await _socialLogin()) {
      UserModel? userModel = await _socialLoginService?.getUserInfo();

      if (userModel == null) {
        throw APIException(
          msg: 'Failed Social Login.(1)',
          code: 'ASL-9999', //App Social Login = ASL
          refer: 'LoginRepository',
          caller: 'socialLogin',
        );
      }

      return userModel;
    } else {
      throw APIException(
        msg: 'Failed Social Login.(2)',
        code: 'ASL-9998', //App Social Login = ASL
        refer: 'LoginRepository',
        caller: 'socialLogin',
      );
    }
  }

  Future<UserModel> loginByUserModel({required UserModel userModel}) async {
    var appKey = await GetIt.I.get<UuidUtil>().getUUID();
    String fcmToken;
    // if (Platform.isIOS) {
    //   ///TODO ios Push
    //   fcmToken = '1234565';
    // } else {
    //   fcmToken = GetIt.I.get<FireBaseMessageController>().fcmToken ?? '';
    // }

    fcmToken = GetIt.I.get<FireBaseMessageController>().fcmToken ?? '';

    LoginRequestModel reqModel = LoginRequestModel(
      id: userModel.id,
      simpleId: userModel.simpleId,
      simpleType: userModel.simpleType ?? provider,
      appKey: appKey,
      appVer: GetIt.I.get<PackageInformationUtil>().appVersion,
      fcmToken: fcmToken,
      isBadge: userModel.isBadge,
    );

    ResponseModel responseModel = await _loginService.socialLogin(reqModel.toJson());

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message,
        code: responseModel.code,
        refer: 'LoginRepository',
        caller: 'loginByUserModel',
        arguments: [
          userModel,
        ],
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'LoginRepository',
        caller: 'loginByUserModel',
      );
    }

    if (!responseModel.data!.containsKey('restrainList')) {
      throw APIException(
        msg: 'restrainList is null',
        code: responseModel.code,
        refer: 'LoginRepository',
        caller: 'loginByUserModel',
      );
    }

    const storage = FlutterSecureStorage();
    await storage.write(key: 'ACCESS_TOKEN', value: responseModel.data!['accessToken']);
    await storage.write(key: 'REFRESH_TOKEN', value: responseModel.data!['refreshToken']);

    print('asdasd');
    List<dynamic> restrainList = responseModel.data?['restrainList'] ?? [];
    print('asdasd 2222');
    final List<RestrainType> restrainTypeList = restrainList.map((e) => RestrainType.values[e]).toList();
    print('asdasd 3333');

    userModel = userModel.copyWith(appKey: appKey, restrainList: restrainTypeList);

    return userModel;
  }

  // LoginStatus parseResponse(ResponseModel responseModel) {
  //   switch (responseModel.code) {
  //     case 'ERES-9999':
  //       return LoginStatus.restriction;
  //     case 'EOUT-7777':
  //       return LoginStatus.withdrawalPending;
  //     default:
  //       return LoginStatus.failure;
  //   }
  // }

  String? _getMemberIdx(ResponseModel responseModel) {
    if (responseModel.data == null) {
      return null;
    }

    Map<String, dynamic> jsonData = {};
    if (responseModel.data == null) {
      ///TODO
      ///Error Proc
      return null;
    } else if (responseModel.data is Map) {
      jsonData = responseModel.data!;
    } else if (responseModel.data is String) {
      jsonData = jsonDecode(responseModel.data.toString());
    }

    if (jsonData.containsKey('memberIdx')) {
      return jsonData['memberIdx'].toString();
    } else {
      return null;
    }
  }

  Future<bool> logout() async {
    var responseModel = await _loginService.logout();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message,
        code: responseModel.code,
        refer: 'LoginRepository',
        caller: 'logout',
      );
    }

    await _socialLoginService!.logout();

    return responseModel.result;
  }

  Future<bool> _socialLogin() async {
    if (await _socialLoginService!.login()) {
      ///TODO
      ///Token is ""
      return true;
    }
    return false;
  }

  SocialLoginService? _setSocialLoginService(String provider) {
    SocialLoginService? socialService;
    switch (provider) {
      case "naver":
        socialService = NaverLoginService();
        break;
      case "kakao":
        socialService = KakaoLoginService();
        break;
      case "google":
        socialService = GoogleLoginService();
        break;
      case "apple":
        socialService = AppleLoginService();
        break;
      default:
        socialService = null;
        break;
    }

    return socialService;
  }

  ///NOTE
  ///Google, Apple 용
  ///카카오, 네이버는 필요 없음
  Future<String> getRefreshToken(String simpleType, String authCode) async {
    ResponseModel responseModel;

    print('authCode $authCode');

    String pkgName = GetIt.I<PackageInformationUtil>().pkgName;
    if (Platform.isAndroid) {
      pkgName = 'io.services';
    }

    if (pkgName.isEmpty) {
      pkgName = 'com.uxp.puppycat';
    }
    // return '';
    Map<String, dynamic> authMap = {
      'authorizationCode': authCode,
      'clientId': pkgName,
    };
    if (simpleType == 'google') {
      responseModel = await _loginService.getGoogleRefreshToken(authMap);
    } else if (simpleType == 'apple') {
      responseModel = await _loginService.getAppleRefreshToken(authMap);
    } else {
      return '';
    }

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message,
        code: responseModel.code,
        refer: 'LoginRepository',
        caller: 'getRefreshToken',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'LoginRepository',
        caller: 'getRefreshToken',
      );
    }

    if (!responseModel.data!.containsKey('refreshToken')) {
      throw APIException(
        msg: 'refreshToken is null',
        code: responseModel.code,
        refer: 'LoginRepository',
        caller: 'getRefreshToken',
      );
    }

    return responseModel.data!['refreshToken'];
  }
}
