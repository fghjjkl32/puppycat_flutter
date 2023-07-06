
import 'dart:io';

import 'package:flutter/services.dart';

class ChannelController {
  static const platform = MethodChannel('puppycat-ch');

  static Future<String> getAppUrl(String url) async {
    if (Platform.isAndroid) {
      return await platform
          .invokeMethod('getAppUrl', <String, Object>{'url': url});
    } else {
      return url;
    }
  }

  static Future<String> getMarketUrl(String url) async {
    if (Platform.isAndroid) {
      return await platform
          .invokeMethod('getMarketUrl', <String, Object>{'url': url});
    } else {
      return url;
    }
  }
}

