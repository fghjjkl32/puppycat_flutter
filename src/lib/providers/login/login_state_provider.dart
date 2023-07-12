import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/user/user_info_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/login/login_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state_provider.g.dart';

final userModelProvider = StateProvider<UserModel?>((ref) => null);
final userInfoProvider = StateProvider<UserInfoModel>((ref) => UserInfoModel());
// final cookieProvider = StateProvider<CookieJar?>((ref) => null);

// final accountRestoreProvider = StateProvider.family<Future<bool>, (String, String)>((ref, restoreInfo) {
//   return ref.read(accountRepositoryProvider).restoreAccount(restoreInfo.$1, restoreInfo.$2);
// });

@Riverpod(keepAlive: true)
class LoginState extends _$LoginState {
  @override
  LoginStatus build() {
    return LoginStatus.none;
  }

  void login({
    required String provider,
  }) async {
    final loginRepository = LoginRepository(provider: provider);
    // final loginRepository = ref.watch(loginRepositoryProvider(provider));
    var loginResult = await loginRepository.login();
    _procLogin(loginResult);
  }

  ///NOTE
  ///이미 Social(Naver, kakao ...) Login은 완료된 상태에서 로그인 진행 시키기 위한 함수
  void loginByUserModel({
    required UserModel userModel,
  }) async {
    final loginRepository = LoginRepository(provider: userModel.simpleType);
    // final loginRepository = ref.watch(loginRepositoryProvider(userModel.simpleType));
    var loginResult =
        await loginRepository.loginByUserModel(userModel: userModel);

    _procLogin(loginResult);
  }

  void _procLogin(UserModel? userModel) {
    if (userModel == null) {
      state = LoginStatus.failure;
      return;
    }

    print('loginResult.loginStatus ${userModel.loginStatus}');
    state = userModel.loginStatus;

    ref.read(userModelProvider.notifier).state = userModel;

    ///Login Route State 관련
    switch (userModel.loginStatus) {
      case LoginStatus.success:
        saveUserModel(userModel);
        UserInfoModel userInfoModel = UserInfoModel(userModel: userModel);
        ref.read(userInfoProvider.notifier).state =
            UserInfoModel(userModel: userModel);
        ref.read(chatLoginStateProvider.notifier).chatLogin(userInfoModel);
        ref
            .read(loginRouteStateProvider.notifier)
            .changeLoginRoute(LoginRoute.success);
      case LoginStatus.needSignUp:
        ref
            .read(loginRouteStateProvider.notifier)
            .changeLoginRoute(LoginRoute.signUpScreen);
      // case LoginStatus.withdrawalPending:
      // case LoginStatus.failure:
      // case LoginStatus.restriction:
      case LoginStatus.none:
      default:
        ref
            .read(loginRouteStateProvider.notifier)
            .changeLoginRoute(LoginRoute.none);
    }
  }

  void logout(String provider, String appKey) async {
    final loginRepository = LoginRepository(provider: provider);
    // final loginRepository = ref.watch(loginRepositoryProvider(provider));

    var result = await loginRepository.logout(appKey);
    if (result) {
      ref.read(loginRouteStateProvider.notifier).state = LoginRoute.none;
      ref.read(userModelProvider.notifier).state = null;
      saveUserModel(null);
      state = LoginStatus.none;
    }
  }

  void saveUserModel(UserModel? userModel) async {
    final prefs = await SharedPreferences.getInstance();
    String userModelKey = 'userModel';

    if (userModel == null) {
      await prefs.remove(userModelKey);
      return;
    }

    await prefs.setString(userModelKey, jsonEncode(userModel!.toJson()));
  }

  Future<UserModel?> _getUserModel() async {
    final prefs = await SharedPreferences.getInstance();
    String userModelKey = 'userModel';

    if (!prefs.containsKey(userModelKey)) {
      return null;
    }

    String strUserModel = prefs.getString(userModelKey)!;
    UserModel userModel = UserModel.fromJson(jsonDecode(strUserModel));
    return userModel;
  }

  Future autoLogin() async {
    UserModel? userModel = await _getUserModel();
    if (userModel == null) {
      print('aa');
      state = LoginStatus.failure;
      return;
    }

    loginByUserModel(userModel: userModel);
  }
}
