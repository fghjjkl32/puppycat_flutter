import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/main.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';

// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/login_screen.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_complete_screen.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';
import 'package:pet_mobile_social_flutter/ui/main/main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/splash/splash_screen.dart';
import 'package:pet_mobile_social_flutter/ui/web_view/webview_widget.dart';

final routerProvider = Provider<GoRouter>((ref) => AppRouter(ref: ref).router);

class AppRouter {
  GoRouter get router => _goRouter;
  var _loginRouteState = LoginRoute.none;
  var _signUpState = SignUpStatus.none;
  bool _splashState = false;

  final Ref ref;

  AppRouter({
    required this.ref,
  }) {
    _loginRouteState = ref.watch(loginRouteStateProvider);
    _signUpState = ref.watch(signUpStateProvider);
    _splashState = ref.watch(splashStateProvider);
  }

  late final GoRouter _goRouter = GoRouter(
    // refreshListenable: AppService(),//redirect 시 사용되는 리스너 이다.
    initialLocation: '/splash', //제일 처음 보여 줄 route
    debugLogDiagnostics: true, //router 정보 콘솔에 출력
    // errorBuilder: (BuildContext context, GoRouterState state) =>
    // const ErrorPage(),
    routes: <GoRoute>[
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const PuppyCatMain();
        },
        // routes: [
        //   /// sub Page를 설정할수 있다.
        //   GoRoute(
        //     path: 'geo',//sub page는 '/'를 생략해야 한다. 아니면 error
        //     builder: (BuildContext context, GoRouterState state) {
        //       return const GeoPage();
        //     },
        //   ),
        // ],
      ),
      GoRoute(
        path: '/loginScreen',
        name: 'loginScreen',
        builder: (_, state) => LoginScreen(),
        routes: [
          GoRoute(
            path: 'signupScreen',
            name: 'signupScreen',
            builder: (_, state) {
              return SignUpScreen();
            },
            routes: <GoRoute>[
              GoRoute(
                path: 'signupCompleteScreen',
                name: 'signupCompleteScreen',
                builder: (_, state) {
                  return SignUpCompleteScreen();
                },
              ),
              GoRoute(
                path: 'webview/:url',
                name: 'webview',
                builder: (BuildContext context, GoRouterState state) {
                  final url = Uri.decodeComponent(state.pathParameters['url']!);
                  return WebViewWidget(url : url);
                },
              ),
            ],
          ),
        ]
      ),

      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
    ],
    //redirect: 에서 앱 init되었는지, 로그인 여부, 세팅 등을 체크후 route한다.
    redirect: (BuildContext context, GoRouterState state) {
      const homeLocation = '/home';
      const loginLocation = '/loginScreen';
      const splashLocation = '/splash';
      const signUpLocation = '$loginLocation/signupScreen';
      const signUpCompleteLocation = '$signUpLocation/signupCompleteScreen';

      InitializationApp.initialize(ref);

      print('run?');
      bool isSplashPage = state.matchedLocation == splashLocation;
      if(isSplashPage) {
        print('run?2');
        if(_splashState) {
          print('run?3');
          if(_loginRouteState == LoginRoute.success) {
            return homeLocation;
          }
          print('aaaa');
          return loginLocation;
        } else {
          print('run?4');
          return null;
        }
      }

      bool isLoginPage = state.matchedLocation == loginLocation;
      if (isLoginPage) {
        if (_loginRouteState == LoginRoute.success) {
          return homeLocation;
        } else if (_loginRouteState == LoginRoute.signUpScreen) {
          return signUpLocation;
        } else {
          print('run????');
          return null;
        }
      }

      bool isSignUpPage = state.matchedLocation == signUpLocation;
      if(isSignUpPage) {
        if(_signUpState == SignUpStatus.success) {
          return signUpCompleteLocation;
        } else {
          return null;
        }
      }


    },
  );
}
