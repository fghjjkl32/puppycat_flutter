import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/notification/notification_data_list_model.dart';

part 'notification_response_model.freezed.dart';
part 'notification_response_model.g.dart';

@freezed
class NotificationResponseModel with _$NotificationResponseModel {
  factory NotificationResponseModel({
    required bool result,
    required String code,
    required NotificationDataListModel? data,
    String? message,
  }) = _NotificationResponseModel;

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) => _$NotificationResponseModelFromJson(json);
}
