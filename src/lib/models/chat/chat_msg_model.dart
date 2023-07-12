import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_msg_model.freezed.dart';

part 'chat_msg_model.g.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  factory ChatMessageModel({
    required bool isMine,
    required String userID,
    required String avatarUrl,
    required String msg,
    required String dateTime,
    required bool isEdited,
    required int reaction,
    required bool isReply,
    required bool isRead,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);
}
