import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/main.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';

// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/login_screen.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_follow_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_my_activity_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_my_post_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_one_title_feed_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_profile_edit_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_alarm_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_blocked_user_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_faq_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_notice_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_privacy_policy_accepted_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_privacy_policy_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_two_title_feed_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_terms_of_service_screen.dart';
import 'package:pet_mobile_social_flutter/ui/splash/splash_screen.dart';

final routerProvider = Provider<GoRouter>((ref) => AppRouter(ref: ref).router);

class AppRouter {
  GoRouter get router => _goRouter;
  var _loginRouteState = LoginRoute.none;

  final Ref ref;

  AppRouter({
    required this.ref,
  }) {
    _loginRouteState = ref.watch(loginRouteStateProvider);
  }

  late final GoRouter _goRouter = GoRouter(
    // refreshListenable: AppService(),//redirect 시 사용되는 리스너 이다.
    initialLocation: '/test', //제일 처음 보여 줄 route
    debugLogDiagnostics: true, //router 정보 콘솔에 출력
    // errorBuilder: (BuildContext context, GoRouterState state) =>
    // const ErrorPage(),
    routes: <GoRoute>[
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const MyHomePage(title: 'test');
      //   },
      //   // routes: [
      //   //   /// sub Page를 설정할수 있다.
      //   //   GoRoute(
      //   //     path: 'geo',//sub page는 '/'를 생략해야 한다. 아니면 error
      //   //     builder: (BuildContext context, GoRouterState state) {
      //   //       return const GeoPage();
      //   //     },
      //   //   ),
      //   // ],
      // ),
      GoRoute(
        path: '/loginScreen',
        name: 'loginScreen',
        builder: (_, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signupScreen',
        name: 'signupScreen',
        builder: (_, state) {
          ref.read(policyStateProvider.notifier).getPolicies();
          return SignUpScreen();
        },
      ),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
          path: '/test',
          name: 'test',
          builder: (BuildContext context, GoRouterState state) {
            return const MyHomePage(
              title: 'test',
            );
          },
          routes: [
            GoRoute(
              path: 'myPage',
              name: 'myPage',
              builder: (BuildContext context, GoRouterState state) {
                return const MyPageMainScreen();
              },
              routes: [
                GoRoute(
                  path: 'detail/:firstTitle/:secondTitle',
                  name: 'detail/:firstTitle/:secondTitle',
                  builder: (BuildContext context, GoRouterState state) {
                    final firstTitle = state.pathParameters['firstTitle']!;
                    final secondTitle = state.pathParameters['secondTitle']!;
                    return MyPageTwoTitleFeedDetailScreen(
                      firstTitle: firstTitle,
                      secondTitle: secondTitle,
                    );
                  },
                ),
                GoRoute(
                  path: 'profileEdit',
                  name: 'profileEdit',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MyPageProfileEditScreen();
                  },
                ),
                GoRoute(
                  path: 'followList',
                  name: 'followList',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MyPageFollowListScreen();
                  },
                ),
                GoRoute(
                  path: 'myActivity',
                  name: 'myActivity',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MyPageMyActivityListScreen();
                  },
                  routes: [
                    GoRoute(
                      path: 'myActivityDetail/:title',
                      name: 'myActivityDetail/:title',
                      builder: (BuildContext context, GoRouterState state) {
                        final title = state.pathParameters['title']!;
                        return MyPageOneTitleFeedDetailScreen(
                          title: title,
                        );
                      },
                    )
                  ],
                ),
                GoRoute(
                  path: 'myPost',
                  name: 'myPost',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MyPageMyPostListScreen();
                  },
                  routes: [
                    GoRoute(
                      path: 'myPostDetail/:title',
                      name: 'myPostDetail/:title',
                      builder: (BuildContext context, GoRouterState state) {
                        final title = state.pathParameters['title']!;
                        return MyPageOneTitleFeedDetailScreen(
                          title: title,
                        );
                      },
                    )
                  ],
                ),
                GoRoute(
                  path: 'setting',
                  name: 'setting',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MyPageSettingScreen();
                  },
                  routes: [
                    GoRoute(
                      path: 'settingAlarm',
                      name: 'settingAlarm',
                      builder: (BuildContext context, GoRouterState state) {
                        return const MyPageSettingAlarmScreen();
                      },
                    ),
                    GoRoute(
                      path: 'settingBlockedUser',
                      name: 'settingBlockedUser',
                      builder: (BuildContext context, GoRouterState state) {
                        return const MyPageSettingBlockedUserScreen();
                      },
                    ),
                    GoRoute(
                      path: 'TermsOfService',
                      name: 'TermsOfService',
                      builder: (BuildContext context, GoRouterState state) {
                        return const MyPageSettingTermsOfServiceScreen();
                      },
                    ),
                    GoRoute(
                      path: 'PrivacyPolicy',
                      name: 'PrivacyPolicy',
                      builder: (BuildContext context, GoRouterState state) {
                        return const MyPageSettingPrivacyPolicyScreen();
                      },
                    ),
                    GoRoute(
                      path: 'PrivacyPolicyAccepted',
                      name: 'PrivacyPolicyAccepted',
                      builder: (BuildContext context, GoRouterState state) {
                        return const MyPageSettingPrivacyPolicyAcceptedScreen();
                      },
                    ),
                    GoRoute(
                      path: 'FAQ',
                      name: 'FAQ',
                      builder: (BuildContext context, GoRouterState state) {
                        return const MyPageSettingFaqScreen();
                      },
                    ),
                    GoRoute(
                      path: 'notice',
                      name: 'notice',
                      builder: (BuildContext context, GoRouterState state) {
                        return const MyPageSettingNoticeScreen();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ]),
      // GoRoute(//id를 넘겨주어 navigarion 하는 방법
      //   path: '/book/:id',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const BookPage(id : state.params['id']);
      //   },
      //   routes: [
      //     /// sub Page를 설정할수 있다.
      //     GoRoute(
      //       path: 'review',//동일하게 sub rout를 가질 수 있다.
      //       builder: (BuildContext context, GoRouterState state) {
      //         return const ReviewPage();
      //       },
      //     ),
      //   ],
      // ),
    ],
    //redirect: 에서 앱 init되었는지, 로그인 여부, 세팅 등을 체크후 route한다.
    redirect: (BuildContext context, GoRouterState state) {
      const homeLocation = '/home';
      const loginLocation = '/loginScreen';
      const splashLocation = '/splash';
      const signUpLocation = '/signupScreen';

      bool isLoginPage = state.matchedLocation == loginLocation;
      if (isLoginPage) {
        if (_loginRouteState == LoginRoute.success) {
          return homeLocation;
        } else if (_loginRouteState == LoginRoute.signUpScreen) {
          return signUpLocation;
        } else {
          print('run????');
          return null;
        }
      }

      // final isInitialized = AppService().initialized;
      // //appService에서는 app 시작전 필요한 것들을 인스턴스화하는 과정을 포함한다.
      //
      // final isGoingToInit = state.subloc == splashLocation;
      //
      // /// 앱 시작전 권한, 로그인 여부, 세팅 등을 체크하고 route 한다.
      // if (!isInitialized && !isGoingToInit) {
      //   return splashLocation;
      // } else if ((isInitialized && isGoingToInit)) {
      //   return homeLocation;
      // } else {
      //   // Else Don't do anything
      //   return null;
      // }
    },
  );
}
