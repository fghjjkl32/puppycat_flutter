import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/withdrawal/withdrawal_detail_response_model.dart';
import 'package:pet_mobile_social_flutter/models/reason/reason_list_model.dart';
import 'package:pet_mobile_social_flutter/models/reason/reason_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/withdrawal/withdrawal_provider.dart';
import 'package:pet_mobile_social_flutter/services/withdrawal/withdrawal_service.dart';

class WithdrawalRepository {
  late final WithdrawalService _withdrawalService; // = WithdrawalService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  WithdrawalRepository({
    required this.dio,
  }) {
    _withdrawalService = WithdrawalService(dio, baseUrl: memberBaseUrl);
  }

  Future<ReasonListModel> getWithdrawalReasonList() async {
    ReasonResponseModel responseModel = await _withdrawalService.getWithdrawalReasonList();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'WithdrawalRepository',
        caller: 'getWithdrawalReasonList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'WithdrawalRepository',
        caller: 'getWithdrawalReasonList',
      );
    }

    return responseModel.data!;
  }

  Future<WithdrawalDetailListModel> getWithdrawalDetailList() async {
    final withdrawalServiceForSNS = WithdrawalService(dio, baseUrl: baseUrl);
    WithdrawalDetailResponseModel responseModel = await withdrawalServiceForSNS.getWithdrawalDetailList();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'WithdrawalRepository',
        caller: 'getWithdrawalDetailList',
      );
    }

    if (responseModel.data == null) {
      throw APIException(
        msg: 'data is null',
        code: responseModel.code,
        refer: 'WithdrawalRepository',
        caller: 'getWithdrawalDetailList',
      );
    }

    return responseModel.data!;
  }

  Future<WithdrawalStatus> withdrawalUser({required int code, String? reason}) async {
    Map<String, dynamic> body = reason != null
        ? {
            "code": code,
            "reason": reason,
          }
        : {
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
