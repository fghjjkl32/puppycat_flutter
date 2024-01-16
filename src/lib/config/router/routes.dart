import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart' hide DialogRoute;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/bottom_sheet_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/chat_home_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/dialog_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/feed_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/home_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/login_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/maintenance_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/member_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/notification_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/search_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/setting_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/splash_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/toast_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/webview_route.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/maintenance/maintenance_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/notification/new_notification_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_route_provider.dart';
import 'package:pet_mobile_social_flutter/ui/splash/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => AppRouter(ref: ref).router);
// final routerProvider = StateProvider<GoRouter>((ref) {
//   final aa = GetIt.I.isRegistered<AppRouter>();
//   print('GoRouter $aa');
//   if (!aa) {
//     print('asdasdad');
//     final aaaa = GetIt.I.registerSingleton<AppRouter>(AppRouter(ref: ref));
//     print('asdasd222 ${GetIt.I<AppRouter>()}');
//   }
//   return GetIt.I<AppRouter>().router;
// });

extension GoRouterExtension on GoRouter {
  String location() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }
}

class AppRouter {
  GoRouter get router => _goRouter;
  var _loginRouteState = LoginRouteEnum.none; // ref.watch(loginRouteStateProvider); //LoginRoute.none;
  var _signUpState = SignUpRoute.none;
  bool _splashState = false;

  // var _pushPayloadState = null;
  bool _maintenanceState = false;
  bool _forceUpdateState = false;
  bool _recommendUpdateState = false;

  final Ref ref;

  // var _walkState = WalkStatus.idle;
  AppRouter({
    required this.ref,
  }) {
    _loginRouteState = ref.watch(loginRouteStateProvider);
    // _signUpState = ref.watch(signUpRouteStateProvider);
    _splashState = ref.watch(splashStateProvider);
    // _pushPayloadState = ref.watch(pushPayloadStateProvider);
    // _maintenanceState = ref.watch(isMaintenanceProvider);
    // _pushPayloadState = ref.watch(pushPayloadNotifierProvider);
    // _walkState = ref.watch(walkStatusStateProvider);
    print('asdasdasdasdasdzxczczxc');
  }

