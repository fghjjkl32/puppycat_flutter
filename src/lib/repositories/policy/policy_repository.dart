import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:pet_mobile_social_flutter/services/policy/policy_service.dart';

// final policyRepositoryProvider = Provider.autoDispose((ref) => PolicyRepository());

class PolicyRepository {
  final PolicyService _policyService =
      PolicyService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  Future<List<PolicyItemModel>> getPolicies() async {
    PolicyResponseModel? policyResponseModel =
        await _policyService.getPolicies();

    if (policyResponseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    return policyResponseModel.data.list;
  }
}
