import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_cloud_message_payload.dart';

class NotificationController {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;

  get pushController => flutterLocalNotificationsPlugin;

  NotificationController() {
    // initNotification();
  }

  void initNotification(Function pushHandler) async {
    print("pushHandler : ${pushHandler}");
    print("pushHandler : pushHandler : pushHandler : pushHandler : ");

    // flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // NotificationAppLaunchDetails? details = await NotificationController().pushController.getNotificationAppLaunchDetails();
    // if (details != null) {
    //   if (details.didNotificationLaunchApp) {
    //     if (details.notificationResponse != null) {
    //       if (details.notificationResponse!.payload != null) {
    //         FirebaseCloudMessagePayload payload = FirebaseCloudMessagePayload.fromJson(jsonDecode(details.notificationResponse!.payload!));
    //         // navigatorHandler(context, convertStringToPushType(payload.type), payload);
    //         pushHandler(payload);
    //       }
    //     }
    //   }
    // }

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/launch_background'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) {
        print("responseresponse ${response}");

        try {
          if (response.payload != null) {
            print('response.payload ${response.payload}');
            FirebaseCloudMessagePayload payload = FirebaseCloudMessagePayload.fromJson(jsonDecode(response.payload!));
            // context.go('/home/notification');
            print('onDidReceiveNotificationResponse 1 $payload');
            pushHandler(payload);

            // navigatorHandler(context, convertStringToPushType(payload.type), payload);
          } else {
            print('onDidReceiveNotificationResponse 2 $response');
          }
        } catch (e) {
          print('onDidReceiveNotificationResponse 3 $e');
        }
      },
    );
    // onDidReceiveBackgroundNotificationResponse: _onDidReceiveBackgroundNotificationResponse);
  }

  void createChannel(
    String id,
    String title,
    String desc,
  ) async {
    channel = AndroidNotificationChannel(
      id, // id
      title, // title
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
  }

  Future showFlutterDataPush(RemoteMessage message) async {
    FirebaseCloudMessagePayload? payload = FirebaseCloudMessagePayload.fromJson(message.data);
    // AndroidNotification? android = message.notification?.android;
    if (payload == null || kIsWeb) {
      return;
    }

    print('payload $payload');
    String body = "${payload.body}_${payload.contentsIdx}";
    int contentId = createNotificationId(payload);

    await checkExistNotification(contentId.toString()).then((value) {
      body = '${payload.body}${getBodyString(convertStringToPushType(payload.type), value)}';
    });

    String largeIconPath = '';
    BigPictureStyleInformation? bigPictureStyleInformation;
    if (payload.image != null && payload.image.isNotEmpty) {
      String imgUrl = payload.image!;
      largeIconPath = await downloadAndSaveImageTemporarily(imgUrl, 'largeIcon');
      final String bigPicturePath = await downloadAndSaveImageTemporarily(imgUrl, 'bigPicture');

      bigPictureStyleInformation = BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
          largeIcon: FilePathAndroidBitmap(largeIconPath), contentTitle: payload.title, htmlFormatContentTitle: true, summaryText: body, htmlFormatSummaryText: true);
    }

    flutterLocalNotificationsPlugin.show(
      contentId,
      payload.title,
      body,
      NotificationDetails(
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'mipmap/launcher_icon',
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          styleInformation: bigPictureStyleInformation,
        ),
      ),
      payload: jsonEncode(payload.toJson()),
    );
  }

  Future<bool> checkExistNotification(String id) async {
    final activeNotiList = await flutterLocalNotificationsPlugin.getActiveNotifications();
    bool isActived = false;

    for (final activeNoti in activeNotiList) {
      if (activeNoti.id.toString() == id) {
        isActived = true;
        break;
      }
    }

    return isActived;
  }

  Future<String> downloadAndSaveImageTemporarily(String url, String fileName) async {
    // var response = await http.get(Uri.parse(url));
    final Dio dio = Dio();
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    var response = await dio.download(url, filePath);
    //
    // File file = File(filePath);
    // await file.writeAsBytes(response.data);

    return filePath;
  }

  int createNotificationId(FirebaseCloudMessagePayload payload) {
    if (payload.type == describeEnum(PushType.follow)) {
      return 0;
    }

    int typeIndex = PushType.values.indexWhere((element) => payload.type == describeEnum(element));
    int contentsIdx = int.parse(payload.contentsIdx);
    int commentIdx = int.parse(payload.commentIdx ?? "0");
    String idx = "$typeIndex$contentsIdx$commentIdx";
    print('idx $idx');
    return int.parse(idx);
  }

  String getBodyString(PushType pushType, bool isMultiple) {
    switch (pushType) {
      case PushType.follow:
        if (isMultiple) {
          return '푸시.팔로우멀티'.tr();
        } else {
          return '푸시.팔로우멀티'.tr();
        }
      case PushType.new_contents:
        return '푸시.팔로우새글'.tr();
      case PushType.metion_contents:
        return '푸시.피드멘션'.tr();
      case PushType.img_tag:
        return '푸시.피드태그'.tr();
      case PushType.like_contents:
        if (isMultiple) {
          return '푸시.피드좋아요멀티'.tr();
        } else {
          return '푸시.피드좋아요싱글'.tr();
        }
      case PushType.new_comment:
      case PushType.new_reply:
        if (isMultiple) {
          return '푸시.댓글멀티'.tr();
        } else {
          return '푸시.댓글싱글'.tr();
        }
      case PushType.mention_comment:
        return '푸시.댓글멘션'.tr();
      case PushType.like_comment:
        if (isMultiple) {
          return '푸시.댓글좋아요멀티'.tr();
        } else {
          return '푸시.댓글좋아요싱글'.tr();
        }
      case PushType.notice:
      case PushType.event:
      case PushType.unknown:
        return '';
    }
  }

  PushType convertStringToPushType(String type) {
    PushType pushType = PushType.values.firstWhere((element) => type == describeEnum(element), orElse: () => PushType.unknown);
    return pushType;
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
}
