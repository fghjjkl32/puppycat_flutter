import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<void> requestNotificationPermission() async {
    final curStatus = await getNotificationPermission();
    if (!curStatus.isGranted) {
      await Permission.notification.request();
    }
  }

  static Future<void> requestPhonePermission() async {
      await Permission.phone.request();
  }

  static Future<void> requestLocationPermission() async {
    await Permission.locationWhenInUse.request();
  }

  static Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.phone,
      Permission.notification,
    ].request();
  }

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

  static Future<PermissionStatus> getNotificationPermission() async {
    return await Permission.notification.status;
  }

  static Future<bool> checkNotificationPermission() async {
    return await getNotificationPermission().isGranted ? true : false;
  }

  static Future<bool> openPermissionSetting() async {
    return await openAppSettings();
  }
}
