import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/controller/token/token_controller.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
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
    String caller = apiException.getExceptionCaller();

    print('apiException2 $apiException');

    print("refer ${refer}");
    print("caller ${caller}");

    switch (code) {
      case 'EJOI-7777':
        final loginData = apiException.arguments?.first;
        if (loginData != null) {
          if (loginData is UserModel) {
            ref.read(signUpUserInfoProvider.notifier).state = loginData;
          }
        }
        ref.read(loginRouteStateProvider.notifier).changeLoginRoute(LoginRoute.signUpScreen);
        break;
      case 'ERES-9999': // 제재 상태
        ref.read(loginStateProvider.notifier).state = LoginStatus.restriction;
        break;
      case 'EOUT-7777': // 탈퇴 대기
        final loginData = apiException.arguments?.first;
        if (loginData != null) {
          if (loginData is UserModel) {
            ref.read(signUpUserInfoProvider.notifier).state = loginData;
          }
        }
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
      case 'ECON-3994': //존재하지 않는 게시물, 페이지 이동
        //TODO 피드 상세보기 오류시 해당 게시글 숨기거나 새로고침 기능 추가 해야함
        final goRouter = ref.read(routerProvider);
        caller == "getContentDetail" ? goRouter.pushNamed('feed_not_found_screen') : goRouter.pushNamed('error_toast');
        break;
      case 'ECON-3986': //팔로우 공개 게시물, 페이지 이동
        //TODO 테스트 필요
        final goRouter = ref.read(routerProvider);
        goRouter.pushNamed('error_toast');
        // goRouter.pushNamed('feed_not_found_screen');
        break;
      case 'ECON-3982': //팔로우 공개 게시물, 페이지 이동, 미로그인 시 로그인 화면으로
        final goRouter = ref.read(routerProvider);
        goRouter.pushReplacement("/loginScreen");
        break;
      case 'ECON-3993': //상대가 나를 차단, 피드를 찾을 수 없어요 스낵바
      case 'ECON-3987': //신고 게시글, 피드를 찾을 수 없어요 스낵바
      case 'ECON-3989': //숨김 게시물
        final goRouter = ref.read(routerProvider);
        goRouter.pushNamed('error_toast');
        break;
      case 'ECON-3992': //내가 상대를 차단, bottom sheet
        //TODO bottom sheet를 띄우려면 name, memberidx를 알아야하는데, 얻기가 힘든 케이스가 있어서(해시태그 검색) 임시 보류
        final goRouter = ref.read(routerProvider);
        goRouter.pushNamed('error_toast');
        break;
      case 'ASL-9998': //사용자가 로그인 취소했을 때, 아무 동작 안시키기 위함
      case 'ERTE-9999': //Access Token 오류일 때, 아무 동작 하지 않기 위함
      case 'ATK-9999': //App Token, Access Token 재발행 시 Refresh Token 이 null 일 때, 따로 로직 추가해야할거 같긴함
        break;
      case 'ECOM-9999':
      case 'ASL-9997':
        if (caller == 'checkRefreshToken') {
          break;
        }
        await TokenController.clearTokens();

        ref.read(loginRouteStateProvider.notifier).state = LoginRoute.none;
        ref.read(followUserStateProvider.notifier).resetState();
        ref.read(myInfoStateProvider.notifier).state = UserInformationItemModel();
        ref.read(loginStateProvider.notifier).state = LoginStatus.none;

        break;
      // case 'ASP-9999': //회원가입 후 바로 로그인했는데  userModel이  null일 때
      default:
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
