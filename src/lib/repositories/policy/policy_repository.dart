import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_menu_item_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_menu_response_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:pet_mobile_social_flutter/services/policy/policy_service.dart';

// final policyRepositoryProvider = Provider.autoDispose((ref) => PolicyRepository());

class PolicyRepository {
  late final PolicyService _policyService; // = PolicyService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  PolicyRepository({
    required this.dio,
  }) {
    _policyService = PolicyService(dio, baseUrl: memberBaseUrl);
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

  Future<List<PolicyItemModel>> getPoliciesDetail(int type, String date) async {
    PolicyResponseModel responseModel = await _policyService.getPoliciesDetail(type, date);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'PolicyRepository',
        caller: 'getPoliciesDetail',
      );
    }

    return responseModel.data.list;
  }

  Future<List<PolicyMenuItemModel>> getPoliciesMenu() async {
    PolicyMenuResponseModel responseModel = await _policyService.getPoliciesMenu();

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
