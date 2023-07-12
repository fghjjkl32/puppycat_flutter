import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_route_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/signUp/sign_up_repository.dart';
import 'package:pet_mobile_social_flutter/services/signUp/sign_up_service.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_state_provider.g.dart';

enum NickNameStatus {
  none,
  valid,
  duplication,
  minLength,
  maxLength,
  invalidLetter,
  invalidWord,
  failure,
}


enum SignUpStatus {
  none,
  success,
  failure,
  failedAuth,
  duplication,
}

final nickNameProvider = StateProvider<NickNameStatus>((ref) => NickNameStatus.none);

@Riverpod(keepAlive: true)
// @riverpod
class SignUpState extends _$SignUpState {
  final SignUpRepository _signUpRepository = SignUpRepository();

  @override
  SignUpStatus build() {
    return SignUpStatus.none;
  }

  void socialSignUp(UserModel userModel) async {
    var idxList = ref.read(policyStateProvider.notifier).getSelectPolicy();
    var result = await _signUpRepository.socialSignUp(userModel, idxList);

    if(result == SignUpStatus.success) {
      ref.read(signUpRouteStateProvider.notifier).state = SignUpRoute.success;
      // ref.read(chatRegisterStateProvider.notifier).register(userModel);
    }
    state = result;
    // state = SignUpStatus.failedAuth;
  }

  ///230621 smkang
  ///result false - API 응답은 다양한 종류가 오는데 대부분 이미 앞단에서 체크하는 것이고 이미 사용 중인 닉네임만 체크하고자함
  ///따라서 false인 경우는 중복 닉네임일 때만이라고 가정하고 진행
  ///안그러면 response의 code 값을 또 봐야하는데 고정 code가 아닐 수도 있기 때문에 ,,
  void checkNickName(String nick) async {
    ///앞단에서 처리 완료
    // if (nick.length < 2) {
    //   ref.read(nickNameProvider.notifier).state = NickNameStatus.minLength;
    //   return;
    // }
    //
    // if (nick.length > 20) {
    //   ref.read(nickNameProvider.notifier).state = NickNameStatus.maxLength;
    //   return;
    // }

    ///InvalidWord

    ref.read(nickNameProvider.notifier).state = await _signUpRepository.checkNickName(nick);
  }
}
