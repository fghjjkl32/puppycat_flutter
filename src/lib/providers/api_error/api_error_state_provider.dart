import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_error_state_provider.g.dart';

///NOTE
///왠지 모르겠는데 코드 자동 생성 때 이름이 .. 깨짐
///aPIErrorStateProvider
@Riverpod(keepAlive: true)
class APIErrorState extends _$APIErrorState {
  @override
  List<bool> build() {
    return [];
  }

  Future apiErrorProc(APIException apiException) async {
    String msg = apiException.getExceptionMsg();
    String code = apiException.getExceptionCode();
    String refer = apiException.getExceptionRefer();
    print('apiException2 $apiException');

    switch (code) {
      case 'EJOI-7777':
        ref.read(loginRouteStateProvider.notifier).changeLoginRoute(LoginRoute.signUpScreen);
        break;
      case 'ERES-9999': // 제재 상태
        ref.read(loginStateProvider.notifier).state = LoginStatus.restriction;
        break;
      case 'EOUT-7777': // 탈퇴 대기
        ref.read(loginStateProvider.notifier).state = LoginStatus.withdrawalPending;
        break;
      case 'ENIC-3998': // 유효하지 않은 문자
        ref.read(nickNameProvider.notifier).state = NickNameStatus.invalidWord;
        break;
      case 'ENIC-3997': // 중복 닉네임
        ref.read(nickNameProvider.notifier).state = NickNameStatus.duplication;
        break;
      case 'ENIC-9998':
        //TODO 더 고도화 필요
        ref.read(nickNameProvider.notifier).state = NickNameStatus.failure;
        break;
      case 'SIJD-3999': //TODO 중복 가입 alert, 멤버 서버 나오면 다시 작업
        print('SIJD-3999 ${apiException.toString()}');
        break;
      case 'ENSA-2999': // PASS 인증 URL 실패(AppKey)
      case 'ELGI-9999': //TODO 로그인 실패
      case 'EJOI-9999': //TODO 회원가입 실패
      default:
        print('aaaaaaaaaaaaaaaaaaaaaaaaaa');
        final goRouter = ref.read(routerProvider);
        goRouter.pushNamed('error_dialog', extra: code);
    }

    apiErrorLogging(apiException);
  }

  Future apiErrorLogging(APIException apiException) async {
    String apiErrorMsg = apiException.toString();
    print('API Error Msg : $apiErrorMsg');
  }
}
