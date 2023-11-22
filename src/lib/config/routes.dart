import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_mobile_social_flutter/components/dialog/dialog_page.dart';
import 'package:pet_mobile_social_flutter/components/dialog/error_dialog.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_route_provider.dart';
import 'package:pet_mobile_social_flutter/providers/notification/new_notification_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/push/push_payload_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_route_provider.dart';
// import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/ui/login/login_screen.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_complete_screen.dart';
import 'package:pet_mobile_social_flutter/ui/login/signup/sign_up_screen.dart';
import 'package:pet_mobile_social_flutter/ui/main/comment/comment_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/main/feed_search/feed_search_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/main/main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/main/report/main_feed_report_screen.dart';
import 'package:pet_mobile_social_flutter/ui/maintenance/maintenance_screen.dart';
///NOTE
///2023.11.14.
///산책하기 보류로 주석 처리
// import 'package:pet_mobile_social_flutter/ui/map/map_screen.dart';
///산책하기 보류로 주석 처리 완료
import 'package:pet_mobile_social_flutter/ui/my_page/feed_detail/feed_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_follow_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_my_activity_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_my_post_list_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/my_page_profile_edit_screen.dart';
///NOTE
///2023.11.14.
///산책하기 보류로 주석 처리
// import 'package:pet_mobile_social_flutter/ui/my_page/my_pet/my_pet_breed_search_screen.dart';
// import 'package:pet_mobile_social_flutter/ui/my_page/my_pet/my_pet_edit_screen.dart';
// import 'package:pet_mobile_social_flutter/ui/my_page/my_pet/my_pet_list_screen.dart';
// import 'package:pet_mobile_social_flutter/ui/my_page/my_pet/my_pet_registration_screen.dart';
///산책하기 보류로 주석 처리 완료
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_alarm_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_blocked_user_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_faq_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_notice_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_privacy_policy_accepted_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_privacy_policy_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/setting/my_page_setting_terms_of_service_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/user_main_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/user_unknown_screen.dart';
///NOTE
///2023.11.14.
///산책하기 보류로 주석 처리
// import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/walk_log_calendar_screen.dart';
// import 'package:pet_mobile_social_flutter/ui/my_page/walk_log/write_walk_log_screen.dart';
///산책하기 보류로 주석 처리 완료
import 'package:pet_mobile_social_flutter/ui/my_page/withdrawal/my_page_withdrawal_detail_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/withdrawal/my_page_withdrawal_select_screen.dart';
import 'package:pet_mobile_social_flutter/ui/my_page/withdrawal/my_page_withdrawal_success_screen.dart';
import 'package:pet_mobile_social_flutter/ui/notification/notification_screen.dart';
import 'package:pet_mobile_social_flutter/ui/search/search_screen.dart';
import 'package:pet_mobile_social_flutter/ui/splash/splash_screen.dart';
import 'package:pet_mobile_social_flutter/ui/web_view/webview_widget.dart';

final routerProvider = Provider<GoRouter>((ref) => AppRouter(ref: ref).router);

extension GoRouterExtension on GoRouter {
  String location() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch ? lastMatch.matches : routerDelegate.currentConfiguration;
    final String location = matchList.uri.toString();
    return location;
  }
}

class AppRouter {
  GoRouter get router => _goRouter;
  var _loginRouteState = LoginRoute.none;
  var _signUpState = SignUpRoute.none;
  bool _splashState = false;
  var _pushPayloadState = null;
  bool _maintenanceState = false;

  final Ref ref;

  // var _walkState = WalkStatus.idle;
  AppRouter({
    required this.ref,
  }) {
    _loginRouteState = ref.watch(loginRouteStateProvider);
    _signUpState = ref.watch(signUpRouteStateProvider);
    _splashState = ref.watch(splashStateProvider);
    _pushPayloadState = ref.watch(pushPayloadStateProvider);
    _maintenanceState = ref.watch(isMaintenanceProvider);
    // _pushPayloadState = ref.watch(pushPayloadNotifierProvider);
    // _walkState = ref.watch(walkStatusStateProvider);
  }

