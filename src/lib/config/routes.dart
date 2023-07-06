import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/main.dart';
import 'package:pet_mobile_social_flutter/models/user/user_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/policy/policy_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/chat/chat_main_screen.dart';

// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/login_screen.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_complete_screen.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';
import 'package:pet_mobile_social_flutter/ui/main/comment/main_comment_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/main/report/main_feed_report_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_follow_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_my_activity_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_my_post_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/feed_detail/my_page_one_title_feed_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_profile_edit_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_alarm_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_blocked_user_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_faq_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_notice_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_privacy_policy_accepted_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_privacy_policy_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/feed_detail/my_page_two_title_feed_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_terms_of_service_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/withdrawal/my_page_withdrawal_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/withdrawal/my_page_withdrawal_select_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/withdrawal/my_page_withdrawal_success_screen.dart';
import 'package:pet_mobile_social_flutter/ui/main/main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/notification/notification_screen.dart';
import 'package:pet_mobile_social_flutter/ui/splash/splash_screen.dart';
import 'package:pet_mobile_social_flutter/ui/web_view/webview_widget.dart';

final routerProvider = Provider<GoRouter>((ref) => AppRouter(ref: ref).router);

class AppRouter {
  GoRouter get router => _goRouter;
  var _loginRouteState = LoginRoute.none;
  var _signUpState = SignUpRoute.none;
  bool _splashState = false;

  final Ref ref;

  AppRouter({
    required this.ref,
  }) {
    _loginRouteState = ref.watch(loginRouteStateProvider);
    _signUpState = ref.watch(signUpRouteStateProvider);
    _splashState = ref.watch(splashStateProvider);
  }

  late final GoRouter _goRouter = GoRouter(
    // refreshListenable: AppService(),//redirect 시 사용되는 리스너 이다.
    initialLocation: '/splash', //제일 처음 보여 줄 route
    debugLogDiagnostics: true, //router 정보 콘솔에 출력
    // errorBuilder: (BuildContext context, GoRouterState state) =>
    // const ErrorPage(),
    routes: <GoRoute>[
      GoRoute(
          path: '/home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const PuppyCatMain();
          },
          routes: [
            GoRoute(
              path: 'report/:isComment',
              name: 'report/:isComment',
              builder: (BuildContext context, GoRouterState state) {
                final isComment = state.pathParameters['isComment']!;
                return ReportScreen(
                  isComment: bool.parse(isComment),
                );
              },
            ),
            GoRoute(
              path: 'commentDetail',
              name: 'commentDetail',
              builder: (BuildContext context, GoRouterState state) {
                return const MainCommentDetailScreen();
              },
            ),
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
                    routes: [
                      GoRoute(
                          path: 'withdrawalSelect',
                          name: 'withdrawalSelect',
                          builder: (BuildContext context, GoRouterState state) {
                            return const MyPageWithdrawalSelectScreen();
                          },
                          routes: [
                            GoRoute(
                                path: 'withdrawalDetail',
                                name: 'withdrawalDetail',
                                builder: (BuildContext context, GoRouterState state) {
                                  return const MyPageWithdrawalDetailScreen();
                                },
                                routes: [
                                  GoRoute(
                                    path: 'withdrawalSuccess',
                                    name: 'withdrawalSuccess',
                                    builder: (BuildContext context, GoRouterState state) {
                                      return const MyPageWithdrawalSuccessScreen();
                                    },
                                  ),
                                ]),
                          ]),
                    ]),
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
            GoRoute(
              path: 'notification',
              name: 'notification',
              builder: (BuildContext context, GoRouterState state) {
                return const NotificationScreen();
              },
            ),
          ]
          // routes: [
          //   /// sub Page를 설정할수 있다.
          //   GoRoute(
          //     path: 'geo',//sub page는 '/'를 생략해야 한다. 아니면 error
          //     builder: (BuildContext context, GoRouterState state) {
          //       return const GeoPage();
          //     },
          //   ),
          // ],
          ),
      GoRoute(
          path: '/loginScreen',
          name: 'loginScreen',
          builder: (_, state) => LoginScreen(),
          routes: [
            GoRoute(
              path: 'signupScreen',
              name: 'signupScreen',
              builder: (_, state) {
                return SignUpScreen();
              },
              routes: <GoRoute>[
                GoRoute(
                  path: 'signupCompleteScreen',
                  name: 'signupCompleteScreen',
                  builder: (_, state) {
                    return SignUpCompleteScreen();
                  },
                ),
                GoRoute(
                  path: 'webview/:url',
                  name: 'webview',
                  builder: (BuildContext context, GoRouterState state) {
                    final url =
                        Uri.decodeComponent(state.pathParameters['url']!);
                    return WebViewWidget(url: url);
                  },
                ),
              ],
            ),
          ]),
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
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
    //   routes: [
    //     /// sub Page를 설정할수 있다.
    //     GoRoute(
    //       path: 'chatRoom',
    //       name: 'chatRoom',
    //       builder: (BuildContext context, GoRouterState state) {
    //         return const ReviewPage();
    //       },
    //     ),
    //   ],
    // ),
    // ],
    //redirect: 에서 앱 init되었는지, 로그인 여부, 세팅 등을 체크후 route한다.
    redirect: (BuildContext context, GoRouterState state) {
      const homeLocation = '/home';
      const loginLocation = '/loginScreen';
      const splashLocation = '/splash';
      const signUpLocation = '$loginLocation/signupScreen';
      const signUpCompleteLocation = '$signUpLocation/signupCompleteScreen';
      const chatMainLocation = '/chatMain';

      ///NOTE 테스트용 임시

      InitializationApp.initialize(ref);

      bool isSplashPage = state.matchedLocation == splashLocation;
      if (isSplashPage) {
        if (_splashState) {
          if (_loginRouteState == LoginRoute.success) {
            return homeLocation;
          }
          return loginLocation;
        } else {
          return null;
        }
      }

      bool isLoginPage = state.matchedLocation == loginLocation;
      if (isLoginPage) {
        if (_loginRouteState == LoginRoute.success) {
          return homeLocation;
        } else if (_loginRouteState == LoginRoute.signUpScreen) {
          return signUpLocation;
        } else {
          return null;
        }
      }

      bool isSignUpPage = state.matchedLocation == signUpLocation;
      if (isSignUpPage) {
        if (_signUpState == SignUpRoute.success) {
          return signUpCompleteLocation;
        } else {
          return null;
        }
      }
    },
  );
}
