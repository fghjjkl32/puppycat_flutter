import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
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
    _authService = AuthService(dio, baseUrl: memberBaseUrl);
  }

  Future<String> getPassAuthUrl() async {
    String appKey = await GetIt.I.get<UuidUtil>().getUUID();
    String token = EncryptUtil.getPassAPIEncrypt(appKey);

    Map<String, dynamic> queries = {
      'appKey': appKey,
      'token': ListParam<String>([token], ListFormat.multi),
    };
    print('pass url token : $token');

    ResponseModel responseModel = await _authService.getPassAuthUrl(appKey: appKey, token: token);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message,
        code: responseModel.code,
        refer: 'AuthRepository',
        caller: 'getPassAuthUrl',
      );
      throw 'response result is false(code: ${responseModel.code})';
    }

    if (responseModel.data == null || responseModel.data == {}) {
      throw APIException(
        msg: 'data is null(or empty)',
        code: responseModel.code,
        refer: 'AuthRepository',
        caller: 'getPassAuthUrl',
      );
    }

    if (!responseModel.data!.containsKey('location')) {
      throw APIException(
        msg: 'Not found data.location',
        code: responseModel.code,
        refer: 'AuthRepository',
        caller: 'getPassAuthUrl',
      );
    }

    print("responseModel.data!['location'] ${responseModel.data!['location']}");

    return responseModel.data!['location'];
  }
}
