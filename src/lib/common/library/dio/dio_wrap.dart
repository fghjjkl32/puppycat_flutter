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
import 'package:pet_mobile_social_flutter/repositories/jwt/jwt_repository.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

final dioProvider = StateProvider<Dio>((ref) {
  // return DioWrap.getDioWithCookie();
  return DioWrap.getDioWithCookieWithRef(ref);
});

class DioWrap {
  static Dio dio = Dio();

  // static bool _isAccessTokenReissue = false;

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
      // dio.interceptors.add(QueuedInterceptorsWrapper());
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
      // dio.interceptors.add(QueuedInterceptorsWrapper());
    }

    // ///TODO
    // /// 좀 더 고도화 필요
    // dio.interceptors.add(RetryInterceptor(
    //   dio: dio,
    //   logPrint: print,
    //   retries: 3,
    //   retryDelays: const [
    //     // set delays between retries (optional)
    //     Duration(seconds: 1), // wait 1 sec before first retry
    //     Duration(seconds: 1), // wait 2 sec before second retry
    //     Duration(seconds: 1), // wait 3 sec before third retry
    //   ],
    // ));

    dio.interceptors.add(
      QueuedInterceptorsWrapper(onRequest: (options, handler) async {
        print('onRequest dio response : ${options.toString()} / ${options.path}');

        // This is where you call your specific API
        // if (_isAccessTokenReissue) {
        //   print('reject accesstoken reissue.');
        //   return;
        //   return handler.reject(DioException(requestOptions: options));
        // }
        //
        // try {
        //   final isLogined = ref.read(loginStatementProvider);
        //   if (isLogined) {
        //     ref.read(newNotificationStateProvider.notifier).checkNewNotifications();
        //   }
        // } catch (e) {
        //   print('New Noti API Error $e');
        // }

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

          if (ref.read(loginStatementProvider)) {
            final accessToken = await TokenController.readAccessToken();
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        } catch (e) {
          print('API Request Error $e');
          return handler.next(options);
        }
        return handler.next(options);
      }, onResponse: (response, handler) async {
        print('onResponse dio response : ${response.toString()} / ${response.requestOptions.path}');
        // if (_isAccessTokenReissue) {
        //   print('reject accesstoken reissue.');
        //   return;
        // }

        Map<String, dynamic> resMap = response.data;
        print('1');

        bool isResult = true;
        if (resMap.containsKey('result')) {
          isResult = resMap['result'];
        }
        print('2');
        String code = '1000';
        if (!isResult) {
          if (resMap.containsKey('code')) {
            code = resMap['code'];
          }
        }
        print('3');

        print('5');
        // print('refreshDio - 0');
        // Access Token이 유효하지 않을 때
        if (code == 'ERTE-9999') {
          // _isAccessTokenReissue = true;
          // final mutex = Mutex();
          // await mutex.acquire();

          String oldAccessToken = response.requestOptions.headers['Authorization'].toString();
          oldAccessToken = oldAccessToken.replaceAll('Bearer ', '');

          String? currentAccessToken = await TokenController.readAccessToken();

          print('oldAccessToken $oldAccessToken / currentAccessToken $currentAccessToken');
          print('same ? ${oldAccessToken == currentAccessToken}');
          if (currentAccessToken != null) {
            if (oldAccessToken != currentAccessToken) {
              if (await TokenController.checkRefreshToken()) {
                var refreshDio = Dio();

                response.requestOptions.headers['Authorization'] = 'Bearer $currentAccessToken';
                final clonedRequest = await refreshDio.fetch(response.requestOptions);
                return handler.resolve(clonedRequest);
              } else {
                return handler.reject(DioException(requestOptions: response.requestOptions));
              }
            }
          }

          final refreshToken = await TokenController.readRefreshToken();

          await TokenController.clearTokens();
          var refreshDio = Dio();
          try {
            print('refreshDio - 1');

            JWTRepository jwtRepository = JWTRepository(dio: refreshDio);
            final tokenMap = await jwtRepository.getAccessToken(refreshToken);
            final newAccessToken = tokenMap['accessToken'];
            final newRefreshToken = tokenMap['refreshToken'];
            print('refreshDio - 6');
            // await TokenController.writeAccessToken(newAccessToken);
            await TokenController.writeTokens(newAccessToken, newRefreshToken);

            response.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            final clonedRequest = await refreshDio.fetch(response.requestOptions);
            print('refreshDio - 7');
            return handler.resolve(clonedRequest);
            // _isAccessTokenReissue = false;
          } on APIException catch (apiException) {
            ///getAccessToken 응답으로 받을 수 있는 오류라면  ECOM-9999 밖에 없음
            ///즉, Refresh Token이 유효하지 않을 때뿐
            // _isAccessTokenReissue = false;
            ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
          } catch (e) {
            // _isAccessTokenReissue = false;
            print('dio - getAccessToken error $e');
          } finally {
            // mutex.release();
          }

          // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신

          // 수행하지 못했던 API 요청 복사본 생성

          return handler.next(response);
        }
        return handler.next(response);
      }, onError: (e, handler) async {
        print('dio onerror : ${e.toString()}');
        return handler.reject(e);
        // int? errorCode = e.response?.statusCode;
        //
        // if (errorCode == 401) {
        //   // Access token expired, handle token renewal
        //   final options = e.response?.requestOptions;
        //   try {
        //     final refreshToken = await TokenController.readRefreshToken();
        //
        //     var refreshDio = Dio();
        //     try {
        //       JWTRepository jwtRepository = JWTRepository(dio: refreshDio);
        //       final newAccessToken = await jwtRepository.getAccessToken(refreshToken);
        //       await TokenController.writeAccessToken(newAccessToken);
        //       e.response!.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
        //       final clonedRequest = await refreshDio.fetch(e.response!.requestOptions);
        //       return handler.resolve(clonedRequest);
        //       // _isAccessTokenReissue = false;
        //     } on APIException catch (apiException) {
        //       ///getAccessToken 응답으로 받을 수 있는 오류라면  ECOM-9999 밖에 없음
        //       ///즉, Refresh Token이 유효하지 않을 때뿐
        //       // _isAccessTokenReissue = false;
        //       ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
        //     } catch (e) {
        //       // _isAccessTokenReissue = false;
        //       print('dio - getAccessToken error $e');
        //     }
        //   } catch (renewError, stacktrace) {
        //     e.response?.data = jsonDecode('{"result":false, "code": 401, "message":"token renewal failed"}');
        //     handler.resolve(e.response!);
        //     return;
        //   }
        // } else {
        //   APIException apiException = APIException(msg: e.toString(), code: errorCode.toString() ?? '400', refer: 'dio', caller: 'dio');
        //   ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
        //   return handler.reject(e);
        // }
      }),
    );

    return dio;
  }
}
