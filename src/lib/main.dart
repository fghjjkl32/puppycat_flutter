import 'package:appspector/appspector.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/common/util/PackageInfo/package_info_util.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';

import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_message_controller.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  baseUrl = await Constants.getBaseUrl();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  /// Get It
  /// SingleTon
  GetIt.I.registerSingleton<FireBaseMessageController>(
      FireBaseMessageController());

  GetIt.I.registerSingleton<UuidUtil>(UuidUtil());
  await GetIt.I<UuidUtil>().init();

  GetIt.I.registerSingleton<PackageInformationUtil>(PackageInformationUtil());
  await GetIt.I<PackageInformationUtil>().init();

  GetIt.I.registerSingleton<CookieJar>(CookieJar());

  // GetIt.I.registerSingleton<ChatClientController>(ChatClientController());

  // runAppSpector();
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

final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();

class PuppycatApp extends ConsumerWidget {
  const PuppycatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      // scaleByHeight: true,
      // useInheritedMediaQuery: false,
      builder: (BuildContext context, Widget? child) {
        return Portal(
          child: MaterialApp.router(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: router,
            title: 'Flutter Demo',
            theme: themeData(context),
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

Future runAppSpector() async {
  final config = Config()
    ..androidApiKey =
        "android_ODg1YjU5NmEtMTcwYi00M2NiLWIxMTYtMjIyN2VjY2M5OTk5";
  config.monitors = [Monitors.http, Monitors.sqLite, Monitors.fileSystem];

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
