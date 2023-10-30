import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:location/location.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/common/util/location/geolocator_util.dart';
import 'package:pet_mobile_social_flutter/common/util/walk_util.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/controller/walk_cache/walk_cache_controller.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
import 'package:pet_mobile_social_flutter/repositories/walk/walk_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  /// OPTIONAL, using custom notification channel id
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'puppycat_walk', // id
    '산책 현황', // title
    description: '', // description
    importance: Importance.low, // importance must be at low or higher level
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (Platform.isIOS || Platform.isAndroid) {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(),
        android: AndroidInitializationSettings('ic_bg_service_small'),
      ),
    );
  }

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will be executed when app is in foreground or background in separated isolate
      onStart: onBackgroundStart,

      // auto start service
      autoStart: false,
      isForegroundMode: true,

      notificationChannelId: 'puppycat_walk',
      initialNotificationTitle: '퍼피캣',
      initialNotificationContent: '우리 아이와 행복한 산책 중!',
      foregroundServiceNotificationId: 3333,

      ///TODO 다른 알림이랑 안겹치는 숫자 찾아서 수정
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: false,

      // this will be executed when app is in foreground in separated isolate
      onForeground: onBackgroundStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.reload();
  final log = preferences.getStringList('log') ?? <String>[];
  log.add(DateTime.now().toIso8601String());
  await preferences.setStringList('log', log);

  return true;
}

@pragma('vm:entry-point')
void onBackgroundStart(ServiceInstance service) async {
  // Only available for flutter 3.0.0 and later
  DartPluginRegistrant.ensureInitialized();

  // For flutter prior to version 3.0.0
  // We have to register the plugin manually

  String memberUuid = '';
  String walkUuid = '';
  CookieJar cookieJar = CookieJar();
  WalkStateModel? previousWalkStateModel;
  List<MyPetItemModel> selectedPetList = [];

  /// OPTIONAL when use custom notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    previousWalkStateModel = null;
    service.stopSelf();
  });

  service.on('setData').listen((event) {
    if (event == null) {
      print('setData background service event is empty.');
      return;
    }

    print('setData event $event');
    memberUuid = event['memberUuid'];
    walkUuid = event['walkUuid'];
    final Map<String, dynamic> cookieMap = event['cookieMap'];

    cookieMap.forEach((cookieName, cookieValue) {
      var cookie = Cookie(cookieName, cookieValue);
      cookieJar.saveFromResponse(Uri.parse(baseUrl), [cookie]);
    });

    List<dynamic> petMap = event['selectedPetList'];
    print('petMap $petMap / ${event['selectedPetList']}');
    selectedPetList = petMap.map((e) => MyPetItemModel.fromJson(e)).toList();
    // cookieJar.saveFromResponse(Uri.parse(baseUrl), cookies);
  });

  if (service is AndroidServiceInstance) {
    if (await service.isForegroundService()) {
      flutterLocalNotificationsPlugin.show(
        3333,
        '퍼피캣',
        '우리 아이와 행복한 산책 중!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'puppycat_walk',
            '산책 현황',
            icon: 'ic_bg_service_small',
            ongoing: true,
            // importance: Importance.high,
          ),
        ),
      );
    }
  }
  // bring to foreground
  Timer.periodic(const Duration(seconds: 1), (timer) async {
    print('timer.tick ${timer.tick}');
    /// you can see this log in logcat
    print('memberUuid $memberUuid / walkUuid $walkUuid');

    final location = await GeolocatorUtil.getCurrentLocation();
    print('location $location');

    // try {
    //   final walkRepository = WalkRepository(dio: DioWrap.getDioWithCookieForBackground(cookieJar));
    //   print('memberUuid $memberUuid / walkUuid $walkUuid');
    //
    //   var result = await walkRepository.getTodayWalkCount(memberUuid, false);
    //   print('walkCount $result');
    // } catch (e) {
    //   print('getTodayWalkCount error $e');
    // }

    previousWalkStateModel ??= WalkStateModel(
      dateTime: DateTime.now(),
      latitude: location.latitude,
      longitude: location.longitude,
      distance: 0,
      walkTime: 0,
      walkCount: 0,
      calorie: {},
    );

    LocationData currentLocationData = LocationData.fromMap({
      'latitude': location.latitude,
      'longitude': location.longitude,
    });

    final walkStateModel = WalkUtil.calcWalkStateValue(previousWalkStateModel!, currentLocationData, selectedPetList);
    previousWalkStateModel = walkStateModel;

    await WalkCacheController.writeWalkInfo(walkStateModel, walkUuid);


    print('timer.tick % 60 == 0 ${timer.tick % 60 == 0} / ${timer.tick % 60}');
    if(timer.tick % 20 == 0) {
      final walkInfoList = await WalkCacheController.readWalkInfo('${walkUuid}_local');
      final walkRepository = WalkRepository(dio: DioWrap.getDioWithCookieForBackground(cookieJar), baseUrl: 'https://walk-gps.pcstg.co.kr/');
      await walkRepository.sendWalkInfo(memberUuid, walkUuid, walkInfoList, false);
    }

    service.invoke(
      'walk_update',
      {
        'walkStateModel' : walkStateModel.toJson(),
      },
    );
  });
}

// Future sendWalkInfo(WalkStateModel walkInfo, CookieJar cookieJar, [bool isFinished = false]) async {
//   final walkRepository = WalkRepository(dio: DioWrap.getDioWithCookieForBackground(cookieJar), baseUrl: 'https://walk-gps.pcstg.co.kr/');
//
//   try {
//     if (_walkInfoList.length < 20 && !isFinished) {
//       print('_walkInfoList.length ${_walkInfoList.length}');
//       return;
//     }
//
//     final userInfo = ref.read(userInfoProvider).userModel;
//     print('userModel $userInfo');
//     final String memberUuid = ref.read(userInfoProvider).userModel!.uuid!;
//
//     await walkRepository.sendWalkInfo(memberUuid, _walkUuid, _walkInfoList, isFinished).then((value) => _walkInfoList.clear());
//   } catch (e) {
//     print('sendWalkInfo error $e');
//   }
// }
