import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/signUp/sign_up_service.dart';

// final policyRepositoryProvider = Provider.autoDispose((ref) => PolicyRepository());

class SignUpRepository {
  late final SignUpService _signUpService; // = SignUpService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  SignUpRepository({
    required this.dio,
  }) {
    _signUpService = SignUpService(dio, baseUrl: memberBaseUrl);
  }

  Future<SignUpStatus> socialSignUp(UserModel userModel, List<PolicyItemModel> policyIdxList) async {
    /// NOTE
    ///테스트용

    // userModel = userModel.copyWith(
    //   id: 'thirdnsov4@gmail.com',
    //   ci: '2809229088121356223',
    //   nick: 'test_reg',
    //   simpleId: '2809229088121356223',
    //   password: '2809229088121356223',
    //   passwordConfirm: '2809229088121356223',
    // );

    Map<String, dynamic> body = {
      ...userModel.toJson(),
    };

    print('puppycat register body $body');

    for (var element in policyIdxList) {
      body['selectPolicy_${element.idx}'] = element.isAgreed ? 1 : 0;
    }

    ResponseModel responseModel = await _signUpService.socialSignUp(body);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SignUpRepository',
        caller: 'socialSignUp',
        arguments: [responseModel.data],
      );
    }

    //TODO Error 처리 추가 필요
    return SignUpStatus.success;
  }

  Future<NickNameStatus> checkNickName(String nick) async {
    Map<String, dynamic> queries = {
      "nick": nick,
    };

    ResponseModel responseModel = await _signUpService.checkNickName(queries);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'SignUpRepository',
        caller: 'checkNickName',
      );
    }

    return NickNameStatus.valid;
  }
}
