import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_room_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'chat_room_data_list_model.freezed.dart';
part 'chat_room_data_list_model.g.dart';

@freezed
class ChatRoomDataListModel with _$ChatRoomDataListModel {
  factory ChatRoomDataListModel({
    required List<ChatRoomModel> list,
    required ParamsModel params,
    String? message,
  }) = _ChatRoomDataListModel;

  factory ChatRoomDataListModel.fromJson(Map<String, dynamic> json) => _$ChatRoomDataListModelFromJson(json);
}
