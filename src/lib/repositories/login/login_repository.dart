import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/models/login/login_request_model.dart';
import 'package:pet_mobile_social_flutter/models/login/login_response_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/login/login_service.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/kakao/kakao_login.dart';
import 'package:pet_mobile_social_flutter/services/login/social_login/social_login_service.dart';

class LoginRepository {
  final LoginService _loginService = LoginService(Dio());
  late SocialLoginService? _socialLoginService;
  final String provider;
  late UserModel? userModel;

  LoginRepository({
    required this.provider,
  }) {
    _socialLoginService = _setSocialLoginService(provider);
  }

  // Future signUp() async {
  //   if (await _socialLogin()) {
  //     // await _loginService.socialLogin(provider);
  //     LoginRequestModel? queries = await _socialLoginService?.getUserInfo();
  //
  //     if (queries == null) {
  //       return false;
  //     }
  //
  //     var result = await _loginService.socialSignUp(queries.toJson()).catchError((Object obj) {
  //       // var result = await _loginService.socialLogin(queries.toJson()).catchError((Object obj) {
  //       // non-200 error goes here.
  //       switch (obj.runtimeType) {
  //         case DioException:
  //           // Here's the sample to get the failed response error code and message
  //           final res = (obj as DioException).response;
  //           // LoginResponseModel responseModel;
  //           print('responseModel $res');
  //           break;
  //         default:
  //           break;
  //       }
  //       return obj;
  //     });
  //   }
  // }

  Future<bool> login() async {
    if (await _socialLogin()) {
      // await _loginService.socialLogin(provider);
      userModel = await _socialLoginService?.getUserInfo();

      if (userModel == null) {
        return false;
      }

      LoginRequestModel reqModel = LoginRequestModel(
        id: userModel!.id,
        simpleId: userModel!.simpleId,
        simpleType: userModel!.simpleType ?? provider,
      );

      var result = await _loginService.socialLogin(reqModel.toJson()).catchError((Object obj) async {
        return await errorHandler(obj);
      });
      print('result $result');

      if (result == null) {
        ///TODO
        ///result == null 이면 실제 통신 에러 발생으로 추측할 수 있음
        return false;
      }

      return true;
    } else {
      return false;
    }
  }

  Future<LoginResponseModel?> errorHandler(Object obj) async {
    LoginResponseModel? responseModel;
    switch (obj.runtimeType) {
      case DioException:
        final res = (obj as DioException).response;
        if (res?.data == null) {
          ///TODO
          ///Error Proc
        } else if (res?.data is Map) {
          print('res data : ${res?.data}');
          responseModel = LoginResponseModel.fromJson(res?.data);
        } else if (res?.data is String) {
          Map<String, dynamic> valueMap = jsonDecode(res?.data);
          responseModel = LoginResponseModel.fromJson(valueMap);
        }

        // print('responseModel $responseModel');
        break;
      default:
        break;
    }
    return responseModel;
  }

  Future<bool> _socialLogin() async {
    if (await _socialLoginService!.login()) {
      ///TODO
      ///Token is ""
      return false;
    }
    return true;
  }

  SocialLoginService? _setSocialLoginService(String provider) {
    SocialLoginService? socialService;
    switch (provider) {
      case "naver":
        break;
      case "kakao":
        socialService = KakaoLoginService();
        break;
      case "google":
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
