import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_message_controller.dart';
import 'package:pet_mobile_social_flutter/controller/notification/notification_controller.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_cloud_message_payload.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/maintenance/maintenance_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/notice_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

final splashStateProvider = StateProvider<bool>((ref) => false);
final splashProgressStateProvider = StateProvider<double>((ref) => 0.0);
final _initStateProvider = StateProvider<bool>((ref) => false);

class InitializationApp {
  static void initialize(Ref ref) async {
    if (ref.read(_initStateProvider)) {
      return;
    }
    // Permissions.requestPermissions();

    if (await _checkNetwork()) {
      if (await _checkServers()) {
        await ref.read(chatSocketStateProvider);
        if (await _initFirebase()) {
          await ref.read(loginStateProvider.notifier).autoLogin();
          ref.read(_initStateProvider.notifier).state = true;
          //업데이트 팝업 로직
          ref.read(maintenanceStateProvider.notifier).startInspectPopupPolling();
          ref.read(maintenanceStateProvider.notifier).startUpdatePopupPolling();
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
    var result = Future.delayed(Duration(milliseconds: 100), () {
      print('net');
      return true;
    });

    return result;
  }

  static Future<bool> _checkServers() async {
    var result = Future.delayed(Duration(milliseconds: 100), () {
      print('ser');
      return true;
    });

    return result;
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  late Timer _splashTimer;
  int _splashTimerTick = 0;

  @override
  void initState() {
    super.initState();

    // _splashTimer = Timer(const Duration(milliseconds: 3000), () {
    //   if (ref.read(_initStateProvider)) {
    //     checkPushAppLaunch();
    //     print('77777777');
    //     ref.read(splashStateProvider.notifier).state = true;
    //   }
    // });
    _splashTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      print('splash tick ${timer.tick} / $_splashTimerTick');

      if (_splashTimerTick < 3) {
        _splashTimerTick++;
        return;
      }

      if (ref.read(_initStateProvider)) {
        print('splash timer 1');
        checkPushAppLaunch();
        print('splash timer 2');
        _splashTimer.cancel();
        print('splash timer 3');
        ref.read(splashStateProvider.notifier).state = true;
      } else {
        _splashTimerTick = 0;
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
    final myInfo = ref.read(myInfoStateProvider);
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
        router.push("/home/myPage/detail/Contents/피드/${myInfo.uuid}/${payload.contentsIdx}/notificationContent");
        break;

      case PushType.new_comment:
      case PushType.new_reply:
      case PushType.mention_comment:
      case PushType.like_comment:
        router.push("/home/myPage/detail/nickname/피드/${myInfo.uuid}/${payload.contentsIdx}/notificationContent", extra: {
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
            // 'assets/lottie/character_00_introSplash_360x640.json',
            // 'assets/lottie/character_00_AppSplash.json',
            'assets/lottie/character_00_AppSplash_231113.json',
            // repeat: false,
            // fit: BoxFit.fill,
            // repeat: false,
          ),
        ),
      ),
    );
  }
}
