import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/maintenance/maintenance_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_alarm_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_blocked_user_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_faq_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_notice_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_policy_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_screen.dart';
import 'package:pet_mobile_social_flutter/ui/notification/notification_screen.dart';
import 'package:pet_mobile_social_flutter/ui/splash/splash_screen.dart';
import 'package:pet_mobile_social_flutter/ui/web_view/webview_widget.dart';

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
