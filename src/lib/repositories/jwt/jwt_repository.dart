import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/jwt/jwt_response_model.dart';
import 'package:pet_mobile_social_flutter/services/jwt/jwt_service.dart';

class JWTRepository {
  late final JWTService _jwtService; // = PolicyService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  JWTRepository({
    required this.dio,
  }) {
    _jwtService = JWTService(dio, baseUrl: memberBaseUrl);
  }

  Future<String> getAccessToken(String? refreshToken) async {
    if (refreshToken == null) {
      throw APIException(
        msg: 'Refresh Token is Null.',
        code: 'ECOM-9999',
        refer: 'JWTRepository',
        caller: 'getAccessToken',
      );
    }

    JWTResponseModel responseModel = await _jwtService.getAccessToken({
      'refreshToken': refreshToken,
    });

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'JWTRepository',
        caller: 'getAccessToken',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'LoginRepository',
        caller: 'getAccessToken',
      );
    }

    if (!responseModel.data!.containsKey('accessToken')) {
      throw APIException(
        msg: 'AccessToken data is null',
        code: responseModel.code,
        refer: 'LoginRepository',
        caller: 'getAccessToken',
      );
    }

    return responseModel.data!['accessToken'];
  }

  Future<void> checkRefreshToken(String? refreshToken) async {
    if (refreshToken == null) {
      throw APIException(
        msg: 'Refresh Token is Null.',
        code: 'ECOM-9999',
        refer: 'JWTRepository',
        caller: 'checkRefreshToken',
      );
    }

    JWTResponseModel responseModel = await _jwtService.checkRefreshToken({
      'refreshToken': refreshToken,
    });

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'JWTRepository',
        caller: 'checkRefreshToken',
      );
    }
  }
}
