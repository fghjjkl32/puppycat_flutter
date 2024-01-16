import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_alarm_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_blocked_user_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_faq_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_notice_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_policy_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_screen.dart';

class SettingRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyPageSettingScreen();
  }

  GoRoute createRoute() {
    return GoRoute(
      path: '/setting',
      name: 'setting',
      builder: (context, state) => build(context, state),
      routes: [
        AlarmRoute().createRoute(),
        BlockedUserRoute().createRoute(),
        PolicyRoute().createRoute(),
        FaqRoute().createRoute(),
        NoticeRoute().createRoute(),
      ],
    );
  }
}

class AlarmRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'alarm',
      name: 'alarm',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageSettingAlarmScreen();
      },
    );
  }
}

class BlockedUserRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'blockedUser',
      name: 'blockedUser',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageSettingBlockedUserScreen();
      },
    );
  }
}

class PolicyRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'policy',
      name: 'policy',
      builder: (BuildContext context, GoRouterState state) {
        List<String>? dateList = [];
        int idx = 0;
        String menuName = "";

        final extraData = state.extra;
        if (extraData != null) {
          Map<String, dynamic> extraMap = extraData as Map<String, dynamic>;
          if (extraMap.keys.contains('dateList')) {
            dateList = extraMap['dateList'];
          }
          if (extraMap.keys.contains('idx')) {
            idx = extraMap['idx'];
          }
          if (extraMap.keys.contains('menuName')) {
            menuName = extraMap['menuName'];
          }
        }

        return MyPageSettingPolicyScreen(idx: idx, dateList: dateList, menuName: menuName);
      },
    );
  }
}

class FaqRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'faq',
      name: 'faq',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageSettingFaqScreen();
      },
    );
  }
}

class NoticeRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'notice',
      name: 'notice',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageSettingNoticeScreen();
      },
    );
  }
}
