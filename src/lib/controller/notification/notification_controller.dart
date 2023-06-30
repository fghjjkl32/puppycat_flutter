import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pet_mobile_social_flutter/models/firebase/firebase_cloud_message_payload.dart';
import 'package:path_provider/path_provider.dart';

class NotificationController {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;

  get pushController => flutterLocalNotificationsPlugin;

  NotificationController() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
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

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }


  Future showFlutterDataPush(RemoteMessage message) async {
    FirebaseCloudMessagePayload? payload = FirebaseCloudMessagePayload.fromJson(message.data);
    // AndroidNotification? android = message.notification?.android;
    if (payload != null && !kIsWeb) {
      String body = "${payload.body}_${payload.content_id}";
      int contentId = 0;

      if (payload.content_id != null) {
        contentId = int.parse(payload.content_id!);
      }

      await checkExistNotification(contentId.toString()).then((value) {
        if (value) {
          body = "${payload.body}님 외 다수가 좋아요를 눌렀습니다.";
        } else {
          body = "${payload.body}님이 좋아요를 눌렀습니다.";
        }
      });


      String largeIconPath = '';
      late BigPictureStyleInformation? bigPictureStyleInformation;
      if(payload.image != null) {
        String imgUrl = payload.image!;
        largeIconPath = await downloadAndSaveImageTemporarily(
            imgUrl, 'largeIcon');
        final String bigPicturePath = await downloadAndSaveImageTemporarily(
            imgUrl, 'bigPicture');

        bigPictureStyleInformation =
            BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
                largeIcon: FilePathAndroidBitmap(largeIconPath),
                contentTitle: payload.title,
                htmlFormatContentTitle: true,
                summaryText: body,
                htmlFormatSummaryText: true);
      }


      flutterLocalNotificationsPlugin.show(
        contentId,
        payload.title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
            largeIcon: FilePathAndroidBitmap(largeIconPath),
            styleInformation: bigPictureStyleInformation,
          ),
        ),
      );
    }
  }

  Future<bool> checkExistNotification(String id) async {
    final activeNotiList = await flutterLocalNotificationsPlugin.getActiveNotifications();
    bool isActived = false;

    for(final activeNoti in activeNotiList) {
      if(activeNoti.id.toString() == id) {
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
}