  late final GoRouter _goRouter = GoRouter(
    // refreshListenable: AppService(),//redirect 시 사용되는 리스너 이다.
    initialLocation: '/splash',
    //제일 처음 보여 줄 route
    debugLogDiagnostics: false,
    //router 정보 콘솔에 출력
    // errorBuilder: (BuildContext context, GoRouterState state) =>
    // const ErrorPage(),
    observers: [GoRouterObserver(ref: ref), FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
    routes: <GoRoute>[
      HomeRoute().createRoute(),
      FeedRoute(ref: ref).createRoute(),
      SearchRoute().createRoute(),
      SettingRoute().createRoute(),
      MemberRoute().createRoute(),
      NotificationRoute().createRoute(),
      LoginRoute().createRoute(),
      WebviewRoute().createRoute(),
      SplashRoute().createRoute(),
      MaintenanceRoute().createRoute(),
      BottomSheetRoute().createRoute(),
      DialogRoute().createRoute(),
      ToastRoute().createRoute(),
      ChatHomeRoute().createRoute(),

      ///NOTE
      ///2023.11.17.
      ///채팅 교체 예정으로 일단 주석 처리
      // GoRoute(
      //     path: '/chatMain',
      //     name: 'chatMain',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const ChatMainScreen();
      //     },
      //     routes: [
      //       GoRoute(
      //         path: 'chatRoom',
      //         name: 'chatRoom',
      //         builder: (BuildContext context, GoRouterState state) {
      //           if (state.extra is Room) {
      //             return ChatRoomScreen(room: state.extra! as Room);
      //             // return ChatRoomScreen(titleNick: 'testNick', msgList: [],);
      //           } else {
      //             return const ChatMainScreen();
      //           }
      //         },
      //       ),
      //       GoRoute(
      //         path: 'chatSearch',
      //         name: 'chatSearch',
      //         builder: (BuildContext context, GoRouterState state) {
      //           return const ChatSearchScreen();
      //         },
      //       ),
      //     ]),
      ///여기까지 채팅 교체 주석
      ///NOTE
      ///2023.11.14.
      ///산책하기 보류로 주석 처리
      // GoRoute(
      //   path: '/map',
      //   name: 'map',
      //   builder: (BuildContext context, GoRouterState state) {
      //     String title = '지도';
      //     if (state.extra is String) {
      //       title = state.extra.toString();
      //     }
      //     return MapScreen(
      //       appBarTitle: title,
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/writeWalkLog',
      //   name: 'writeWalkLog',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const WriteWalkLogScreen();
      //   },
      // ),
      ///산책하기 보류로 주석 처리 완료
    ],
    redirect: (BuildContext context, GoRouterState state) {
      const homeLocation = '/home';
      const loginLocation = '/login';
      const splashLocation = '/splash';
      const signUpLocation = '$loginLocation/signup/:authType';
      const signUpCompleteLocation = '$signUpLocation/signupComplete';
      const maintenanceLocation = '/maintenance';
      const forceUpdateLocation = 'bottomSheet/forceUpdateBottomSheet';
      const recommendUpdateLocation = 'bottomSheet/recommendUpdateBottomSheet';

      InitializationApp.initialize(ref);

      bool isSplashPage = state.matchedLocation == splashLocation;
      print('_loginRouteState $_loginRouteState');
      print('_splashState $_splashState');
      print('_signUpState $_signUpState');
      print('_maintenanceState $_maintenanceState');
      print('_recommendUpdateState $_recommendUpdateState');
      if (isSplashPage) {
        if (_splashState) {
          print('_splashState $_splashState');
          // _loginRouteState = ref.watch(loginRouteStateProvider);
          _signUpState = ref.watch(signUpRouteStateProvider);
          _maintenanceState = ref.watch(isInspectProvider);
          _forceUpdateState = ref.watch(isForceUpdateProvider);
          _recommendUpdateState = ref.watch(isRecommendUpdateProvider);

          if (_maintenanceState) {
            return maintenanceLocation;
          } else if (_forceUpdateState) {
            return forceUpdateLocation;
          } else if (_recommendUpdateState) {
            return recommendUpdateLocation;
          } else if (_loginRouteState == LoginRouteEnum.success) {
            return homeLocation;
          }
          return loginLocation;
        } else {
          return null;
        }
      }

      bool isLoginPage = state.matchedLocation == loginLocation;
      print('isLoginPage 1 $isLoginPage / $_loginRouteState / ${state.matchedLocation} / ${state.path} / ${state.fullPath}');
      if (isLoginPage) {
        print('isLoginPage 2 $isLoginPage / $_loginRouteState / ${state.matchedLocation} / ${state.path} / ${state.fullPath}');
        if (_loginRouteState == LoginRouteEnum.success) {
          print('isLoginPage 3 $isLoginPage / $_loginRouteState / ${state.matchedLocation} / ${state.path} / ${state.fullPath}');
          return homeLocation;
        } else if (_loginRouteState == LoginRouteEnum.signUpScreen) {
          print('isLoginPage 4 $isLoginPage / $_loginRouteState / ${state.matchedLocation} / ${state.path} / ${state.fullPath}');
          return signUpLocation;
        } else {
          return null;
        }
      }

      bool isSignUpPage = state.matchedLocation == signUpLocation;
      if (isSignUpPage) {
        if (_signUpState == SignUpRoute.success) {
          return signUpCompleteLocation;
        } else {
          return null;
        }
      }

      return null;
    },
  );
}

class GoRouterObserver extends NavigatorObserver {
  final Ref ref;

  GoRouterObserver({
    required this.ref,
  });

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didPush: $route');
    // ref.read(pushPayloadStateProvider.notifier).state = null;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didPop: $route / $previousRoute');
    if (route.settings.name == 'home' || previousRoute?.settings.name == 'home') {
      checkNewNotification();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didRemove: $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('MyTest didReplace: $newRoute');
  }

  void checkNewNotification() {
    ref.read(newNotificationStateProvider.notifier).checkNewNotifications();
  }
}
