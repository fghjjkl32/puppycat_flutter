import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_message_controller.dart';
import 'package:pet_mobile_social_flutter/controller/permission/permissions.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

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
        if (await _initFirebase()) {
          ref.read(_initStateProvider.notifier).state = true;
          await ref.read(loginStateProvider.notifier).autoLogin();
        }
      }
    }
  }

  static Future<bool> _initFirebase() async {
    // var result = Future.delayed(Duration(milliseconds: 300), () async {
    ///TODO
    ///결과값 제대로 받아서 처리하도록
    await GetIt.I<FireBaseMessageController>().init();
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

    _splashTimer = Timer(const Duration(seconds: 3), () {
      if (ref.read(_initStateProvider)) {
        ref.read(splashStateProvider.notifier).state = true;
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
    ref.listen(_initStateProvider, (previous, next) {
      if (!_splashTimer.isActive) {
        ref.read(splashStateProvider.notifier).state = true;
      }
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Splash Screen'),
            ],
          ),
        ),
      ),
    );
  }
}
