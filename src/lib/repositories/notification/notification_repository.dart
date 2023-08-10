import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_list_item_model.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_response_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:pet_mobile_social_flutter/services/notification/notification_service.dart';
import 'package:pet_mobile_social_flutter/services/policy/policy_service.dart';

final notificationRepositoryProvider = Provider.autoDispose((ref) => NotificationRepository());

class NotificationRepository {
  final NotificationService _notificationService = NotificationService(DioWrap.getDioWithCookie());

  // Future<List<NotificationListItemModel>> getNotifications(int memberIdx, [int page = 1, int? type, int limit = 10]) async {
  //   NotificationResponseModel? notificationResponseModel = await _notificationService.getNotifications(memberIdx, page, limit);
  //
  //   if(notificationResponseModel == null) {
  //     ///NOTE
  //     ///204  케이스
  //     ///  or Error 인데  Error 핸들링 필요, 우선은 204라고만 가정
  //     return [];
  //   }
  //
  //   return notificationResponseModel.data.list;
  // }

  Future<NotificationDataListModel> getNotifications(int memberIdx, [int page = 1, int? type, int limit = 10]) async {
    NotificationResponseModel? notificationResponseModel = await _notificationService.getNotifications(memberIdx, page, limit);

    if (notificationResponseModel == null) {
      ///NOTE
      ///204  케이스
      ///  or Error 인데  Error 핸들링 필요, 우선은 204라고만 가정
      return const NotificationDataListModel(
        list: [],
        params: ParamsModel(
          memberIdx: 0,
          pagination: Pagination(
            startPage: 0,
            limitStart: 0,
            totalPageCount: 0,
            existNextPage: false,
            endPage: 0,
            existPrevPage: false,
            totalRecordCount: 0,
          ),
          offset: 0,
          limit: 0,
          pageSize: 0,
          page: 0,
          recordSize: 0,
        ),
      );
    }

    return notificationResponseModel.data;
  }
}
