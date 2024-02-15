import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_enter_model.dart';

part 'chat_enter_response_model.freezed.dart';
part 'chat_enter_response_model.g.dart';

@freezed
class ChatEnterResponseModel with _$ChatEnterResponseModel {
  factory ChatEnterResponseModel({
    required bool result,
    required String code,
    required ChatEnterModel? data,
    String? message,
  }) = _ChatEnterResponseModel;

  factory ChatEnterResponseModel.fromJson(Map<String, dynamic> json) => _$ChatEnterResponseModelFromJson(json);
}
