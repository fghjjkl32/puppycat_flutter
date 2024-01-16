import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/ui/main/main_screen.dart';

class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const PuppyCatMain();
  }

  GoRoute createRoute() {
    return GoRoute(
      path: '/home',
      name: 'home',
      onExit: (BuildContext context) async {
        bool backResult = onBackPressed();
        return await Future.value(backResult);
      },
      builder: (context, state) => build(context, state),
    );
  }
}
