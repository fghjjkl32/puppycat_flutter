import 'dart:async';

import 'package:appspector/appspector.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
// import 'package:location/location.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/common/util/PackageInfo/package_info_util.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/config/theme/color_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/puppycat_social_icons.dart';
import 'package:pet_mobile_social_flutter/config/theme/text_data.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_message_controller.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_options.dart';
import 'package:pet_mobile_social_flutter/controller/notification/notification_controller.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_cloud_message_payload.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/notice_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';

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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // await LocationUtil.checkLocationPermission();
  // Location().changeSettings(interval: 500);

  //TODO 11/8 Permission 작업때문에 주석 위치 가져오는 권한을 산책하기 할때로 이동
  // await GeolocatorUtil.checkLocationPermission();

  ///NOTE
  ///2023.11.14.
  ///산책하기 보류로 주석 처리
  // await NaverMapSdk.instance.initialize(clientId: "omfrw8eeol");
  // await initializeBackgroundService();
  ///산책하기 보류로 주석 처리 완료

  /// Get It
  /// SingleTon
  // if (!Platform.isIOS) {
  GetIt.I.registerSingleton<FireBaseMessageController>(FireBaseMessageController());
  // }
  GetIt.I.registerSingleton<UuidUtil>(UuidUtil());
  await GetIt.I<UuidUtil>().init();

  GetIt.I.registerSingleton<PackageInformationUtil>(PackageInformationUtil());
  await GetIt.I<PackageInformationUtil>().init();

  // print('pkg name ${GetIt.I<PackageInformationUtil>().pkgName}');

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
    initLocalNotification();
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

  void initLocalNotification() {
    NotificationController notificationController = NotificationController();
    notificationController.initNotification(navigatorHandler);
    //
    //
    // getInitialLink().then((link) {
    //   // if (!isAppLinkHandled && link == "puppycat://auth?authtype=toss") {
    //   //   isAppLinkHandled = true;
    //   //   final router = ref.watch(routerProvider);
    //   //   router.push("/loginScreen/signupScreen/toss");
    //   // }
    // });
    //
    // linkStream.listen((String? link) {
    //   if (!isAppLinkHandled && link == "puppycat://auth?authtype=toss") {
    //     isAppLinkHandled = true;
    //     final router = ref.watch(routerProvider);
    //     router.push("/loginScreen/signupScreen/toss");
    //   }
    // }, onError: (err) {
    //   // Handle the error here
    // });
  }

  void navigatorHandler(FirebaseCloudMessagePayload payload) {
    print("payload ::: ${payload}");
    // context.push('/home/notification');
    final router = ref.watch(routerProvider);
    final myInfo = ref.read(myInfoStateProvider);
    // router.go('/home/notification');

    PushType pushType = PushType.values.firstWhere((element) => payload.type == describeEnum(element), orElse: () => PushType.unknown);

    print("pushType : ${pushType}");

    switch (pushType) {
      case PushType.follow:
        router.go('/home/notification');
        break;
      case PushType.new_contents:
      case PushType.metion_contents:
      case PushType.like_contents:
      case PushType.img_tag:
        Map<String, dynamic> extraMap = {
          'firstTitle': myInfo.nick ?? 'nickname',
          'secondTitle': '피드',
          'memberUuid': myInfo.uuid,
          'contentIdx': payload.contentsIdx,
          'contentType': 'notificationContent',
        };
        router.push('/home/myPage/detail', extra: extraMap);
        // router.push("/home/myPage/detail/Contents/피드/${myInfo.uuid}/${payload.contentsIdx}/notificationContent");
        break;

      case PushType.new_comment:
      case PushType.new_reply:
      case PushType.mention_comment:
      case PushType.like_comment:
        Map<String, dynamic> extraMap = {
          "isRouteComment": true,
          "focusIdx": payload.commentIdx,
          'firstTitle': myInfo.nick ?? 'nickname',
          'secondTitle': '피드',
          'memberUuid': myInfo.uuid,
          'contentIdx': payload.contentsIdx,
          'contentType': 'notificationContent',
        };
        router.push('/home/myPage/detail', extra: extraMap);
        // router.push("/home/myPage/detail/nickname/피드/${myInfo.uuid}/${payload.contentsIdx}/notificationContent", extra: {
        //   "isRouteComment": true,
        //   "focusIdx": payload.commentIdx,
        // });
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

  // void navigatorHandler(BuildContext context, PushType pushType, FirebaseCloudMessagePayload payload) {
  //   switch (pushType) {
  //     case PushType.follow:
  //       print('adsasdadads');
  //       context.go('/home/notification');
  //     case PushType.new_contents:
  //     case PushType.metion_contents:
  //     case PushType.img_tag:
  //     case PushType.like_contents:
  //
  //     case PushType.new_comment:
  //     case PushType.new_reply:
  //
  //     case PushType.mention_comment:
  //     case PushType.like_comment:
  //       print('adsasdadads22222');
  //       context.go('/home/notification');
  //     case PushType.notice:
  //     case PushType.event:
  //     case PushType.unknown:
  //       return ;
  //   }
  // }

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
              "요청하신 페이지를 찾을 수 없어요.",
              style: kTitle14BoldStyle.copyWith(color: kPreviousTextTitleColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "입력한 주소가 잘못되었거나\n페이지를 찾을 수 없어요.",
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
                        '홈으로 이동',
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
