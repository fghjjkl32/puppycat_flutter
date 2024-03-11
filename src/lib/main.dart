import 'dart:async';

import 'package:appspector/appspector.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
// import 'package:location/location.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/flavor_config.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/common/util/package_info/package_info_util.dart';
import 'package:pet_mobile_social_flutter/config/router/router.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_options.dart';

InAppLocalhostServer localhostServer = InAppLocalhostServer(port: 9723);
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}

void mainCommon() async {
  print("FlavorConfig ${FlavorConfig.instance.values?.name}");
  print("isAndroid ${FlavorConfig.isAndroid()}");

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  // baseUrl = await Constants.getBaseUrl();
  // thumborHostUrl = await Constants.getThumborHostUrl();
  // thumborKey = await Constants.getThumborKey();
  firstInstallTime = await checkFirstInstall();
  // inspectS3BaseUrl = await Constants.getInspectS3Domain();
  // updateS3BaseUrl = await Constants.getUpdateS3Domain();
  initRunningMode();

  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  const systemUIOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
  );

  SystemChrome.setSystemUIOverlayStyle(systemUIOverlayStyle);

  /// Get It
  /// SingleTon
  GetIt.I.registerSingleton<UuidUtil>(UuidUtil());
  await GetIt.I<UuidUtil>().init();

  GetIt.I.registerSingleton<PackageInformationUtil>(PackageInformationUtil());
  await GetIt.I<PackageInformationUtil>().init();

  GetIt.I.registerSingleton<CookieJar>(CookieJar());

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

class PuppycatApp extends ConsumerStatefulWidget {
  const PuppycatApp({Key? key}) : super(key: key);

  @override
  PuppycatAppState createState() => PuppycatAppState();
}

class PuppycatAppState extends ConsumerState<PuppycatApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 포그라운드에 있음
      print('Foreground!!!!!!!!!!!');
    } else if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드에 있음
      // 앱이 백그라운드로 전환될 때 특정 함수를 호출하려면 여기에서 호출하면 됩니다.
      // 예를 들어:
      print('Background!!!!!!!!!!!');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    final router = ref.watch(routerProvider);
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      // scaleByHeight: true,
      // useInheritedMediaQuery: false,
      builder: (BuildContext context, Widget? child) {
        return Portal(
          child: MaterialApp.router(
            scaffoldMessengerKey: scaffoldMessengerKey,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: router,
            title: 'Flutter Demo',
            theme: themeData(context),
            debugShowCheckedModeBanner: false,
            builder: (context, widget) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return CustomError(errorDetails: errorDetails);
              };

              return MediaQuery(data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0), child: ScrollConfiguration(behavior: const ScrollBehaviorModified(), child: widget!));
            },
          ),
        );
      },
    );
  }
}

Future runAppSpector() async {
  final config = Config()..androidApiKey = "android_ODg1YjU5NmEtMTcwYi00M2NiLWIxMTYtMjIyN2VjY2M5OTk5";
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

class CustomError extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomError({
    super.key,
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    print("error debug : ${errorDetails}");
    double deviceWidth = MediaQuery.of(context).size.width;

    double image1Width = 131 * 0.9; // 첫 번째 이미지 폭
    double image2Width = 56 * 0.9; // 두 번째 이미지 폭
    double image3Width = 141 * 0.9; // 세 번째 이미지 폭

    // 첫 번째 이미지를 중앙에 두기 위해 양 옆에 남는 공간을 계산
    double availableWidthPerSide = (deviceWidth - image1Width - image3Width) / 2;

    // 사용 가능한 공간을 2번 이미지의 너비로 나누어 양 옆에 오는 이미지의 개수를 결정
    int numberOfWidgetsPerSide = (availableWidthPerSide / image2Width).floor();

    return Material(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            "",
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Puppycat_social.icon_back,
              size: 40,
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    widthFactor: 0.9,
                    child: Image.asset(
                      'assets/image/character/character_02_page_error_1.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                for (var i = 0; i < numberOfWidgetsPerSide; i++)
                  ClipRect(
                    child: Align(
                      alignment: Alignment.center,
                      widthFactor: 0.9,
                      child: Image.asset(
                        'assets/image/character/character_02_page_error_2.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    widthFactor: 0.9,
                    child: Image.asset(
                      'assets/image/character/character_02_page_error_3.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              "요청하신 페이지를 찾을 수 없어요".tr(),
              style: kTitle14BoldStyle.copyWith(color: kPreviousTextTitleColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "페이지를 찾을 수 없어요".tr(),
              style: kBody12RegularStyle.copyWith(color: kPreviousTextBodyColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPreviousPrimaryLightColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      context.pushReplacement("/home");
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        '홈으로 이동'.tr(),
                        style: kBody14BoldStyle.copyWith(
                          color: kPreviousPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
