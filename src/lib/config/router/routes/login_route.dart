import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/login/login_screen.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/signup_complete/sign_up_complete_screen.dart';

class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }

  GoRoute createRoute() {
    return GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => build(context, state),
      routes: [
        SignupRoute().createRoute(),
      ],
    );
  }
}

class SignupRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'signup/:authType',
      name: 'signup/:authType',
      builder: (_, state) {
        final authType = state.pathParameters['authType'];
        return SignUpScreen(authType: authType);
      },
      routes: [
        SignupCompleteRoute().createRoute(),
      ],
    );
  }
}

class SignupCompleteRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'signupComplete',
      name: 'signupComplete',
      builder: (_, state) {
        return const SignUpCompleteScreen();
      },
    );
  }
}
