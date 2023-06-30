import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/services/authentication/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService(DioWrap.getDioWithCookie());

  Future<String> getPassAuthUrl() async {
    ResponseModel? responseModel = await _authService.getPassAuthUrl().catchError((obj) => throw 'some error.');

    if(responseModel == null) {
      throw 'response body is null';
    }

    if(!responseModel.result) {
      throw 'response result is false(code: ${responseModel.code})';
    }

    if(responseModel.data == null || responseModel.data == {}) {
      throw 'data is null(or empty)';
    }

    if(!responseModel.data!.containsKey('location')) {
      throw 'not found data.location';
    }

    return responseModel.data!['location'];
  }
}