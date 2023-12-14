import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_data_list_model.dart';

part 'chat_room_response_model.freezed.dart';
part 'chat_room_response_model.g.dart';

@freezed
class ChatRoomResponseModel with _$ChatRoomResponseModel {
  factory ChatRoomResponseModel({
    required bool result,
    required String code,
    required ChatRoomDataListModel? data,
    String? message,
  }) = _ChatRoomResponseModel;

  factory ChatRoomResponseModel.fromJson(Map<String, dynamic> json) => _$ChatRoomResponseModelFromJson(json);
}
