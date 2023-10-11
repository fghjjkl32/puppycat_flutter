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
import 'package:pet_mobile_social_flutter/services/authentication/bearer_token_auth_service.dart';

class BearerTokenAuthRepository {
  late final BearerTokenAuthService _authService;

  final Dio dio;

  BearerTokenAuthRepository({
    required this.dio,
  }) {
    _authService = BearerTokenAuthService(dio, baseUrl: baseUrl);
  }

  Future<String> getTossToken() async {
    String? responseModel = await _authService
        .getTossToken(
          "client_credentials",
          "urx76xphaevqxky20iccws749ex7xljf",
          "iMOiv0BH4I2flOliyN28aNrl6QBetNkNM8ok8D1VgXuqADAH",
          "ca",
        )
        .catchError((obj) => throw 'some error.');

    if (responseModel == null) {
      throw Exception('Failed to load access token');
    }

    Map<String, dynamic> decodedResponse = jsonDecode(responseModel);

    String accessToken = decodedResponse['access_token'];

    return accessToken;
  }

  Future<String> getTossAuthUrl() async {
    final Map<String, dynamic> body = {
      "requestType": "USER_NONE",
      "successCallbackUrl": "puppycat://ss",
    };
    String? accessToken = await getTossToken();
    String? responseModel = await _authService.getTossAuthUrl(body, "Bearer $accessToken").catchError((obj) => throw 'some error.');

    if (responseModel == null) {
      throw Exception('Failed to load access token');
    }

    Map<String, dynamic> decodedResponse = jsonDecode(responseModel);

    String txId = decodedResponse["success"]["txId"];

    return txId;
  }

  Future<String> getTossTransactionsUrl(txId) async {
    String? responseModel = await _authService.getTossTransactionsUrl(txId).catchError((obj) => throw 'some error.');

    if (responseModel == null) {
      throw Exception('Failed to load access token');
    }

    Map<String, dynamic> decodedResponse = jsonDecode(responseModel);

    String url = decodedResponse["success"]["appUri"]["android"];

    return url;
  }
}
