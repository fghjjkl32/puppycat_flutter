import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_route_provider.g.dart';


enum SignUpRoute {
  none,
  success,
  failure,
}

@Riverpod(keepAlive: true)
class SignUpRouteState extends _$SignUpRouteState {
  @override
  SignUpRoute build() {
    return SignUpRoute.none;
  }

  void changeLoginRoute(SignUpRoute signUpRoute) {
    state = signUpRoute;
  }
}
