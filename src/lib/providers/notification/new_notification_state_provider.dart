import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/common.dart';
import 'package:pet_mobile_social_flutter/common/util/UUID/uuid_util.dart';
import 'package:pet_mobile_social_flutter/common/util/package_info/package_info_util.dart';
import 'package:pet_mobile_social_flutter/config/router/routes.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/notification/notification_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

part 'new_notification_state_provider.g.dart';

// @Riverpod(keepAlive: true)
@riverpod
class NewNotificationState extends _$NewNotificationState {
  @override
  bool build() {
    return false;
  }

  void checkNewNotifications() async {
    const storage = FlutterSecureStorage();
    try {
      CookieJar cookieJar = GetIt.I<CookieJar>();

      // var header = await userAgentClientHintsHeader();

      // final options = BaseOptions(
      //   baseUrl: baseUrl,
      //   // connectTimeout: Duration(seconds: 5),
      //   // receiveTimeout: Duration(seconds: 3),
      //   headers: header,
      // );

      Dio notiDio = Dio();

      if (notiDio.interceptors.whereType<CookieManager>().isEmpty) {
        notiDio.interceptors.add(CookieManager(cookieJar));
        // notiDio.interceptors.add(QueuedInterceptorsWrapper());
      }

      notiDio.interceptors.add(CookieManager(cookieJar));
      notiDio.interceptors.add(
        InterceptorsWrapper(onRequest: (options, handler) async {
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
          // print('onResponse dio response : ${response.toString()}');
          //
          // Map<String, dynamic> resMap = response.data;
          //
          // bool isResult = true;
          // if (resMap.containsKey('result')) {
          //   isResult = resMap['result'];
          // }
          //
          // String code = '1000';
          // if (!isResult) {
          //   if (resMap.containsKey('code')) {
          //     code = resMap['code'];
          //   }
          // }
          //
          // //Access Token이 유효하지 않을 때
          // if (code == 'ERTE-9999') {
          //   final accessToken = await storage.read(key: 'ACCESS_TOKEN');
          //   final refreshToken = await storage.read(key: 'REFRESH_TOKEN');
          //
          //   ///NOTE
          //   ///refresh Token 검증 로직
          //   ///Access Token 재발행 시 사용
          //
          //   var refreshDio = Dio();
          //   // JWTResponseModel jwtResponseModel = await refreshDio.post('$memberBaseUrl/v1/oauth/token', queryParameters: {
          //   JWTResponseModel jwtResponseModel = await JWTService(refreshDio, baseUrl: memberBaseUrl).getAccessToken({
          //     'refreshToken': refreshToken,
          //   });
          //
          //   if (!jwtResponseModel.result) {
          //     if (jwtResponseModel.code == 'ECOM-9999') {
          //       ///TODO
          //       ///Refresh Token이 유효하지 않음
          //       ///유효하지 않으면 로그인 페이지 이동
          //       ///로그인 프로바이더 상태 초기화 필요
          //       await storage.delete(key: 'ACCESS_TOKEN');
          //       await storage.delete(key: 'REFRESH_TOKEN');
          //
          //       // ref.read(loginStateProvider.notifier).state = LoginStatus.none;
          //       // ref.read(userInfoProvider.notifier).state = UserInfoModel();
          //       // ref.read(loginRouteStateProvider.notifier).state = LoginRoute.loginScreen;
          //       APIException apiException = APIException(msg: jwtResponseModel.message ?? 'unknown', code: jwtResponseModel.code ?? '400', refer: 'Dio Refresh', caller: 'getAccessToken');
          //       ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
          //       return handler.next(response);
          //     }
          //   }
          //
          //   if (jwtResponseModel.data == null) {
          //     APIException apiException = APIException(
          //       msg: jwtResponseModel.message ?? 'getAccessToken Data is null',
          //       code: jwtResponseModel.code ?? '400',
          //       refer: 'dio',
          //       caller: 'dio',
          //     );
          //     ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
          //   }
          //
          //   final newAccessToken = jwtResponseModel.data!['accessToken'];
          //   await storage.write(key: 'ACCESS_TOKEN', value: newAccessToken);
          //
          //   // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
          //   response.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          //
          //   // 수행하지 못했던 API 요청 복사본 생성
          //   final clonedRequest = await notiDio.fetch(response.requestOptions);
          //   // final clonedRequest = await dio.request(response.requestOptions.path,
          //   // options: Options(method: response.requestOptions.method, headers: response.requestOptions.headers),
          //   // data: response.requestOptions.data,
          //   // queryParameters: response.requestOptions.queryParameters);
          //
          //   // API 복사본으로 재요청
          //   return handler.resolve(clonedRequest);
          //   // return handler.next(response);
          // }

          return handler.next(response);
        }, onError: (error, handler) {
          print('dio onerror : ${error.toString()}');
          int? errorCode = error.response?.statusCode;
          APIException apiException = APIException(msg: error.toString(), code: errorCode.toString() ?? '400', refer: 'dio', caller: 'dio');
          ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
          return handler.reject(error);
        }),
      );

      final NotificationRepository notificationRepository = NotificationRepository(dio: notiDio);
      final isExistNewNoti = await notificationRepository.checkNewNotifications();

      if (isExistNewNoti) {
        print('exist new noti');
        state = true;
      } else {
        print('no new noti');
        state = false;
      }
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = false;
    } catch (e) {
      print('checkNewNotifications error $e');
      state = false;
    }
  }
}
