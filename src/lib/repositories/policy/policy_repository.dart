import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:pet_mobile_social_flutter/services/policy/policy_service.dart';

// final policyRepositoryProvider = Provider.autoDispose((ref) => PolicyRepository());

class PolicyRepository {
  late final PolicyService _policyService;// = PolicyService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  PolicyRepository({
    required this.dio,
  }) {
    _policyService = PolicyService(dio, baseUrl: baseUrl);
  }

  Future<List<PolicyItemModel>> getPolicies() async {
    PolicyResponseModel responseModel = await _policyService.getPolicies();

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'PolicyRepository',
        caller: 'getPolicies',
      );
    }

    return responseModel.data.list;
  }
}
