import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';

final pathSeparator = Util.isWeb ? "/" : Platform.pathSeparator;

class Util {
  static final FToast _toast = FToast();

  static const String urlRegex = r"[-a-zA-Z0-9@:%_\+.~#?&//=]{2,256}\.[a-z]{2,4}\b(\/[-a-zA-Z0-9@:%_\+.~#?&//=]*)?";
  static const String _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static final Random _rnd = Random();

  static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static void showSnackBar(BuildContext context, String text) {
    final snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 2), //default is 4s
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static bool get isWeb => kIsWeb;

  /// android / ios = 모바일
  static bool get isMobile => !Util.isWeb && (Platform.isAndroid || Platform.isIOS);

  static bool get isAndroid => !Util.isWeb && Platform.isAndroid;

  static bool get isIOS => !Util.isWeb && Platform.isIOS;

  static bool get isMacOS => !Util.isWeb && Platform.isMacOS;

  static bool get isWindows => !Util.isWeb && Platform.isWindows;

  static Future<bool> openLink(String url) async {
    var uri = Uri.parse(url);
    var regex = RegExp(urlRegex);
    try {
      if (regex.hasMatch(url) && !url.contains(":")) {
        uri = Uri.parse("https://$url");
        return launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        return launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // logger.e("링크를 열 수 없습니다.. ${uri.toString()}");
      return false;
    }
  }

  static String getSizedText(int fileSize) {
    if (fileSize > 1024 * 1024) {
      return "${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB";
    } else {
      return "${(fileSize / 1024).toStringAsFixed(2)}KB";
    }
  }

  static RegExpMatch? getFirstUrl(dynamic message) {
    return RegExp(urlRegex).firstMatch(message);
  }

  static String getCurrentDate(DateTime messageDt) {
    return intl.DateFormat("aa hh:mm", 'ko').format(messageDt);
  }
}

class DateUtil {
  DateTime currentTime = DateTime.now().toUtc().add(const Duration(hours: 9));
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;
  int? week;

  DateUtil() {
    year = currentTime.year;
    month = currentTime.month;
    day = currentTime.day;
    hour = currentTime.hour;
    minute = currentTime.minute;
    second = currentTime.second;
    week = DateUtil().getWeek(currentTime.weekday);
  }

  getWeek(int week) {
    switch (week) {
      case 0:
        return '월요일';
      case 1:
        return '화요일';
      case 2:
        return '수요일';
      case 3:
        return '목요일';
      case 4:
        return '금요일';
      case 5:
        return '토요일';
      case 6:
        return '일요일';
    }
  }

  setYYYYMMDDhhmmssToDate(String yyyyMMddHHmmss) {
    DateTime dateTime = DateTime.parse('${yyyyMMddHHmmss.substring(0, 8)}T${yyyyMMddHHmmss.substring(8)}');
    year = dateTime.year;
    month = dateTime.month;
    day = dateTime.day;
    hour = dateTime.hour;
    minute = dateTime.minute;
    second = dateTime.second;
  }

  getChattingRoomTopDate() {
    return '$year년 $month월 $day일 $week';
  }
}
