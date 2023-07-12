import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_room_model.freezed.dart';

part 'chat_room_model.g.dart';

@freezed
class ChatRoomModel with _$ChatRoomModel {
  factory ChatRoomModel({
    required String id,
    required String? avatarUrl,
    required String nick,
    required String lastMsg,
    required int newCount,
    required bool isRead,
    required bool isPin,
    required String msgDateTime,
    required bool isMine,
    required bool isJoined,
  }) = _ChatRoomModel;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => _$ChatRoomModelFromJson(json);
}
