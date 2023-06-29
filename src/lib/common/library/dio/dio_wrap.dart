
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

class DioWrap {
  static Dio dio = Dio();

  static Dio getDioWithCookie() {
    // final dio = Dio();
    CookieJar cookieJar = GetIt.I<CookieJar>();
    dio.interceptors.add(CookieManager(cookieJar!));
    return dio;
  }
}