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
    print('changeLoginRoute $state / $loginRoute');
    state = loginRoute;
  }
}
