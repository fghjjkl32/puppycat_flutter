import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/signUp/sign_up_service.dart';


// final policyRepositoryProvider = Provider.autoDispose((ref) => PolicyRepository());

class SignUpRepository {
  final SignUpService _signUpService = SignUpService(Dio());

  // Future socialSignUp(UserModel userModel) {
  //
  // }

  Future<NickNameStatus> checkNickName(String nick) async {
    Map<String, dynamic> queries = {
      "nick": nick,
    };

    bool isError = false;
    ResponseModel? res = await _signUpService.checkNickName(queries).catchError((Object obj) async {
      (ResponseModel?, bool) errorResult = await errorHandler(obj);
      var responseModel = errorResult.$1;
      isError = errorResult.$2;

      return responseModel;
    });

    ///https://www.notion.so/a9eda34e44a5456daf3d9ec7939b2061?pvs=4
    ///닉네임 중복, 금칙어에 대한 status code 400 -> 200  변경 필요
    if(res == null || isError) {
      throw 'API Response is Null.';
    }

    if(res.result) {
      return NickNameStatus.valid;
    } else {
      switch(res.code) {
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