import 'package:appspector/appspector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  runAppSpector();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('ko', 'KR'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('ko', 'KR'),
        child: const PuppycatApp(),
      ),
    ),
  );
  // runApp(MyApp());
}

class PuppycatApp extends ConsumerWidget {
  const PuppycatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // final loginState = ref.watch(loginStateProvider);
    // print('loginState : $loginState');

    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          routerConfig: router,
          title: 'Flutter Demo',
          theme: themeData(context),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

Future runAppSpector() async {
  final config = Config()..androidApiKey = "android_ODg1YjU5NmEtMTcwYi00M2NiLWIxMTYtMjIyN2VjY2M5OTk5";

  // If you don't want to start all monitors you can specify a list of necessary ones
  // config.monitors = [Monitors.http, Monitors.sqLite, Monitors.fileSystem];
  AppSpectorPlugin.run(config);
  Future(
    () async {
      final isStarted = await AppSpectorPlugin.shared().isStarted();
      if (!isStarted) {
        await AppSpectorPlugin.shared().start();
      }
    },
  );
}
