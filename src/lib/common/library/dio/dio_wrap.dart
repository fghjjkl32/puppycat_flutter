import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/util/PackageInfo/package_info_util.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/config/routes.dart';
import 'package:pet_mobile_social_flutter/models/jwt/jwt_response_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/notification/new_notification_state_provider.dart';
import 'package:pet_mobile_social_flutter/services/jwt/jwt_service.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

final dioProvider = StateProvider<Dio>((ref) {
  // return DioWrap.getDioWithCookie();
  return DioWrap.getDioWithCookieWithRef(ref);
});

class DioWrap {
  static Dio dio = Dio();

  static const storage = FlutterSecureStorage();

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
          print('ref.read(userInfoProvider).userModel ${ref.read(userInfoProvider).userModel}');
          final userModel = ref.read(userInfoProvider).userModel;
          if (userModel != null) {
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

          final accessToken = await storage.read(key: 'ACCESS_TOKEN');
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
        if (code == 'ECOM-9999') {
          final accessToken = await storage.read(key: 'ACCESS_TOKEN');
          final refreshToken = await storage.read(key: 'REFRESH_TOKEN');

          ///NOTE
          ///refresh Token 검증 로직
          ///Access Token 재발행 시 사용

          var refreshDio = Dio();
          // JWTResponseModel jwtResponseModel = await refreshDio.post('$memberBaseUrl/v1/oauth/token', queryParameters: {
          JWTResponseModel jwtResponseModel = await JWTService(refreshDio, baseUrl: memberBaseUrl).getAccessToken({
            'refreshToken': refreshToken,
          });

          if (!jwtResponseModel.result) {
            if (jwtResponseModel.code == 'ERTE-9998') {
              ///TODO
              ///Refresh Token이 유효하지 않음
              ///유효하지 않으면 로그인 페이지 이동
              ///로그인 프로바이더 상태 초기화 필요
            }
          }

          if (jwtResponseModel.data == null) {
            APIException apiException = APIException(
              msg: jwtResponseModel.message ?? 'getAccessToken Data is null',
              code: jwtResponseModel.code ?? '400',
              refer: 'dio',
              caller: 'dio',
            );
            ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
          }

          final newAccessToken = jwtResponseModel.data!['accessToken'];
          await storage.write(key: 'ACCESS_TOKEN', value: newAccessToken);

          // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
          response.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          // 수행하지 못했던 API 요청 복사본 생성
          final clonedRequest = await dio.request(response.requestOptions.path,
              options: Options(method: response.requestOptions.method, headers: response.requestOptions.headers),
              data: response.requestOptions.data,
              queryParameters: response.requestOptions.queryParameters);

          // API 복사본으로 재요청
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
