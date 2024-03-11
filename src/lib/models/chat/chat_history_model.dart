import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'chat_history_model.freezed.dart';
part 'chat_history_model.g.dart';

@freezed
class ChatHistoryModel with _$ChatHistoryModel {
  factory ChatHistoryModel({
    List<String>? log,
    ParamsModel? params,
  }) = _ChatHistoryModel;

  factory ChatHistoryModel.fromJson(Map<String, dynamic> json) => _$ChatHistoryModelFromJson(json);
}
