import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/toast/error_toast.dart';

class ToastRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: '/toast',
      name: 'toast',
      builder: (BuildContext context, GoRouterState state) {
        return Container();
      },
      routes: [
        ErrorToastRoute().createRoute(),
      ],
    );
  }
}

class ErrorToastRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'errorToast',
      name: 'errorToast',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          fullscreenDialog: true,
          opaque: false,
          barrierDismissible: true,
          transitionsBuilder: (_, __, ___, child) => child,
          child: ErrorToast(),
        );
      },
    );
  }
}
