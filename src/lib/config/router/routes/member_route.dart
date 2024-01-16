import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_follow_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_my_activity_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_my_post_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_profile_edit_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/user_main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/user_unknown_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/withdrawal/my_page_withdrawal_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/withdrawal/my_page_withdrawal_select_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/withdrawal/my_page_withdrawal_success_screen.dart';

//- /member - 라우트 대분류
//     - /myPage - 마이페이지
//         - /profileEdit - 프로필 수정 페이지
//             - /withdrawalSelect - 회원 탈퇴 페이지 (회원탈퇴 이유 선택 페이지)
//                 - /withdrawalDetail - 회원 탈퇴 상세 페이지 (회원탈퇴의 유저의 활동 정보 노출 페이지)
//                     - /withdrawalSuccess - 회원탈퇴 성공 페이지
//         - /activity - 내 활동 페이지 (좋아요/저장 리스트)
//         - /post - 내 작성 글 페이지
//     - /userPage - 유저페이지
//     - /followList - 팔로우 리스트 페이지
//     - /userUnknown - 유저 알수 없음 페이지
class MemberRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: '/member',
      name: 'member',
      builder: (BuildContext context, GoRouterState state) {
        return Container();
      },
      routes: [
        MyPageRoute().createRoute(),
        UserPageRoute().createRoute(),
        FollowListRoute().createRoute(),
        UserUnknownRoute().createRoute(),
      ],
    );
  }
}

class MyPageRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'myPage',
      name: 'myPage',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageMainScreen(
          oldMemberUuid: '',
        );
      },
      routes: [
        ProfileEditRoute().createRoute(),
        ActivityRoute().createRoute(),
        PostRoute().createRoute(),
      ],
    );
  }
}

class ProfileEditRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'profileEdit',
      name: 'profileEdit',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageProfileEditScreen();
      },
      routes: [
        WithdrawalSelectRoute().createRoute(),
      ],
    );
  }
}

class WithdrawalSelectRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'withdrawalSelect',
      name: 'withdrawalSelect',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageWithdrawalSelectScreen();
      },
      routes: [
        WithdrawalDetailRoute().createRoute(),
      ],
    );
  }
}

class WithdrawalDetailRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'withdrawalDetail',
      name: 'withdrawalDetail',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageWithdrawalDetailScreen();
      },
      routes: [
        WithdrawalSuccessRoute().createRoute(),
      ],
    );
  }
}

class WithdrawalSuccessRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'withdrawalSuccess',
      name: 'withdrawalSuccess',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageWithdrawalSuccessScreen();
      },
    );
  }
}

class ActivityRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'activity',
      name: 'activity',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageMyActivityListScreen();
      },
    );
  }
}

class PostRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'post',
      name: 'post',
      builder: (BuildContext context, GoRouterState state) {
        return const MyPageMyPostListScreen();
      },
    );
  }
}

class UserPageRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'userPage/:nick/:memUuid/:oldMemberUuid',
      name: 'userPage/:nick/:memUuid/:oldMemberUuid',
      builder: (BuildContext context, GoRouterState state) {
        final memberUuid = state.pathParameters['memUuid'];
        final nick = state.pathParameters['nick'];
        final oldMemberUuid = state.pathParameters['oldMemberUuid'];
        return UserMainScreen(
          memberUuid: memberUuid ?? '',
          nick: nick ?? '',
          oldMemberUuid: oldMemberUuid ?? '',
        );
      },
    );
  }
}

class FollowListRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'followList/:memberUuid',
      name: 'followList/:memberUuid',
      builder: (BuildContext context, GoRouterState state) {
        final memberUuid = state.pathParameters['memberUuid']!;
        return MyPageFollowListScreen(
          memberUuid: memberUuid,
        );
      },
    );
  }
}

class UserUnknownRoute extends GoRouteData {
  GoRoute createRoute() {
    return GoRoute(
      path: 'userUnknown',
      name: 'userUnknown',
      builder: (BuildContext context, GoRouterState state) {
        return const UserUnknownScreen();
      },
    );
  }
}
