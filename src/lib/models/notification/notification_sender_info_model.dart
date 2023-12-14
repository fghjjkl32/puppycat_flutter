import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_sender_info_model.freezed.dart';
part 'notification_sender_info_model.g.dart';

@freezed
class NotificationSenderInfoModel with _$NotificationSenderInfoModel {
  factory NotificationSenderInfoModel({
    required String nick,
    required int isBadge,
    required String memberUuid,
    required int? followerCnt,
    required String profileImgUrl,
  }) = _NotificationSenderInfoModel;

  factory NotificationSenderInfoModel.fromJson(Map<String, dynamic> json) => _$NotificationSenderInfoModelFromJson(json);
}
