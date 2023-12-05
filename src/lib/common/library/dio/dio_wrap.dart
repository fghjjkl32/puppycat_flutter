import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/util/PackageInfo/package_info_util.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/controller/token/token_controller.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/notification/new_notification_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/jwt/jwt_repository.dart';
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
      InterceptorsWrapper(onRequest: (options, handler) async {
        // This is where you call your specific API
        try {
          final isLogined = ref.read(loginStatementProvider);
          if (isLogined) {
            ref.read(newNotificationStateProvider.notifier).checkNewNotifications();
          }
        } catch (e) {
          print('New Noti API Error $e');
        }

        try {
          //Add user agent
          options.headers.addAll(await userAgentClientHintsHeader());
          //add referrer
          //TODO
          options.headers['referrer'] = ref.read(routerProvider).routeInformationProvider.value.location;
          PackageInformationUtil pkgInfo = GetIt.I.get<PackageInformationUtil>();
          String uuid = await GetIt.I.get<UuidUtil>().getUUID();
          String appInfo = 'uid=$uuid&name=${pkgInfo.pkgName}&version=${pkgInfo.appVersion}&build=${pkgInfo.appBuildNumber}';
          options.headers['App-Info'] = appInfo;

          final accessToken = await TokenController.readAccessToken();
          options.headers['Authorization'] = 'Bearer $accessToken';

          return handler.next(options);
        } catch (e) {
          print('API Request Error $e');
          return handler.next(options);
        }
        return handler.next(options);
      }, onResponse: (response, handler) async {
        print('onResponse dio response : ${response.toString()}');

        Map<String, dynamic> resMap = response.data;

        bool isResult = true;
        if (resMap.containsKey('result')) {
          isResult = resMap['result'];
        }

        String code = '1000';
        if (!isResult) {
          if (resMap.containsKey('code')) {
            code = resMap['code'];
          }
        }

        //Access Token이 유효하지 않을 때
        if (code == 'ERTE-9999') {
          final refreshToken = await TokenController.readRefreshToken();

          var refreshDio = Dio();
          try {
            JWTRepository jwtRepository = JWTRepository(dio: refreshDio);
            final newAccessToken = await jwtRepository.getAccessToken(refreshToken);
            await TokenController.writeAccessToken(newAccessToken);
            response.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          } on APIException catch (apiException) {
            ///getAccessToken 응답으로 받을 수 있는 오류라면  ECOM-9999 밖에 없음
            ///즉, Refresh Token이 유효하지 않을 때뿐
            ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
          } catch (e) {
            print('dio - getAccessToken error $e');
          }

          // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신

          // 수행하지 못했던 API 요청 복사본 생성
          final clonedRequest = await dio.fetch(response.requestOptions);
          return handler.resolve(clonedRequest);
          // return handler.next(response);
        }

        return handler.next(response);
      }, onError: (error, handler) {
        print('dio onerror : ${error.toString()}');
        int? errorCode = error.response?.statusCode;
        APIException apiException = APIException(msg: error.toString(), code: errorCode.toString() ?? '400', refer: 'dio', caller: 'dio');
        ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
        return handler.reject(error);
      }),
    );

    return dio;
  }
}
