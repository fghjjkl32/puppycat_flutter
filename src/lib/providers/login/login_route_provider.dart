
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_route_provider.g.dart';

enum LoginRoute {
  none,
  loginScreen,
  signUpScreen,
  success,
}

@Riverpod(keepAlive: true)
class LoginRouteState extends _$LoginRouteState {
  @override
  LoginRoute build() {
    return LoginRoute.none;
  }

  void changeLoginRoute(LoginRoute loginRoute) {
    state = loginRoute;
  }
}
