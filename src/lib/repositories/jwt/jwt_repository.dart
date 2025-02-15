import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/jwt/jwt_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/restrain/restrain_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/jwt/jwt_service.dart';

class JWTRepository {
  late final JWTService _jwtService; // = PolicyService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  JWTRepository({
    required this.dio,
  }) {
    _jwtService = JWTService(dio, baseUrl: memberBaseUrl);
  }

  Future<Map<String, dynamic>> getAccessToken(String? refreshToken) async {
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
        refer: 'JWTRepository',
        caller: 'getAccessToken',
      );
    }
    if (!responseModel.data!.containsKey('accessToken')) {
      throw APIException(
        msg: 'AccessToken data is null',
        code: responseModel.code,
        refer: 'JWTRepository',
        caller: 'getAccessToken',
      );
    }

    if (!responseModel.data!.containsKey('restrainList')) {
      throw APIException(
        msg: 'restrainList is null',
        code: responseModel.code,
        refer: 'JWTRepository',
        caller: 'getAccessToken',
      );
    }

    List<dynamic> restrainList = responseModel.data?['restrainList'] ?? [];
    final List<RestrainType> restrainTypeList = restrainList.map((e) => RestrainType.values[e]).toList();

    Map<String, dynamic> resultMap = {
      'accessToken': responseModel.data!['accessToken'],
      'refreshToken': responseModel.data!['refreshToken'],
      'restrainList': restrainTypeList,
    };

    return resultMap; //responseModel.data!['accessToken'];
  }

  Future<bool> checkRefreshToken(String? refreshToken) async {
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

    return responseModel.result;
  }
}
