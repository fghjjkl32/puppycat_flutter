// import 'package:freezed_annotation/freezed_annotation.dart';
//
// part 'chat_room_model.freezed.dart';
//
// part 'chat_room_model.g.dart';
//
// @freezed
// class ChatRoomModel with _$ChatRoomModel {
//   factory ChatRoomModel({
//     required String id,
//     required String? avatarUrl,
//     required String nick,
//     required String lastMsg,
//     required bool isLastMsgMine,
//     required int newCount,
//     required bool isRead,
//     required bool isPin,
//     required String msgDateTime,
//     required bool isMine,
//     required bool isJoined,
//     @Default(false) bool isFavorite,
//     required String dmId,
//   }) = _ChatRoomModel;
//
//   factory ChatRoomModel.fromJson(Map<String, dynamic> json) => _$ChatRoomModelFromJson(json);
// }

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_last_message_info_model.dart';

part 'chat_room_model.freezed.dart';
part 'chat_room_model.g.dart';

@freezed
class ChatRoomModel with _$ChatRoomModel {
  factory ChatRoomModel({
    required String regDateTz,
    required String regDate,
    required int sort,
    required int type,
    required String uuid,
    required String roomId,
    required String roomName,
    required int fixState,
    required int favoriteState,
    required String nick,
    required String targetMemberUuid,
    required String profileImgUrl,
    required int state,
    required int idx,
    required int maxUser,
    required int noReadCount,
    required ChatLastMessageInfoModel? lastMessage,
  }) = _ChatRoomModel;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => _$ChatRoomModelFromJson(json);
}
