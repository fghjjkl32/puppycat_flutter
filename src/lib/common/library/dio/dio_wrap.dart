import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/util/PackageInfo/package_info_util.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/notification/new_notification_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/notification/notification_service.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

final dioProvider = StateProvider<Dio>((ref) {
  // return DioWrap.getDioWithCookie();
  return DioWrap.getDioWithCookieWithRef(ref);
});

class DioWrap {
  static Dio dio = Dio();

  static Dio getDioWithCookie() {
    // final dio = Dio();

    if (dio.interceptors.whereType<CookieManager>().isEmpty) {
      CookieJar cookieJar = GetIt.I<CookieJar>();
      dio.interceptors.add(CookieManager(cookieJar));
      dio.interceptors.add(QueuedInterceptorsWrapper());
    }

    ///TODO
    /// 좀 더 고도화 필요
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 3,
      retryDelays: const [
        // set delays between retries (optional)
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
      ],
    ));

    return dio;
  }

  static Dio getDioWithCookieForBackground(CookieJar cookieJar) {
    // final dio = Dio();
    dio.interceptors.add(LogInterceptor(responseBody: true));

    if (dio.interceptors.whereType<CookieManager>().isEmpty) {
      // CookieJar cookieJar = GetIt.I<CookieJar>();
      dio.interceptors.add(CookieManager(cookieJar));
      dio.interceptors.add(QueuedInterceptorsWrapper());
    }

    ///TODO
    /// 좀 더 고도화 필요
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 3,
      retryDelays: const [
        // set delays between retries (optional)
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
      ],
    ));

    return dio;
  }

  static Dio getDioWithCookieWithRef(Ref ref) {
    // final dio = Dio();
    if (dio.interceptors.whereType<CookieManager>().isEmpty) {
      CookieJar cookieJar = GetIt.I<CookieJar>();
      dio.interceptors.add(CookieManager(cookieJar));
      dio.interceptors.add(QueuedInterceptorsWrapper());
    }

    ///TODO
    /// 좀 더 고도화 필요
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 3,
      retryDelays: const [
        // set delays between retries (optional)
        Duration(seconds: 1), // wait 1 sec before first retry
        Duration(seconds: 2), // wait 2 sec before second retry
        Duration(seconds: 3), // wait 3 sec before third retry
      ],
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // This is where you call your specific API
          try {
            print('ref.read(userInfoProvider).userModel ${ref.read(userInfoProvider).userModel}');
            final userModel = ref.read(userInfoProvider).userModel;
            if (userModel != null) {
              if (userModel.idx != 0) {
                ref.read(newNotificationStateProvider.notifier).checkNewNotifications();
              }
            }

            //Add user agent
            options.headers.addAll(await userAgentClientHintsHeader());

            //add referrer
            //TODO
            options.headers['referrer'] = ref.read(routerProvider).routeInformationProvider.value.location;

            PackageInformationUtil pkgInfo = GetIt.I.get<PackageInformationUtil>();
            // Map<String, dynamic> appInfo = {
            //   'uid' : await GetIt.I.get<UuidUtil>().getUUID(),
            //   'name' : pkgInfo.pkgName,
            //   'version' : pkgInfo.appVersion,
            //   'build' : pkgInfo.appBuildNumber,
            // };

            String uuid = await GetIt.I.get<UuidUtil>().getUUID();
            String appInfo = 'uid=$uuid&name=${pkgInfo.pkgName}&version=${pkgInfo.appVersion}&build=${pkgInfo.appBuildNumber}';

            options.headers['App-Info'] = appInfo;

            print('options.headers ${options.headers}');

            return handler.next(options);
          } catch (e) {
            print('noti error $e');
            // Handle the error accordingly
            // return handler.reject(DioError(
            //   requestOptions: options,
            //   error: 'Failed to call the specific API.',
            // ));
            return handler.next(options);
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          print('dio onerror : ${error.toString()}');
          return handler.reject(error);
        }
      ),
    );

    return dio;
  }
}
