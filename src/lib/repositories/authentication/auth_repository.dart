import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/common/util/encrypt/encrypt_util.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/services/authentication/auth_service.dart';

class AuthRepository {
  late final AuthService _authService; // = AuthService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  // AuthService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);
  final Dio dio;

  AuthRepository({
    required this.dio,
  }) {
    _authService = AuthService(dio, baseUrl: baseUrl);
  }

  Future<String> getPassAuthUrl() async {
    String appKey = await GetIt.I.get<UuidUtil>().getUUID();
    String token = EncryptUtil.getPassAPIEncrypt(appKey);

    Map<String, dynamic> queries = {
      'appKey': appKey,
      'token': ListParam<String>([token], ListFormat.multi),
    };
    print('pass url token : $token');

    // final response = await DioWrap.getDioWithCookie().get('https://sns-api.devlabs.co.kr:28080/v1/certification/popup?appKey=$appKey&token=$token');
    // print('test : $response');

    // ResponseModel? responseModel = await _authService.getPassAuthUrl(queries).catchError((obj) => throw 'some error.');
    ResponseModel? responseModel = await _authService.getPassAuthUrl(appKey: appKey, token: token).catchError((obj) => throw 'some error.');
    if (responseModel == null) {
      throw 'response body is null';
    }

    if (!responseModel.result) {
      throw 'response result is false(code: ${responseModel.code})';
    }

    if (responseModel.data == null || responseModel.data == {}) {
      throw 'data is null(or empty)';
    }

    if (!responseModel.data!.containsKey('location')) {
      throw 'not found data.location';
    }

    return responseModel.data!['location'];
  }
}
