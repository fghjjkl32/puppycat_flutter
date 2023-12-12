import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/controller/token/token_controller.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/jwt/jwt_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/login/login_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_state_provider.g.dart';

// final userInfoProvider = StateProvider<UserInfoModel>((ref) => UserInfoModel());
final signUpUserInfoProvider = StateProvider<UserModel?>((ref) => null);
final loginStatementProvider = StateProvider<bool>((ref) => ref.watch(loginStateProvider) == LoginStatus.success);

@Riverpod(keepAlive: true)
class LoginState extends _$LoginState {
  late Dio _dioProvider;

  @override
  LoginStatus build() {
    _dioProvider = ref.read(dioProvider);
    return LoginStatus.none;
  }

  void login({
    required String provider,
  }) async {
    final loginRepository = LoginRepository(provider: provider, dio: _dioProvider);

    try {
      UserModel socialUserModel = await loginRepository.socialLogin();
      final refreshToken = await loginRepository.getRefreshToken(socialUserModel.simpleType, socialUserModel.refreshToken);
      if (refreshToken.isNotEmpty) {
        socialUserModel = socialUserModel.copyWith(refreshToken: refreshToken);
      }

      final loginResult = await loginRepository.loginByUserModel(userModel: socialUserModel);
      _procLogin(loginResult);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = LoginStatus.failure;
    } catch (e) {
      print('login exception ($e)');
      state = LoginStatus.failure;
    }
  }

  void loginByUserModel({
    required UserModel? userModel,
  }) async {
    //
    userModel = userModel ?? ref.read(signUpUserInfoProvider);
    if (userModel == null) {
      throw APIException(
        msg: 'userModel is null',
        code: 'ASP-9999',
        refer: 'LoginStateProvider',
        caller: 'loginByUserModel',
      );
    }

    final loginRepository = LoginRepository(provider: userModel.simpleType, dio: _dioProvider);

    try {
      var loginResult = await loginRepository.loginByUserModel(userModel: userModel);
      _procLogin(loginResult);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = LoginStatus.failure;
    } catch (e) {
      print('auto login exception ($e)');
      state = LoginStatus.failure;
    }
  }

  Future<void> _procLogin(UserModel userModel, [bool isAutoLogin = false]) async {
    ref.read(loginRouteStateProvider.notifier).changeLoginRoute(LoginRoute.success);
    ref.read(myInfoStateProvider.notifier).getMyInfo();
    ref.read(signUpUserInfoProvider.notifier).state = null;

    print('ref.read(myInfoStateProvider ${ref.read(myInfoStateProvider)}');

    state = LoginStatus.success;
  }

  Future logout(String provider) async {
    final loginRepository = LoginRepository(provider: provider, dio: _dioProvider);

    try {
      var result = await loginRepository.logout();
      if (result) {
        await TokenController.clearTokens();

        ref.read(loginRouteStateProvider.notifier).state = LoginRoute.none;
        ref.read(followUserStateProvider.notifier).resetState();
        ref.read(myInfoStateProvider.notifier).state = UserInformationItemModel();
        state = LoginStatus.none;
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('logout exception ($e)');
      state = LoginStatus.failure;
    }
  }

  Future autoLogin() async {
    if (await TokenController.checkRefreshToken()) {
      final refreshToken = await TokenController.readRefreshToken();
      try {
        JWTRepository jwtRepository = JWTRepository(dio: _dioProvider);
        final isValid = await jwtRepository.checkRefreshToken(refreshToken);
        if (isValid) {
          print('auto login 1');
          ref.read(loginRouteStateProvider.notifier).changeLoginRoute(LoginRoute.success);
          ref.read(myInfoStateProvider.notifier).getMyInfo();
          ref.read(signUpUserInfoProvider.notifier).state = null;

          state = LoginStatus.success;
          ref.read(loginRouteStateProvider.notifier).state = LoginRoute.success;
        } else {
          print('auto login 2');
          state = LoginStatus.none;
          ref.read(loginRouteStateProvider.notifier).state = LoginRoute.loginScreen;
        }
      } on APIException catch (apiException) {
        ///checkRefreshToken 응답으로 받을 수 있는 오류라면  ECOM-9999 밖에 없음
        ///즉, Refresh Token이 유효하지 않을 때뿐
        ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
        return;
      } catch (e) {
        print('AutoLogin Failed. (1) $e');
        return;
      }
    } else {
      print('AutoLogin Failed. (2)');
      state = LoginStatus.none;
      ref.read(loginRouteStateProvider.notifier).state = LoginRoute.loginScreen;
      return;
    }

    // loginByUserModel(userModel: userModel);
  }
}
