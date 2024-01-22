import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/providers/chat/chat_room_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/firebase/firebase_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/maintenance/maintenance_state_provider.dart';

final splashStateProvider = StateProvider<bool>((ref) => false);
final splashProgressStateProvider = StateProvider<double>((ref) => 0.0);
final _initStateProvider = StateProvider<bool>((ref) => false);

class InitializationApp {
  static void initialize(Ref ref) async {
    if (ref.read(_initStateProvider)) {
      return;
    }
    Permissions.requestPermissions();

    if (await _checkNetwork()) {
      if (await _checkServers()) {
        await ref.read(chatSocketStateProvider);
        if (await _initFirebase(ref)) {
          await ref.read(loginStateProvider.notifier).autoLogin();
          ref.read(_initStateProvider.notifier).state = true;
          //업데이트 팝업 로직
          ref.read(maintenanceStateProvider.notifier).startInspectPopupPolling();
          ref.read(maintenanceStateProvider.notifier).startUpdatePopupPolling();
        }
      }
    }
  }

  static Future<bool> _initFirebase(Ref ref) async {
    // final firebaseProvider = ref.read(firebaseStateProvider.notifier);
    ref.read(firebaseStateProvider.notifier).initFirebase();

    // var result = Future.delayed(Duration(milliseconds: 300), () async {
    // FireBaseMessageController fireBaseMessageController = GetIt.I<FireBaseMessageController>();

    ///TODO
    ///결과값 제대로 받아서 처리하도록
    // if (!Platform.isIOS) {
    // await fireBaseMessageController.init();
    // fireBaseMessageController.setBackgroundMessageOnTapHandler((payload) => navigatorHandler(ref, payload));
    //
    // if (fireBaseMessageController.initData != null) {
    //   navigatorHandler(ref, fireBaseMessageController.initData!);
    // }
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

    _splashTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      print('splash tick ${timer.tick} / $_splashTimerTick');

      if (_splashTimerTick < 3) {
        _splashTimerTick++;
        return;
      }

      if (ref.read(_initStateProvider)) {
        print('splash timer 1');
        print('splash timer 2');
        _splashTimer.cancel();
        print('splash timer 3');
        ref.read(splashStateProvider.notifier).state = true;
      } else {
        _splashTimerTick = 0;
      }
    });
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
