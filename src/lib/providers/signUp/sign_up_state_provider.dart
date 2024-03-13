import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/router/router.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/signUp/sign_up_repository.dart';
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
  nonValid,
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
  late final SignUpRepository _signUpRepository; // = SignUpRepository(dio: ref.read(dioProvider));

  @override
  SignUpStatus build() {
    _signUpRepository = SignUpRepository(dio: ref.read(dioProvider));
    return SignUpStatus.none;
  }

  void socialSignUp(UserModel userModel) async {
    try {
      var idxList = ref.read(policyStateProvider.notifier).getSelectPolicy();
      var result = await _signUpRepository.socialSignUp(userModel, idxList);

      if (result == SignUpStatus.success) {
        ref.read(signUpUserInfoProvider.notifier).state = userModel;
        // ref.read(signUpRouteStateProvider.notifier).state = SignUpRoute.success;
        // ref.read(chatRegisterStateProvider.notifier).register(userModel);

        ref.read(routerProvider).push('/home/login/signup/signupComplete');
      }
      state = result;
      // state = SignUpStatus.failedAuth;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('socialSignUp error $e');
      // ref.read(signUpRouteStateProvider.notifier).state = SignUpRoute.none;
      state = SignUpStatus.failure;
    }
  }

  void checkNickName(String nick) async {
    try {
      ref.read(nickNameProvider.notifier).state = await _signUpRepository.checkNickName(nick);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('checkNickName error $e');
    }
  }
}
