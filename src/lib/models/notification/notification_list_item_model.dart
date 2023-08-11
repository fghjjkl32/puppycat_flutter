import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_sender_info_model.dart';

part 'notification_list_item_model.freezed.dart';
part 'notification_list_item_model.g.dart';

@freezed
class NotificationListItemModel with _$NotificationListItemModel {
  factory NotificationListItemModel({
    required int senderIdx,
    String? img,
    required int memberIdx,
    required int commentIdx,
    required String regDate,
    required int type,
    required String title,
    required String body,
    required int isShow,
    required int allNotiIdx,
    List<NotificationSenderInfoModel>? senderInfo,
    String? contents,
    required int contentsIdx,
    required String subType,
    required int state,
    required int idx,
    List<Map<String, dynamic>>? mentionMemberInfo,
    int? contentsLikeState,
    int? followState,
  }) = _NotificationListItemModel;

  factory NotificationListItemModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationListItemModelFromJson(json);
}
