import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_cloud_message_payload.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await EasyLocalization.ensureInitialized();
  // final controller = EasyLocalizationController(
  //   saveLocale: true,
  //   fallbackLocale: const Locale('ko', 'KR'),
  //   supportedLocales: const [
  //     Locale('ko', 'KR'),
  //   ],
  //   assetLoader: const RootBundleAssetLoader(),
  //   useOnlyLangCode: false,
  //   useFallbackTranslations: true,
  //   path: 'assets/translations',
  //   onLoadError: (FlutterError e) {},
  // );
  //
  // //Load translations from assets
  // await controller.loadTranslations();
  //
  // //load translations into exploitable data, kept in memory
  // Localization.load(controller.locale, translations: controller.translations, fallbackTranslations: controller.fallbackTranslations);
  //
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // NotificationController notificationController = NotificationController();
  // print("run1  ${message.toMap()}");
  // // _setupNotificationChannel();
  // notificationController.createChannel('puppycat', 'Puppycat Notification', '');
  // // notificationController.showFlutterNotification(message);
  // notificationController.showFlutterDataPush(message);
}

class FireBaseMessageController {
  // late NotificationController notificationController;
  late String? _fcmToken;

  String? get fcmToken => _fcmToken;

  FirebaseCloudMessagePayload? _initData;

  FirebaseCloudMessagePayload? get initData => _initData;

  Future init() async {
    // await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );

    final data = await FirebaseMessaging.instance.getInitialMessage();
    if (data != null) {
      print('init noti data ${data.toMap()}');
      if (data.data.isNotEmpty) {
        debugPrint('data : ${data.data}');
        _initData = FirebaseCloudMessagePayload.fromJson(data.data);
      }
    }

    // Permissions.requestNotificationPermission();
    // notificationController = NotificationController();
    // _setupNotificationChannel();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp $message');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage ${message.toMap().toString()}');
    });
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('onMessageOpenedApp $message');
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print('onMessage ${message.toMap().toString()}');
    // });

    // await FirebaseMessaging.instance.subscribeToTopic("topic_test");

    _fcmToken = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      /// TODO smkang
      /// 백단에 변경된 token 알려주기
      _fcmToken = fcmToken;
    }).onError((err) {
      // Error getting token.
      debugPrint('token refresh error');
    });

    debugPrint('token : $_fcmToken');
    // debugPrint('advertisingID : ${await AdvertisingID.getAdvertisingID()}');
  }

  void setBackgroundMessageOnTapHandler(Function(FirebaseCloudMessagePayload payload) handler) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        Map<String, dynamic> notificationMap = message.notification!.toMap();
        if (message.data.isNotEmpty) {
          notificationMap.addAll(message.data);
        }
        notificationMap['imageUrl'] = message.notification?.android?.imageUrl ?? message.notification?.apple?.imageUrl;
        print(notificationMap);
        handler(FirebaseCloudMessagePayload.fromJson(notificationMap));
      }
    });
  }

  void setForegroundMessageOnTapHandler(Function(FirebaseCloudMessagePayload payload) handler) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        handler(FirebaseCloudMessagePayload.fromJson(message.data));
      }
    });
  }

// void navigatorHandler(Ref ref, FirebaseCloudMessagePayload payload) {
//   print("payload ::: ${payload}");
//   // context.push('/notification');
//   final router = ref.read(routerProvider);
//   final myInfo = ref.read(myInfoStateProvider);
//   // router.go('/notification');
//
//   PushType pushType = PushType.values.firstWhere((element) => payload.type == describeEnum(element), orElse: () => PushType.unknown);
//
//   print("pushType : ${pushType}");
//
//   switch (pushType) {
//     case PushType.follow:
//       router.push('/notification');
//       break;
//     case PushType.new_contents:
//     case PushType.metion_contents:
//     case PushType.like_contents:
//     case PushType.img_tag:
//       Map<String, dynamic> extraMap = {
//         'firstTitle': myInfo.nick ?? 'nickname',
//         'secondTitle': '피드',
//         'memberUuid': myInfo.uuid,
//         'contentIdx': payload.contentsIdx,
//         'contentType': 'notificationContent',
//       };
//       router.push('/feed/detail', extra: extraMap);
//       // router.push("/feed/detail/Contents/피드/${myInfo.uuid}/${payload.contentsIdx}/notificationContent");
//       break;
//
//     case PushType.new_comment:
//     case PushType.new_reply:
//     case PushType.mention_comment:
//     case PushType.like_comment:
//       Map<String, dynamic> extraMap = {
//         "isRouteComment": true,
//         "focusIdx": payload.commentIdx,
//         'firstTitle': myInfo.nick ?? 'nickname',
//         'secondTitle': '피드',
//         'memberUuid': myInfo.uuid,
//         'contentIdx': payload.contentsIdx,
//         'contentType': 'notificationContent',
//       };
//       router.push('/feed/detail', extra: extraMap);
//       // router.push("/feed/detail/nickname/피드/${myInfo.uuid}/${payload.contentsIdx}/notificationContent", extra: {
//       //   "isRouteComment": true,
//       //   "focusIdx": payload.commentIdx,
//       // });
//       break;
//
//     case PushType.notice:
//     case PushType.event:
//       ref.read(noticeFocusIdxStateProvider.notifier).state = int.parse(payload.contentsIdx);
//       ref.read(noticeExpansionIdxStateProvider.notifier).state = int.parse(payload.contentsIdx);
//       router.push("/setting/notice", extra: {
//         "contentsIdx": payload.contentsIdx,
//       });
//       break;
//     case PushType.unknown:
//       return;
//   }
// }

// void _setupNotificationChannel() {
//   notificationController.createChannel('puppycat', 'Puppycat Notification', '');
// }
}
