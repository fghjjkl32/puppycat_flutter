import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_history_model.dart';

part 'chat_history_response_model.freezed.dart';
part 'chat_history_response_model.g.dart';

@freezed
class ChatHistoryResponseModel with _$ChatHistoryResponseModel {
  factory ChatHistoryResponseModel({
    required bool result,
    required String code,
    required ChatHistoryModel? data,
    String? message,
  }) = _ChatHistoryResponseModel;

  factory ChatHistoryResponseModel.fromJson(Map<String, dynamic> json) => _$ChatHistoryResponseModelFromJson(json);
}
