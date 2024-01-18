import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/notification/notification_screen.dart';

class NotificationRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const NotificationScreen();
  }

  GoRoute createRoute() {
    return GoRoute(
      path: '/notification',
      name: 'notification',
      builder: (context, state) => build(context, state),
    );
  }
}
