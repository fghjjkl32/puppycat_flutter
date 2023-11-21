import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_user_model.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_info_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_register_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/login/login_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state_provider.g.dart';

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
    final loginRepository = LoginRepository(provider: provider, dio: ref.read(dioProvider));

    try {
      // var loginResult = await loginRepository.login();
      final socialUserModel = await loginRepository.socialLogin();
      UserInfoModel userInfoModel = ref.read(userInfoProvider);
      ref.read(userInfoProvider.notifier).state = userInfoModel.copyWith(
        userModel: socialUserModel,
      );

      final loginResult = await loginRepository.loginByUserModel(userModel: socialUserModel);
      _procLogin(loginResult);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('login exception ($e)');
      ref.read(userInfoProvider.notifier).state = UserInfoModel();
    }
  }

  ///NOTE
  ///이미 Social(Naver, kakao ...) Login은 완료된 상태에서 로그인 진행 시키기 위한 함수
  void loginByUserModel({
    required UserModel userModel,
  }) async {
    final loginRepository = LoginRepository(provider: userModel.simpleType, dio: ref.read(dioProvider));

    try {
      var loginResult = await loginRepository.loginByUserModel(userModel: userModel);
      _procLogin(loginResult);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('auto login exception ($e)');
      state = LoginStatus.failure;
    }
  }

  Future<void> _procLogin(UserModel? userModel) async {
    if (userModel == null) {
      print('login state userModel null');
      state = LoginStatus.failure;
      ref.read(loginRouteStateProvider.notifier).changeLoginRoute(LoginRoute.none);
      return;
    }

    saveUserModel(userModel);
    UserInfoModel userInfoModel = UserInfoModel(userModel: userModel);

    ref.read(loginRouteStateProvider.notifier).changeLoginRoute(LoginRoute.success);
    ref.read(myInfoStateProvider.notifier).getMyInfo(userModel.idx.toString());

    ref.listen(myInfoStateProvider, (previous, next) {
      print('next $next');

      ///TODO
      /// previous와 next값 (이전값)이 같을때 해당 로직 무시하는 코드
      /// 회원탈퇴하고, 7일전 데이터로 다시 로그인 하면 스테이트가 변경되자 않아서 주석처리 진행
      // if (previous == next) {
      //   return;
      // }

      userInfoModel = userInfoModel.copyWith(
          userModel: userModel.copyWith(
        idx: next.memberIdx ?? userModel.idx,
        nick: next.nick ?? userModel.nick,
        id: next.email ?? userModel.id,
        name: next.name ?? userModel.name,
        phone: next.phone ?? userModel.phone,
        introText: next.intro,
        profileImgUrl: next.profileImgUrl,
        isBadge: next.isBadge ?? 0,
        uuid: next.uuid ?? userModel.uuid,
        channelTalkHash: next.channelTalkHash ?? userModel.channelTalkHash,
      ));

      ///NOTE
      ///2023.11.16.
      ///채팅 교체 예정으로 일단 주석 처리
      // if (ref.read(myInfoStateProvider.notifier).checkChatInfo(next)) {
      //   // ref.read(chatRegisterStateProvider.notifier).register(userModel);
      //   userInfoModel = userInfoModel.copyWith(
      //     chatUserModel: ChatUserModel(
      //       chatMemberId: next.chatMemberId,
      //       homeServer: next.chatHomeServer,
      //       deviceId: next.chatDeviceId,
      //       accessToken: next.chatAccessToken,
      //     ),
      //   );
      // }
      ///여기까지 채팅 교체 주석

      ref.read(followUserStateProvider.notifier).resetState();

      ///NOTE
      ///2023.11.16.
      ///채팅 교체 예정으로 일단 주석 처리
      // ref.read(chatLoginStateProvider.notifier).chatLogin(userInfoModel);
      ///여기까지 채팅 교체 주석

      ref.read(userInfoProvider.notifier).state = userInfoModel;
    });

    print('userInfoModel :: $userInfoModel');
    ref.read(userInfoProvider.notifier).state = userInfoModel;
    state = LoginStatus.success;
  }

  void logout(String provider, String appKey) async {
    final loginRepository = LoginRepository(provider: provider, dio: ref.read(dioProvider));

    try {
      var result = await loginRepository.logout(appKey);
      if (result) {
        var userInfoModel = ref.read(userInfoProvider);

        ///NOTE
        ///2023.11.16.
        ///채팅 교체 예정으로 일단 주석 처리
        //     var chatController = ref.read(chatControllerProvider(ChatControllerInfo(provider: 'matrix', clientName: 'puppycat_${userInfoModel.userModel!.idx}')));
        //     chatController.controller.logout();
        ///여기까지 채팅 교체 주석

        ref.read(loginRouteStateProvider.notifier).state = LoginRoute.none;
        ref.read(followUserStateProvider.notifier).resetState();
        ref.read(userInfoProvider.notifier).state = UserInfoModel();
        saveUserModel(null);
        state = LoginStatus.none;
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('logout exception ($e)');
      state = LoginStatus.failure;
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
      print('AutoLogin Failed');
      state = LoginStatus.failure;
      ref.read(loginRouteStateProvider.notifier).state = LoginRoute.loginScreen;
      return;
    }

    loginByUserModel(userModel: userModel);
  }
}
