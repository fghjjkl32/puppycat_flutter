import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_list_item_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data.dart';

part 'notification_data_list_model.freezed.dart';
part 'notification_data_list_model.g.dart';

@freezed
class NotificationDataListModel with _$NotificationDataListModel {
  const factory NotificationDataListModel({
    @Default([]) List<NotificationListItemModel> list,
    ParamsModel? params,
    String? imgDomain,
    bool? isFirst,
    bool? isPush,
  }) = _NotificationDataListModel;

  factory NotificationDataListModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataListModelFromJson(json);
}
