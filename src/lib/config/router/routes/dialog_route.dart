import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_item_model.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/duplication_signup_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/error_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/components/dialog/restrain_dialog.dart';
import 'package:pet_mobile_social_flutter/ui/components/route_page/dialog_page.dart';

class DialogRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: '/dialog',
      name: 'dialog',
      builder: (BuildContext context, GoRouterState state) {
        return Container();
      },
      routes: [
        DuplicationSignupDialogRoute().createRoute(),
        RestrainDialogRoute().createRoute(),
        ErrorDialogRoute().createRoute(),
      ],
    );
  }
}

class DuplicationSignupDialogRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'duplicationSignupDialog',
      name: 'duplicationSignupDialog',
      pageBuilder: (BuildContext context, GoRouterState state) {
        String simpleType = '';
        String email = '';
        if (state.extra != null) {
          Map<String, dynamic> extraMap = {};
          extraMap = state.extra! as Map<String, dynamic>;

          if (extraMap.containsKey('simpleType')) {
            simpleType = extraMap['simpleType'];
          }

          if (extraMap.containsKey('id')) {
            email = extraMap['id'];
          }
        }

        return DialogPage(
          barrierDismissible: false,
          builder: (_) => WillPopScope(
            onWillPop: () async => false,
            child: DuplicationSignUpDialog(simpleType: simpleType, email: email),
          ),
        );
      },
    );
  }
}

class RestrainDialogRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'restrainDialog',
      name: 'restrainDialog',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return DialogPage(
          builder: (_) => RestrainDialog(
            restrainItemModel: state.extra as RestrainItemModel,
          ),
        );
      },
    );
  }
}

class ErrorDialogRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'errorDialog',
      name: 'errorDialog',
      pageBuilder: (BuildContext context, GoRouterState state) {
        String errorCode = 'unknown';
        if (state.extra != null) {
          if (state.extra is String) {
            errorCode = state.extra.toString();
          }
        }
        return DialogPage(
          builder: (_) => ErrorDialog(
            code: errorCode,
          ),
        );
      },
    );
  }
}
