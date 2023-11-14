import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_message_controller.dart';
import 'package:pet_mobile_social_flutter/controller/notification/notification_controller.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_cloud_message_payload.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/notice_list_state_provider.dart';

final splashStateProvider = StateProvider<bool>((ref) => false);
final splashProgressStateProvider = StateProvider<double>((ref) => 0.0);
final _initStateProvider = StateProvider<bool>((ref) => false);
final isMaintenanceProvider = StateProvider<bool>((ref) => false);

class InitializationApp {
  static void initialize(Ref ref) async {
    if (ref.read(_initStateProvider)) {
      return;
    }
    // Permissions.requestPermissions();

    if (await _checkNetwork()) {
      if (await _checkServers()) {
        if (await _initFirebase()) {
          if (await getSinglePage(ref)) {
            ref.read(_initStateProvider.notifier).state = true;
          } else {
            ref.read(_initStateProvider.notifier).state = true;
            await ref.read(loginStateProvider.notifier).autoLogin();
          }
        }
      }
    }
  }

  static Future<bool> _initFirebase() async {
    // var result = Future.delayed(Duration(milliseconds: 300), () async {
    ///TODO
    ///결과값 제대로 받아서 처리하도록
    // if (!Platform.isIOS) {
    await GetIt.I<FireBaseMessageController>().init();
    // }
    return true;
    // });

    // return result;
  }

  static Future<bool> _checkNetwork() async {
    var result = Future.delayed(Duration(milliseconds: 300), () {
      print('net');
      return true;
    });

    return result;
  }

  static Future<bool> _checkServers() async {
    var result = Future.delayed(Duration(milliseconds: 300), () {
      print('ser');
      return true;
    });

    return result;
  }

  static Future<bool> getSinglePage(ref) async {
    const int maxRetries = 3;
    int currentRetries = 0;

    final remoteConfig = FirebaseRemoteConfig.instance;

    while (currentRetries < maxRetries) {
      try {
        await remoteConfig.fetchAndActivate();
        await remoteConfig.setConfigSettings(RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 1),
          minimumFetchInterval: const Duration(seconds: 1),
        ));

        lastestBuildVersion = remoteConfig.getString("lastest_build_version");

        if (remoteConfig.getBool("is_all_service_maintenance")) {
          Future.delayed(Duration(milliseconds: 1000), () {
            ref.read(isMaintenanceProvider.notifier).state = true;
          });
          return true;
        }
        return false;
      } catch (e) {
        currentRetries++; // 재시도 횟수를 증가시킵니다.
        if (currentRetries == maxRetries) {
          print("Remote Config 데이터를 가져오는 데 실패했습니다: $e");
        } else {
          print("재시도 중... ($currentRetries/$maxRetries)");
          await Future.delayed(Duration(seconds: 2)); // 2초 동안 기다립니다.
        }
      }
    }
    return false;
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  late Timer _splashTimer;

  @override
  void initState() {
    super.initState();

    _splashTimer = Timer(const Duration(milliseconds: 2500), () {
      if (ref.read(_initStateProvider)) {
        checkPushAppLaunch();
        ref.read(splashStateProvider.notifier).state = true;
      }
    });
  }

  void checkPushAppLaunch() async {
    NotificationAppLaunchDetails? details = await NotificationController().pushController.getNotificationAppLaunchDetails();
    if (details != null) {
      if (details.didNotificationLaunchApp) {
        if (details.notificationResponse != null) {
          if (details.notificationResponse!.payload != null) {
            FirebaseCloudMessagePayload payload = FirebaseCloudMessagePayload.fromJson(jsonDecode(details.notificationResponse!.payload!));
            // navigatorHandler(context, convertStringToPushType(payload.type), payload);
            navigatorHandler(payload);
          }
        }
      }
    }
  }

  void navigatorHandler(FirebaseCloudMessagePayload payload) {
    // context.push('/home/notification');
    final router = ref.watch(routerProvider);
    // router.go('/home/notification');
    PushType pushType = PushType.values.firstWhere((element) => payload.type == describeEnum(element), orElse: () => PushType.unknown);

    switch (pushType) {
      case PushType.follow:
        router.go('/home/notification');
        break;
      case PushType.new_contents:
      case PushType.metion_contents:
      case PushType.like_contents:
      case PushType.img_tag:
        var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;
        router.push("/home/myPage/detail/Contents/피드/$loginMemberIdx/${payload.contentsIdx}/notificationContent");
        break;

      case PushType.new_comment:
      case PushType.new_reply:
      case PushType.mention_comment:
      case PushType.like_comment:
        var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;
        router.push("/home/myPage/detail/nickname/피드/$loginMemberIdx/${payload.contentsIdx}/notificationContent", extra: {
          "isRouteComment": true,
          "focusIdx": payload.commentIdx,
        });
        break;

      case PushType.notice:
      case PushType.event:
        ref.read(noticeFocusIdxStateProvider.notifier).state = int.parse(payload.contentsIdx);
        ref.read(noticeExpansionIdxStateProvider.notifier).state = int.parse(payload.contentsIdx);
        router.push("/home/myPage/setting/notice", extra: {
          "contentsIdx": payload.contentsIdx,
        });
        break;
      case PushType.unknown:
        return;
    }
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(_initStateProvider, (previous, next) {
    //   if (!_splashTimer.isActive) {
    //     checkPushAppLaunch();
    //     ref.read(splashStateProvider.notifier).state = true;
    //   }
    // });

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Lottie.asset(
            'assets/lottie/character_00_introSplash_360x640.json',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
