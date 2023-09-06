import 'dart:convert';

import 'package:dio/dio.dart';
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
    SelectButtonResponseModel? withdrawalResponseModel = await _withdrawalService.getWithdrawalReasonList();

    if (withdrawalResponseModel == null) {
      throw "error";
    }

    return withdrawalResponseModel;
  }

  Future<WithdrawalDetailResponseModel> getWithdrawalDetailList(memberIdx) async {
    WithdrawalDetailResponseModel? withdrawalResponseModel = await _withdrawalService.getWithdrawalDetailList(memberIdx);

    if (withdrawalResponseModel == null) {
      throw "error";
    }

    return withdrawalResponseModel;
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

    bool isError = false;
    ResponseModel? res = await _withdrawalService.withdrawalUser(body).catchError((Object obj) async {
      (ResponseModel?, bool) errorResult = await errorHandler(obj);
      var responseModel = errorResult.$1;
      isError = errorResult.$2;

      return responseModel;
    });

    if (res == null || isError) {
      throw 'API Response is Null.';
    }

    if (res.result) {
      return WithdrawalStatus.success;
    } else {
      return WithdrawalStatus.failure;
    }
  }

  Future<(ResponseModel?, bool)> errorHandler(Object obj) async {
    ResponseModel? responseModel;
    switch (obj.runtimeType) {
      case DioException:
        final res = (obj as DioException).response;
        if (res?.data == null) {
          return (responseModel, true);
        } else if (res?.data is Map) {
          responseModel = ResponseModel.fromJson(res?.data);
        } else if (res?.data is String) {
          Map<String, dynamic> valueMap = jsonDecode(res?.data);
          responseModel = ResponseModel.fromJson(valueMap);
        }
        break;
      default:
        break;
    }
    return (responseModel, true);
  }
}
