import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/setting/alarm/my_page_setting_alarm_screen.dart';
import 'package:pet_mobile_social_flutter/ui/setting/block_user/my_page_setting_blocked_user_screen.dart';
import 'package:pet_mobile_social_flutter/ui/setting/faq/my_page_setting_faq_screen.dart';
import 'package:pet_mobile_social_flutter/ui/setting/notice/my_page_setting_notice_screen.dart';
import 'package:pet_mobile_social_flutter/ui/setting/policy/my_page_setting_policy_screen.dart';
import 'package:pet_mobile_social_flutter/ui/setting/my_page_setting_screen.dart';
import 'package:pet_mobile_social_flutter/ui/notification/notification_screen.dart';
import 'package:pet_mobile_social_flutter/ui/splash/splash_screen.dart';
import 'package:pet_mobile_social_flutter/ui/web_view/webview_widget.dart';

class SplashRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }

  GoRoute createRoute() {
    return GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => build(context, state),
    );
  }
}
