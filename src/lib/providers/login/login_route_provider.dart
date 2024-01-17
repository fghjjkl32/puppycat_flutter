import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_route_provider.g.dart';

enum LoginRouteEnum {
  none,
  loginScreen,
  signUpScreen,
  success,
}

@Riverpod(keepAlive: true)
class LoginRouteState extends _$LoginRouteState {
  @override
  LoginRouteEnum build() {
    return LoginRouteEnum.none;
  }

  void changeLoginRoute(LoginRouteEnum loginRoute) {
    print('changeLoginRoute $state / $loginRoute');
    state = loginRoute;
  }
}
