import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/common/util/PackageInfo/package_info_util.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/login/login_request_model.dart';
import 'package:pet_mobile_social_flutter/models/login/login_response_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/login/login_service.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/google/google_login.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/kakao/kakao_login.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/naver/naver_login.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/social_login_service.dart';

// final loginRepositoryProvider = Provider((ref) => LoginRepository(provider: ''));

// final accountRestoreProvider = StateProvider.family<Future<bool>, (String, String)>((ref, restoreInfo) {
//   return ref.read(accountRepositoryProvider).restoreAccount(restoreInfo.$1, restoreInfo.$2);
// });

final loginRepositoryProvider = StateProvider.family<LoginRepository, String>(
    (ref, provider) => LoginRepository(provider: provider));

class LoginRepository {
  final LoginService _loginService = LoginService(DioWrap.getDioWithCookie());
  late SocialLoginService? _socialLoginService;
  final String provider;

  // late UserModel? userModel;

  LoginRepository({
    required this.provider,
  }) {
    _socialLoginService = _setSocialLoginService(provider);
  }

  /// UserModel이 null이면 로그인 실패로 간주
  Future<UserModel?> login() async {
    if (await _socialLogin()) {
      UserModel? userModel = await _socialLoginService?.getUserInfo();

      if (userModel == null) {
        return null;
      }

      var appKey = await GetIt.I.get<UuidUtil>().getUUID();
      LoginRequestModel reqModel = LoginRequestModel(
        id: userModel!.id,
        // id: 'thirdnsov4@gmail.com',
        simpleId: userModel!.simpleId,
        // simpleId: '2809229088121356223',
        simpleType: userModel!.simpleType ?? provider,
        appKey: appKey,
        appVer: GetIt.I.get<PackageInformationUtil>().appVersion,
        // domain: "11",
        fcmToken: "12343535463",
      );

      // var isNeedSignUp = false;
      LoginStatus loginStatus = LoginStatus.success;
      ResponseModel? result = await _loginService
          .socialLogin(reqModel.toJson())
          .catchError((Object obj) async {
        (ResponseModel?, LoginStatus) errorResult = await errorHandler(obj);
        var responseModel = errorResult.$1;
        loginStatus = errorResult.$2;

        print('loginStatus $loginStatus');

        return responseModel;
      });

      if (result == null) {
        ///TODO
        ///result == null 이면 실제 통신 에러 발생으로 추측할 수 있음
        return null;
      }

      if (!result!.result && loginStatus != LoginStatus.needSignUp) {
        loginStatus = parseResponse(result);
      }

      print('result : $result');

      print('loginStatus 2 $loginStatus');
      userModel = userModel.copyWith(
          loginStatus: loginStatus,
          idx: int.parse(_getMemberIdx(result) ?? '0'),
          appKey: appKey);

      return userModel;
    } else {
      return null;
    }
  }

  Future<UserModel?> loginByUserModel({required UserModel userModel}) async {
    // UserModel? userModel = await _socialLoginService?.getUserInfo();

    var appKey = await GetIt.I.get<UuidUtil>().getUUID();
    LoginRequestModel reqModel = LoginRequestModel(
      id: userModel!.id,
      // id: 'thirdnsov4@gmail.com',
      simpleId: userModel!.simpleId,
      // simpleId: '2809229088121356223',
      simpleType: userModel!.simpleType ?? provider,
      appKey: appKey,
      appVer: GetIt.I.get<PackageInformationUtil>().appVersion,
      // domain: "11",
      fcmToken: "12343535463",
    );

    // var isNeedSignUp = false;
    LoginStatus loginStatus = LoginStatus.success;
    ResponseModel? result = await _loginService
        .socialLogin(reqModel.toJson())
        .catchError((Object obj) async {
      (ResponseModel?, LoginStatus) errorResult = await errorHandler(obj);
      var responseModel = errorResult.$1;
      loginStatus = errorResult.$2;

      print('loginStatus $loginStatus');

      return responseModel;
    });

    if (result == null) {
      ///TODO
      ///result == null 이면 실제 통신 에러 발생으로 추측할 수 있음
      return null;
    }

    if (!result!.result && loginStatus != LoginStatus.needSignUp) {
      loginStatus = parseResponse(result);
    }

    print('result : $result');

    print('loginStatus 2 $loginStatus');
    userModel = userModel.copyWith(
        loginStatus: loginStatus,
        idx: int.parse(_getMemberIdx(result) ?? '0'),
        appKey: appKey);
    print('userModel $userModel');

    return userModel;
  }

  LoginStatus parseResponse(ResponseModel responseModel) {
    switch (responseModel.code) {
      case 'ERES-9999':
        return LoginStatus.restriction;
      case 'EOUT-7777':
        return LoginStatus.withdrawalPending;
      default:
        return LoginStatus.failure;
    }
  }

  String? _getMemberIdx(ResponseModel responseModel) {
    if (responseModel.data == null) {
      return null;
    }

    Map<String, dynamic> jsonData = {};
    if (responseModel?.data == null) {
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

  Future<bool> logout(String appKey) async {
    if (appKey == '') {
      return false;
    }

    Map<String, dynamic> body = {
      "appKey": appKey,
    };

    ///NOTE
    ///errorHandler를 사용하려면 새로 작성해야해서 그냥 try/catch로 ,,
    try {
      var result = await _loginService.logout(body);
      if (result == null) {
        return false;
      }

      await _socialLoginService!.logout();

      return result.result;
    } catch (e) {
      return false;
    }
  }

  Future<(ResponseModel?, LoginStatus)> errorHandler(Object obj) async {
    ResponseModel? responseModel;
    switch (obj.runtimeType) {
      case DioException:
        final res = (obj as DioException).response;

        if (res?.data == null) {
          ///TODO
          ///Error Proc
          return (responseModel, LoginStatus.failure);
        } else if (res?.data is Map) {
          print('res data : ${res?.data}');
          responseModel = ResponseModel.fromJson(res?.data);
        } else if (res?.data is String) {
          Map<String, dynamic> valueMap = jsonDecode(res?.data);
          responseModel = ResponseModel.fromJson(valueMap);
        }

        if (res?.statusCode == 302) {
          return (responseModel, LoginStatus.needSignUp);
        }

        // print('responseModel $responseModel');
        break;
      default:
        break;
    }
    return (responseModel, LoginStatus.failure);
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
        break;
      default:
        socialService = null;
        break;
    }

    return socialService;
  }
}
