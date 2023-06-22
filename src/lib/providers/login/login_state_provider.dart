import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/login/login_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_state_provider.g.dart';

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
    var loginResult = await loginRepository.login();

    if(loginResult == null) {
      state = LoginStatus.failure;
      return;
    }

    print('loginResult.loginStatus ${loginResult.loginStatus}');
    state = loginResult.loginStatus;

    ///Login Route State 관련
    switch(loginResult.loginStatus) {
      case LoginStatus.success:
        ref.read(loginRouteStateProvider.notifier).changeLoginRoute(LoginRoute.success);
      case LoginStatus.needSignUp:
        ref.read(loginRouteStateProvider.notifier).changeLoginRoute(LoginRoute.signUpScreen);
      // case LoginStatus.withdrawalPending:
      // case LoginStatus.failure:
      // case LoginStatus.restriction:
      case LoginStatus.none:
      default:
        ref.read(loginRouteStateProvider.notifier).changeLoginRoute(LoginRoute.none);
    }
  }
}
