import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/notification/new_notification_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/notification/notification_service.dart';


final dioProvider = StateProvider<Dio>((ref) {
  return DioWrap.getDioWithCookie2(ref);
});

class DioWrap {
  static Dio dio = Dio();

  static Dio getDioWithCookie() {
    // final dio = Dio();
    CookieJar cookieJar = GetIt.I<CookieJar>();
    if (dio.interceptors.whereType<CookieManager>().isEmpty) {
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
            print('path ${options.path}');
            final notificationService = NotificationService(dio);
            final response = await notificationService.checkNewNotifications(1);
            ResponseModel resModel = response as ResponseModel;
            if (resModel.result) {
              print('no new noti');
            } else {
              print('exist new noti');
            }
            // Maybe you want to modify the options based on the result of the specific API?
            // For example, setting a header:
            // options.headers['Your-Header-Name'] = response.data['someValue'];

            // Continue with the request
            return handler.next(options);
          } catch (e) {
            // Handle the error accordingly
            // return handler.reject(DioError(
            //   requestOptions: options,
            //   error: 'Failed to call the specific API.',
            // ));
            return handler.next(options);
          }
          return handler.next(options);
        },
      ),
    );

    return dio;
  }
  static Dio getDioWithCookie2(Ref ref) {
    // final dio = Dio();
    CookieJar cookieJar = GetIt.I<CookieJar>();
    if (dio.interceptors.whereType<CookieManager>().isEmpty) {
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
            if(ref.read(userInfoProvider).userModel != null) {
              ref.read(newNotificationStateProvider.notifier).checkNewNotifications();
            }
            // Maybe you want to modify the options based on the result of the specific API?
            // For example, setting a header:
            // options.headers['Your-Header-Name'] = response.data['someValue'];

            // Continue with the request
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
      ),
    );

    return dio;
  }
}
