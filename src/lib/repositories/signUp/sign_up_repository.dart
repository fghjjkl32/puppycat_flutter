import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/services/signUp/sign_up_service.dart';


// final policyRepositoryProvider = Provider.autoDispose((ref) => PolicyRepository());

class SignUpRepository {
  final SignUpService _signUpService = SignUpService(Dio());

  // Future socialSignUp(UserModel userModel) {
  //
  // }

  Future<bool> checkNickName(String nick) async {
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

    if(res == null || isError) {
      throw 'API Response is Null.';
    }
    
    return res.result;
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