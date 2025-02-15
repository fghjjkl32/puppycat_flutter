import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/config/router/routes/login_route.dart';
import 'package:pet_mobile_social_flutter/ui/home/main_screen.dart';

class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    int? initialTabIndex;

    final extraData = state.extra;
    if (extraData != null) {
      Map<String, dynamic> extraMap = extraData as Map<String, dynamic>;
      if (extraMap.keys.contains('initialTabIndex')) {
        initialTabIndex = extraMap['initialTabIndex'];
      }
    }

    return PuppyCatMain(initialTabIndex: initialTabIndex ?? 0);
  }

  GoRoute createRoute() {
    return GoRoute(path: '/home', name: 'home', builder: (context, state) => build(context, state), routes: [
      LoginRoute().createRoute(),
    ]);
  }
}
