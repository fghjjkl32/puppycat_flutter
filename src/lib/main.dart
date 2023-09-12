import 'dart:io';

import 'package:appspector/appspector.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_trigger_autocomplete/multi_trigger_autocomplete.dart';
import 'package:pet_mobile_social_flutter/common/util/PackageInfo/package_info_util.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';

import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/config/theme/theme_data.dart';
import 'package:pet_mobile_social_flutter/controller/chat/matrix_chat_controller.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_message_controller.dart';
import 'package:pet_mobile_social_flutter/controller/firebase/firebase_options.dart';
import 'package:pet_mobile_social_flutter/controller/notification/notification_controller.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_cloud_message_payload.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/setting/notice_list_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/push/push_payload_state_provider.dart';

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
  baseUrl = await Constants.getBaseUrl();
  thumborHostUrl = await Constants.getThumborHostUrl();
  thumborKey = await Constants.getThumborKey();
  imgDomain = await Constants.getThumborDomain();
  firstInstallTime = await Constants.checkFirstInstall();

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
  // if (!Platform.isIOS) {
  GetIt.I.registerSingleton<FireBaseMessageController>(FireBaseMessageController());
  // }
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

class PuppycatApp extends ConsumerStatefulWidget {
  const PuppycatApp({Key? key}) : super(key: key);

  @override
  PuppycatAppState createState() => PuppycatAppState();
}

class PuppycatAppState extends ConsumerState<PuppycatApp> {
  @override
  void initState() {
    initLocalNotification();
  }

  void initLocalNotification() {
    NotificationController notificationController = NotificationController();
    notificationController.initNotification(navigatorHandler);
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
        router.push("/home/myPage/detail/Contents/게시물/$loginMemberIdx/${payload.contentsIdx}/notificationContent");
        break;

      case PushType.new_comment:
      case PushType.new_reply:
      case PushType.mention_comment:
      case PushType.like_comment:
        var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;
        router.push("/home/myPage/detail/nickname/게시물/$loginMemberIdx/${payload.contentsIdx}/notificationContent", extra: {
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
            builder: (context, widget) {
              return ScrollConfiguration(behavior: ScrollBehaviorModified(), child: widget!);
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
