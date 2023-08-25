import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/signUp/sign_up_service.dart';

// final policyRepositoryProvider = Provider.autoDispose((ref) => PolicyRepository());

class SignUpRepository {
  final SignUpService _signUpService =
      SignUpService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  Future<SignUpStatus> socialSignUp(
      UserModel userModel, List<PolicyItemModel> policyIdxList) async {
    /// NOTE
    ///테스트용

    // userModel = userModel.copyWith(
    //   id: 'thirdnsov4@gmail.com',
    //   ci: '2809229088121356223',
    //   nick: 'test_reg',
    //   simpleId: '2809229088121356223',
    //   password: '2809229088121356223',
    //   passwordConfirm: '2809229088121356223',
    // );

    Map<String, dynamic> body = {
      ...userModel.toJson(),
    };

    print('puppycat register body $body');

    for (var element in policyIdxList) {
      body['selectPolicy_${element.idx}'] = element.isAgreed ? 1 : 0;
    }

    bool isError = false;
    ResponseModel? res =
        await _signUpService.socialSignUp(body).catchError((Object obj) async {
      (ResponseModel?, bool) errorResult = await errorHandler(obj);
      var responseModel = errorResult.$1;
      isError = errorResult.$2;

      return responseModel;
    });

    if (res == null || isError) {
      throw 'API Response is Null.';
    }

    if (res.result) {
      return SignUpStatus.success;
    } else {
      switch (res.code) {
        case "JCER-8888": // 본인인증 실패
          return SignUpStatus.failedAuth;
        case "EJOI-3998":
          return SignUpStatus.duplication;
        default:
          return SignUpStatus.failure;
      }
    }
  }

  Future<NickNameStatus> checkNickName(String nick) async {
    Map<String, dynamic> queries = {
      "nick": nick,
    };

    bool isError = false;
    ResponseModel? res = await _signUpService
        .checkNickName(queries)
        .catchError((Object obj) async {
      (ResponseModel?, bool) errorResult = await errorHandler(obj);
      var responseModel = errorResult.$1;
      isError = errorResult.$2;

      return responseModel;
    });

    if (res == null) {
      throw 'API Response is Null.';
    }

    if (res.result) {
      return NickNameStatus.valid;
    } else {
      switch (res.code) {
        case "ENIC-3998":
          return NickNameStatus.invalidWord;
        case "ENIC-3997":
          return NickNameStatus.duplication;
        default:
          return NickNameStatus.failure;
      }
    }
  }

  Future<(ResponseModel?, bool)> errorHandler(Object obj) async {
    ResponseModel? responseModel;
    switch (obj.runtimeType) {
      case DioException:
        final res = (obj as DioException).response;

        if (res?.data == null) {
          ///TODO
          ///Error Proc
          return (responseModel, true);
        } else if (res?.data is Map) {
          print('res data : ${res?.data}');
          responseModel = ResponseModel.fromJson(res?.data);
        } else if (res?.data is String) {
          Map<String, dynamic> valueMap = jsonDecode(res?.data);
          responseModel = ResponseModel.fromJson(valueMap);
        }

        // print('responseModel $responseModel');
        break;
      default:
        break;
    }
    return (responseModel, true);
  }
}
