import 'package:permission_handler/permission_handler.dart';

class Permissions {
  // static Future<void> requestNotificationPermission() async {
  //   final curStatus = await getNotificationPermission();
  //   if (!curStatus.isGranted) {
  //     await Permission.notification.request();
  //   }
  // }

  static Future<PermissionStatus> requestNotificationPermission() async {
    return await Permission.notification.request();
  }

  static Future<bool> getNotificationPermissionState() async {
    return await requestNotificationPermission().isGranted ? true : false;
  }

  static Future<PermissionStatus> requestLocationPermission() async {
    return await Permission.locationAlways.request();
  }

  static Future<bool> getLocationPermissionState() async {
    return await requestLocationPermission().isGranted ? true : false;
  }

  static Future<PermissionStatus> requestCameraPermission() async {
    return await Permission.camera.request();
  }

  static Future<bool> getCameraPermissionState() async {
    return await requestCameraPermission().isGranted ? true : false;
  }

  static Future<PermissionStatus> requestPhotosPermission() async {
    return await Permission.photos.request();
  }

  static Future<bool> getPhotosPermissionState() async {
    return await requestPhotosPermission().isGranted ? true : false;
  }

  //
  // static Future<PermissionStatus> requestSensorsPermission() async {
  //   return await Permission.sensors.request();
  // }
  //
  // static Future<bool> getSensorPermissionState() async {
  //   return await requestSensorsPermission().isGranted ? true : false;
  // }

  static Future<PermissionStatus> requestActivityRecognitionPermission() async {
    return await Permission.activityRecognition.request();
  }

  static Future<bool> getActivityRecognitionPermissionState() async {
    return await requestActivityRecognitionPermission().isGranted ? true : false;
  }

  // static Future<void> requestPermissions() async {
  //   Map<Permission, PermissionStatus> statuses = await [
  //     Permission.location,
  //     Permission.phone,
  //     Permission.notification,
  //     Permission.activityRecognition,
  //   ].request();
  // }

  // static Future<void> requestNotificationPermission() async {
  //   final curStatus = await getNotificationPermission();
  //   if (!curStatus.isGranted) {
  //     final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //     if(prefs.getBool('noti_permit_user_denied') == null) {
  //       final status = await Permission.notification.request();
  //       if (status.isDenied) {
  //         await prefs.setBool('noti_permit_user_denied', true);
  //       }
  //     }
  //   }
  //
  // }

  // static Future<PermissionStatus> getNotificationPermission() async {
  //   return await Permission.notification.status;
  // }

  static Future<bool> openPermissionSetting() async {
    return await openAppSettings();
  }
}
