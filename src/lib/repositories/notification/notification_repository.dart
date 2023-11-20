import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_list_item_model.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:pet_mobile_social_flutter/services/notification/notification_service.dart';
import 'package:pet_mobile_social_flutter/services/policy/policy_service.dart';

// final notificationRepositoryProvider = Provider.autoDispose((ref) => NotificationRepository());

class NotificationRepository {
  final Dio dio;

  NotificationRepository({
    required this.dio,
  }) {
    _notificationService = NotificationService(dio, baseUrl: baseUrl);
  }

  late final NotificationService _notificationService; // = NotificationService(dio, baseUrl: baseUrl);

  Future<NotificationDataListModel> getNotifications(int memberIdx, [int page = 1, int? type, int limit = 10]) async {
    Map<String, dynamic> queries = {
      'memberIdx': memberIdx,
      'page': page,
      'limit': limit,
    };

    if (type != null) {
      queries['type'] = type;
    }

    NotificationResponseModel responseModel = await _notificationService.getNotifications(queries);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'NotificationRepository',
        caller: 'getNotifications',
      );
    }

    return responseModel.data;
  }

  Future<bool> checkNewNotifications(int memberIdx) async {
    ResponseModel responseModel = await _notificationService.checkNewNotifications(memberIdx);

    // if (!responseModel.result) {
    //   throw APIException(
    //     msg: responseModel.message ?? '',
    //     code: responseModel.code,
    //     refer: 'SettingRepository',
    //     caller: 'getSetting',
    //   );
    // }

    return responseModel.result;
  }
}
