import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/notification/notification_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/policy/policy_repository.dart';
import 'package:riverpod/riverpod.dart';
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
    try {
      var loginMemberIdx = ref.read(userInfoProvider).userModel!.idx;
      CookieJar cookieJar = GetIt.I<CookieJar>();

      var header = await userAgentClientHintsHeader();

      final options = BaseOptions(
        baseUrl: baseUrl,
        // connectTimeout: Duration(seconds: 5),
        // receiveTimeout: Duration(seconds: 3),
        headers: header,
      );

      Dio notiDio = Dio(options);

      if (notiDio.interceptors.whereType<CookieManager>().isEmpty) {
        notiDio.interceptors.add(CookieManager(cookieJar));
        notiDio.interceptors.add(QueuedInterceptorsWrapper());
      }

      notiDio.interceptors.add(CookieManager(cookieJar));

      final NotificationRepository notificationRepository = NotificationRepository(dio: notiDio);
      final isExistNewNoti = await notificationRepository.checkNewNotifications(loginMemberIdx);

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
