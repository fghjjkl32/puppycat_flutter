import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/ui/member/follow_list/my_page_follow_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/member/my_page/activity/my_page_my_activity_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/member/my_page/my_page_main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/member/my_page/post/my_page_my_post_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/member/my_page/profile_edit/my_page_profile_edit_screen.dart';
import 'package:pet_mobile_social_flutter/ui/member/my_page/profile_edit/withdrawal_select/my_page_withdrawal_select_screen.dart';
import 'package:pet_mobile_social_flutter/ui/member/my_page/profile_edit/withdrawal_select/withdrawal_detail/my_page_withdrawal_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/member/my_page/profile_edit/withdrawal_select/withdrawal_detail/withdrawal_success/my_page_withdrawal_success_screen.dart';
import 'package:pet_mobile_social_flutter/ui/member/user_page/user_main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/member/user_unknown/user_unknown_screen.dart';

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
        String? oldMemberUuid;
        int? feedContentIdx;

        final extraData = state.extra;
        if (extraData != null) {
          Map<String, dynamic> extraMap = extraData as Map<String, dynamic>;
          if (extraMap.keys.contains('oldMemberUuid')) {
            oldMemberUuid = extraMap['oldMemberUuid'];
          }
          if (extraMap.keys.contains('feedContentIdx')) {
            feedContentIdx = extraMap['feedContentIdx'];
          }
        }
        return MyPageMainScreen(
          oldMemberUuid: oldMemberUuid ?? '',
          feedContentIdx: feedContentIdx ?? 0,
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
      path: 'userPage',
      name: 'userPage',
      builder: (BuildContext context, GoRouterState state) {
        String? memberUuid;
        String? nick;
        String? oldMemberUuid;
        int? feedContentIdx;

        final extraData = state.extra;
        if (extraData != null) {
          Map<String, dynamic> extraMap = extraData as Map<String, dynamic>;
          if (extraMap.keys.contains('memberUuid')) {
            memberUuid = extraMap['memberUuid'];
          }
          if (extraMap.keys.contains('nick')) {
            nick = extraMap['nick'];
          }
          if (extraMap.keys.contains('oldMemberUuid')) {
            oldMemberUuid = extraMap['oldMemberUuid'];
          }
          if (extraMap.keys.contains('feedContentIdx')) {
            feedContentIdx = extraMap['feedContentIdx'];
          }
        }

        return UserMainScreen(
          memberUuid: memberUuid ?? '',
          nick: nick ?? '',
          oldMemberUuid: oldMemberUuid == null || oldMemberUuid == "null" ? '' : oldMemberUuid,
          feedContentIdx: feedContentIdx ?? 0,
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
