import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/withdrawal/withdrawal_provider.dart';
import 'package:pet_mobile_social_flutter/services/withdrawal/withdrawal_service.dart';

class WithdrawalRepository {
  late final WithdrawalService _withdrawalService; // = WithdrawalService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  WithdrawalRepository({
    required this.dio,
  }) {
    _withdrawalService = WithdrawalService(dio, baseUrl: baseUrl);
  }

  Future<SelectButtonResponseModel> getWithdrawalReasonList() async {
    SelectButtonResponseModel responseModel = await _withdrawalService.getWithdrawalReasonList();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'WithdrawalRepository',
        caller: 'getWithdrawalReasonList',
      );
    }

    return responseModel;
  }

  Future<WithdrawalDetailResponseModel> getWithdrawalDetailList(memberIdx) async {
    WithdrawalDetailResponseModel responseModel = await _withdrawalService.getWithdrawalDetailList(memberIdx);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'WithdrawalRepository',
        caller: 'getWithdrawalDetailList',
      );
    }

    return responseModel;
  }

  Future<WithdrawalStatus> withdrawalUser({required int idx, required int code, String? reason}) async {
    Map<String, dynamic> body = reason != null
        ? {
            "memberIdx": idx,
            "code": code,
            "reason": reason,
          }
        : {
            "memberIdx": idx,
            "code": code,
          };

    ResponseModel responseModel = await _withdrawalService.withdrawalUser(body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'WithdrawalRepository',
        caller: 'withdrawalUser',
      );
    }

    return WithdrawalStatus.success;
  }
}
