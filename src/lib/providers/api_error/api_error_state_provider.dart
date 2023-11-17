import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
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
    
    switch(code) {
      case 'EJOI-7777':
        ///TODO
        ///회원가입 필요
        ref.read(loginRouteStateProvider.notifier).changeLoginRoute(LoginRoute.signUpScreen);
        break;
      case 'ERES-9999' : // 제재 상태
        ref.read(loginStateProvider.notifier).state = LoginStatus.restriction;
        break;
      case 'EOUT-7777' : // 탈퇴 대기
        ref.read(loginStateProvider.notifier).state = LoginStatus.withdrawalPending;
        break;
      case 'ENSA-2999':
        print('ENSA-2999 $msg');
        break;
      case 'ELGI-9999' : // 로그인 실패
      default:
        //TODO
        //Popup Dialog
    }

    apiErrorLogging(apiException);
    
  }
  
  Future apiErrorLogging(APIException apiException) async {
    String apiErrorMsg = apiException.toString();
    print('API Error Msg : $apiErrorMsg');
  }
}