  late final GoRouter _goRouter = GoRouter(
    // refreshListenable: AppService(),//redirect 시 사용되는 리스너 이다.
    initialLocation: '/splash',
    //제일 처음 보여 줄 route
    debugLogDiagnostics: false,
    //router 정보 콘솔에 출력
    // errorBuilder: (BuildContext context, GoRouterState state) =>
    // const ErrorPage(),
    observers: [GoRouterObserver(ref: ref), FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
    routes: <GoRoute>[
      GoRoute(
          path: '/home',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const PuppyCatMain();
          },
          routes: [
            GoRoute(
              path: 'report/:isComment/:contentIdx',
              name: 'report/:isComment/:contentIdx',
              builder: (BuildContext context, GoRouterState state) {
                final isComment = state.pathParameters['isComment']!;
                final contentIdx = state.pathParameters['contentIdx']!;
                return ReportScreen(
                  isComment: bool.parse(isComment),
                  contentIdx: int.parse(contentIdx),
                );
              },
            ),
            GoRoute(
              path: 'search/:searchWord/:oldMemberIdx',
              name: 'search/:searchWord/:oldMemberIdx',
              builder: (BuildContext context, GoRouterState state) {
                final searchWord = state.pathParameters['searchWord']!;
                final oldMemberIdx = state.pathParameters['oldMemberIdx']!;
                return FeedSearchListScreen(
                  searchWord: searchWord,
                  oldMemberIdx: int.parse(oldMemberIdx),
                );
              },
            ),
            GoRoute(
              path: 'commentDetail/:contentIdx/:oldMemberIdx',
              name: 'commentDetail/:contentIdx/:oldMemberIdx',
              builder: (BuildContext context, GoRouterState state) {
                final contentIdx = state.pathParameters['contentIdx']!;
                final oldMemberIdx = state.pathParameters['oldMemberIdx']!;

                final extraData = state.extra;
                int? commentFocusIndex;
                if (extraData != null) {
                  Map<String, dynamic> extraMap = extraData as Map<String, dynamic>;
                  if (extraMap.keys.contains('focusIndex')) {
                    commentFocusIndex = extraMap['focusIndex'];
                  }
                }

                return CommentDetailScreen(
                  contentsIdx: int.parse(contentIdx),
                  commentFocusIndex: commentFocusIndex,
                  oldMemberIdx: int.parse(oldMemberIdx),
                );
              },
            ),
            GoRoute(
              path: 'search',
              name: 'search',
              builder: (BuildContext context, GoRouterState state) {
                return SearchScreen();
              },
            ),
            GoRoute(
              path: 'myPage',
              name: 'myPage',
              builder: (BuildContext context, GoRouterState state) {
                return const MyPageMainScreen(
                  oldMemberIdx: 0,
                );
              },
              routes: [
                ///NOTE
                ///2023.11.14.
                ///산책하기 보류로 주석 처리
                // GoRoute(
                //   path: 'myPetList',
                //   name: 'myPetList',
                //   builder: (BuildContext context, GoRouterState state) {
                //     return const MyPetListScreen();
                //   },
                //   routes: [
                //     GoRoute(
                //       path: 'myPetRegistration',
                //       name: 'myPetRegistration',
                //       builder: (BuildContext context, GoRouterState state) {
                //         return const MyPetRegistrationScreen();
                //       },
                //       routes: [
                //         GoRoute(
                //           path: 'myPetEdit/:idx',
                //           name: 'myPetEdit/:idx',
                //           builder: (BuildContext context, GoRouterState state) {
                //             final idx = state.pathParameters['idx']!;
                //             return MyPetEditScreen(idx: int.parse(idx));
                //           },
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
                // GoRoute(
                //   path: 'walkLogCalendar',
                //   name: 'walkLogCalendar',
                //   builder: (BuildContext context, GoRouterState state) {
                //     return const WalkLogCalendarScreen();
                //   },
                //   // routes: [
                //   //   GoRoute(
                //   //     path: 'myPetRegistration',
                //   //     name: 'myPetRegistration',
                //   //     builder: (BuildContext context, GoRouterState state) {
                //   //       return const MyPetRegistrationScreen();
                //   //     },
                //   //   ),
                //   // ],
                // ),
                ///산책하기 보류로 주석 처리 완료
                GoRoute(
                  path: 'userUnknown',
                  name: 'userUnknown',
                  builder: (BuildContext context, GoRouterState state) {
                    return const UserUnknownScreen();
                  },
                ),
                GoRoute(
                  path: 'detail/:firstTitle/:secondTitle/:memberIdx/:contentIdx/:contentType',
                  name: 'detail/:firstTitle/:secondTitle/:memberIdx/:contentIdx/:contentType',
                  builder: (BuildContext context, GoRouterState state) {
                    final firstTitle = state.pathParameters['firstTitle']!;
                    final secondTitle = state.pathParameters['secondTitle']!;
                    final memberIdx = state.pathParameters['memberIdx']!;
                    final contentIdx = state.pathParameters['contentIdx']!;
                    final contentType = state.pathParameters['contentType']!;

                    bool isRouteComment = false;
                    int? commentFocusIndex;
                    final extraData = state.extra;
                    if (extraData != null) {
                      Map<String, dynamic> extraMap = extraData as Map<String, dynamic>;
                      if (extraMap.keys.contains('isRouteComment')) {
                        isRouteComment = extraMap['isRouteComment'];
                      }
                      if (extraMap.keys.contains('focusIdx')) {
                        commentFocusIndex = extraMap['focusIdx'];
                      }
                    }

                    return FeedDetailScreen(
                      firstTitle: firstTitle,
                      secondTitle: secondTitle,
                      memberIdx: int.parse(memberIdx == "null" ? "0" : memberIdx),
                      contentIdx: int.parse(contentIdx),
                      contentType: contentType,
                      isRouteComment: isRouteComment,
                      commentFocusIndex: commentFocusIndex,
                      oldMemberIdx: 0,
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
                                  return MyPageWithdrawalDetailScreen();
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
                    path: 'followList/:memberIdx',
                    name: 'followList/:memberIdx',
                    builder: (BuildContext context, GoRouterState state) {
                      final memberIdx = state.pathParameters['memberIdx']!;
                      return MyPageFollowListScreen(
                        memberIdx: int.parse(memberIdx),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'userPage/:nick/:userIdx/:oldMemberIdx',
                        name: 'userPage/:nick/:userIdx/:oldMemberIdx',
                        builder: (BuildContext context, GoRouterState state) {
                          final memberIdx = state.pathParameters['userIdx']!;
                          final nick = state.pathParameters['nick']!;
                          final oldMemberIdx = state.pathParameters['oldMemberIdx']!;
                          return UserMainScreen(
                            memberIdx: int.parse(memberIdx),
                            nick: nick,
                            oldMemberIdx: int.parse(oldMemberIdx),
                          );
                        },
                      )
                    ]),
                GoRoute(
                  path: 'myActivity',
                  name: 'myActivity',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MyPageMyActivityListScreen();
                  },
                ),
                GoRoute(
                  path: 'myPost',
                  name: 'myPost',
                  builder: (BuildContext context, GoRouterState state) {
                    return const MyPageMyPostListScreen();
                  },
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
          ]),
      GoRoute(path: '/loginScreen', name: 'loginScreen', builder: (_, state) => LoginScreen(), routes: [
        GoRoute(
          path: 'signupScreen/:authType',
          name: 'signupScreen/:authType',
          builder: (_, state) {
            final authType = state.pathParameters['authType'];
            return SignUpScreen(authType: authType);
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
                final url = Uri.decodeComponent(state.pathParameters['url']!);
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

      ///NOTE
      ///2023.11.17.
      ///채팅 교체 예정으로 일단 주석 처리
      // GoRoute(
      //     path: '/chatMain',
      //     name: 'chatMain',
      //     builder: (BuildContext context, GoRouterState state) {
      //       return const ChatMainScreen();
      //     },
      //     routes: [
      //       GoRoute(
      //         path: 'chatRoom',
      //         name: 'chatRoom',
      //         builder: (BuildContext context, GoRouterState state) {
      //           if (state.extra is Room) {
      //             return ChatRoomScreen(room: state.extra! as Room);
      //             // return ChatRoomScreen(titleNick: 'testNick', msgList: [],);
      //           } else {
      //             return const ChatMainScreen();
      //           }
      //         },
      //       ),
      //       GoRoute(
      //         path: 'chatSearch',
      //         name: 'chatSearch',
      //         builder: (BuildContext context, GoRouterState state) {
      //           return const ChatSearchScreen();
      //         },
      //       ),
      //     ]),
      ///여기까지 채팅 교체 주석
      GoRoute(
        path: '/maintenance',
        name: 'maintenance',
        builder: (BuildContext context, GoRouterState state) {
          return const MaintenanceScreen();
        },
      ),

      ///NOTE
      ///2023.11.14.
      ///산책하기 보류로 주석 처리
      // GoRoute(
      //   path: '/map',
      //   name: 'map',
      //   builder: (BuildContext context, GoRouterState state) {
      //     String title = '지도';
      //     if (state.extra is String) {
      //       title = state.extra.toString();
      //     }
      //     return MapScreen(
      //       appBarTitle: title,
      //     );
      //   },
      // ),
      // GoRoute(
      //   path: '/writeWalkLog',
      //   name: 'writeWalkLog',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const WriteWalkLogScreen();
      //   },
      // ),
      ///산책하기 보류로 주석 처리 완료
      GoRoute(
        path: '/error_dialog',
        name: 'error_dialog',
        // builder: (BuildContext context, GoRouterState state) {
        //   return const MaintenanceScreen();
        // },
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
      ),
      GoRoute(
        path: '/error_bottom_sheet',
        name: 'error_bottom_sheet',
        // builder: (BuildContext context, GoRouterState state) {
        //   return const ErrorBottomSheetWidget();
        // },
        pageBuilder: (BuildContext context, GoRouterState state) {
          String errorCode = 'unknown';
          if (state.extra != null) {
            if (state.extra is String) {
              errorCode = state.extra.toString();
            }
          }

          return BottomSheetPage(
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                child: SingleChildScrollView(
                  child: CustomModalBottomSheet(
                    widget: WithDrawalPendingSheetItem(),
                    context: context,
                  ),
                ),
              );
            },
            isScrollControlled: false,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
          );
        },
      ),
    ],

    redirect: (BuildContext context, GoRouterState state) {
      const homeLocation = '/home';
      const loginLocation = '/loginScreen';
      const splashLocation = '/splash';
      const signUpLocation = '$loginLocation/signupScreen/:authType';
      const signUpCompleteLocation = '$signUpLocation/signupCompleteScreen';
      const maintenanceLocation = '/maintenance';

      InitializationApp.initialize(ref);

      bool isSplashPage = state.matchedLocation == splashLocation;
      if (isSplashPage) {
        if (_splashState) {
          if (_maintenanceState) {
            return maintenanceLocation;
          } else if (_loginRouteState == LoginRoute.success) {
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

      return null;
    },
  );
}

class GoRouterObserver extends NavigatorObserver {
  final Ref ref;

  GoRouterObserver({
    required this.ref,
  });

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didPush: $route');
    // ref.read(pushPayloadStateProvider.notifier).state = null;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didPop: $route / $previousRoute');
    if (route.settings.name == 'home' || previousRoute?.settings.name == 'home') {
      checkNewNotification();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print('MyTest didRemove: $route');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print('MyTest didReplace: $newRoute');
  }

  void checkNewNotification() {
    ref.read(newNotificationStateProvider.notifier).checkNewNotifications();
  }
}
