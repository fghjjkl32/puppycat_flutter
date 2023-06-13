import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/main.dart';
import 'package:pet_mobile_social_flutter/ui/login/login_screen.dart';
import 'package:pet_mobile_social_flutter/ui/splash/splash_screen.dart';

class AppRouter {
  GoRouter get router => _goRouter;

  AppRouter();

  late final GoRouter _goRouter = GoRouter(
    // refreshListenable: AppService(),//redirect 시 사용되는 리스너 이다.
    initialLocation: '/loginScreen', //제일 처음 보여 줄 route
    debugLogDiagnostics: true, //router 정보 콘솔에 출력
    // errorBuilder: (BuildContext context, GoRouterState state) =>
    // const ErrorPage(),
    routes: <GoRoute>[
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const MyHomePage(title: 'test');
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
        builder: (_, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      // GoRoute(//id를 넘겨주어 navigarion 하는 방법
      //   path: '/book/:id',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const BookPage(id : state.params['id']);
      //   },
      //   routes: [
      //     /// sub Page를 설정할수 있다.
      //     GoRoute(
      //       path: 'review',//동일하게 sub rout를 가질 수 있다.
      //       builder: (BuildContext context, GoRouterState state) {
      //         return const ReviewPage();
      //       },
      //     ),
      //   ],
      // ),
    ],
    //redirect: 에서 앱 init되었는지, 로그인 여부, 세팅 등을 체크후 route한다.
    redirect: (BuildContext context, GoRouterState state) {
      const homeLocation = '/home';
      const splashLocation = '/splash';

      // final isInitialized = AppService().initialized;
      // //appService에서는 app 시작전 필요한 것들을 인스턴스화하는 과정을 포함한다.
      //
      // final isGoingToInit = state.subloc == splashLocation;
      //
      // /// 앱 시작전 권한, 로그인 여부, 세팅 등을 체크하고 route 한다.
      // if (!isInitialized && !isGoingToInit) {
      //   return splashLocation;
      // } else if ((isInitialized && isGoingToInit)) {
      //   return homeLocation;
      // } else {
      //   // Else Don't do anything
      //   return null;
      // }
    },
  );
}
