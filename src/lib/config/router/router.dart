import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart' hide DialogRoute;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/bottom_sheet_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/chat_home_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/dialog_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/feed_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/home_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/maintenance_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/member_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/notification_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/search_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/setting_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/splash_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/toast_route.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/webview_route.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/maintenance/maintenance_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/notification/new_notification_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/splash/splash_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

extension GoRouterExtension on GoRouter {
  String location() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }
}

@riverpod
GoRouter router(Ref ref) {
  bool splashState = false;

  bool maintenanceState = false;
  bool forceUpdateState = false;
  bool recommendUpdateState = false;

  final isRefresh = ValueNotifier<bool>(false);
  ref
    ..onDispose(() {
      isRefresh.dispose();
    })
    ..listen(splashStateProvider, (previous, next) {
      if (previous == next) {
        return;
      }
      splashState = next;
      print('splashState $splashState / isRefresh ${isRefresh.value}');
      isRefresh.value = !isRefresh.value;
    })
    ..listen(isInspectProvider, (previous, next) {
      if (previous == next) {
        return;
      }
      maintenanceState = next;
      print('maintenanceState $maintenanceState / isRefresh ${isRefresh.value}');
      isRefresh.value = !isRefresh.value;
    })
    ..listen(isForceUpdateProvider, (previous, next) {
      if (previous == next) {
        return;
      }
      forceUpdateState = next;
      print('forceUpdateState $forceUpdateState / isRefresh ${isRefresh.value}');
      isRefresh.value = !isRefresh.value;
    })
    ..listen(isRecommendUpdateProvider, (previous, next) {
      if (previous == next) {
        return;
      }
      recommendUpdateState = next;
      print('recommendUpdateState $recommendUpdateState / isRefresh ${isRefresh.value}');
      isRefresh.value = !isRefresh.value;
    });

  final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: isRefresh,
    debugLogDiagnostics: true,
    observers: [GoRouterObserver(ref: ref), FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
    routes: <GoRoute>[
      HomeRoute().createRoute(),
      FeedRoute(ref: ref).createRoute(),
      SearchRoute().createRoute(),
      SettingRoute().createRoute(),
      MemberRoute().createRoute(),
      NotificationRoute().createRoute(),
      // LoginRoute().createRoute(), //home 하위 경로로 이동
      WebviewRoute().createRoute(),
      SplashRoute().createRoute(),
      MaintenanceRoute().createRoute(),
      BottomSheetRoute().createRoute(),
      DialogRoute().createRoute(),
      ToastRoute().createRoute(),
      ChatHomeRoute().createRoute(),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      const homeLocation = '/home';
      const loginLocation = '/home/login';
      const splashLocation = '/splash';
      const signUpLocation = '$loginLocation/signup/:authType';
      const signUpCompleteLocation = '$signUpLocation/signupComplete';
      const maintenanceLocation = '/maintenance';
      const forceUpdateLocation = '/bottomSheet/forceUpdateBottomSheet';
      const recommendUpdateLocation = '/bottomSheet/recommendUpdateBottomSheet';

      InitializationApp.initialize(ref);

      final isLogined = ref.read(loginStatementProvider);

      bool isSplashPage = state.matchedLocation == splashLocation;
      if (isSplashPage) {
        if (splashState) {
          // signUpState = ref.watch(signUpRouteStateProvider);
          maintenanceState = ref.watch(isInspectProvider);
          forceUpdateState = ref.watch(isForceUpdateProvider);
          recommendUpdateState = ref.watch(isRecommendUpdateProvider);

          if (maintenanceState) {
            return maintenanceLocation;
          } else if (forceUpdateState) {
            return forceUpdateLocation;
          } else if (recommendUpdateState) {
            return recommendUpdateLocation;
          } else if (isLogined) {
            return homeLocation;
          }
          return loginLocation;
        } else {
          return null;
        }
      }
      return null;
    },
  );

  return router;
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
