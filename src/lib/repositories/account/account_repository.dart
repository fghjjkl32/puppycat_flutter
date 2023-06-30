import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/services/account/account_service.dart';

final accountRepositoryProvider = Provider((ref) => AccountRepository());

class AccountRepository {
  final AccountService _accountService = AccountService(DioWrap.getDioWithCookie());

  Future<bool> restoreAccount(String memberIdx, String simpleId) async {
    Map<String, dynamic> body = {
      "memberIdx" : memberIdx,
      "simpleId" : simpleId,
    };

    ResponseModel? responseModel = await _accountService.restoreAccount(memberIdx, body);

    if(responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    return responseModel.result;
  }
}