import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/maintenance/maintenance_screen.dart';

class MaintenanceRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InspectScreen();
  }

  GoRoute createRoute() {
    return GoRoute(
      path: '/maintenance',
      name: 'maintenance',
      builder: (context, state) => build(context, state),
    );
  }
}
