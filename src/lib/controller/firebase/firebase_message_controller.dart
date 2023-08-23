import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pet_mobile_social_flutter/controller/notification/notification_controller.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_cloud_message_payload.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationController notificationController = NotificationController();
  print("run1  $message");
  // _setupNotificationChannel();
  notificationController.createChannel('puppycat', 'Puppycat Notification', '');
  // notificationController.showFlutterNotification(message);
  notificationController.showFlutterDataPush(message);
}

class FireBaseMessageController {
  late NotificationController notificationController;
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
      if (data.data.isNotEmpty) {
        debugPrint('data : ${data.data}');
        _initData = FirebaseCloudMessagePayload.fromJson(data.data);
      }
    }

    // Permissions.requestNotificationPermission();
    notificationController = NotificationController();
    _setupNotificationChannel();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp $message');
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('onMessage $message');
    });

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
      if (message.data.isNotEmpty) {
        handler(FirebaseCloudMessagePayload.fromJson(message.data));
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

  void _setupNotificationChannel() {
    notificationController.createChannel('puppycat', 'Puppycat Notification', '');
  }
}
