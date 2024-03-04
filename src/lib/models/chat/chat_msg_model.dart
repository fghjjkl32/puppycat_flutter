import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_msg_model.freezed.dart';
part 'chat_msg_model.g.dart';

@freezed
class ChatMessageModel with _$ChatMessageModel {
  factory ChatMessageModel({
    required int idx,
    required String id,
    required bool isMine,
    required String userID,
    required String nick,
    required String avatarUrl,
    required String msg,
    required String dateTime,
    required bool isEdited,
    required int reaction,
    required bool hasReaction,
    required bool isReply,
    String? replyTargetNick,
    String? replyTargetMsg,
    required bool isRead,
    required bool isConsecutively,
    @Default([]) List<String> reactions,
    required bool isViewTime,
    required String score,
    required String type, //일단은 String으로, 나중에 enum
    required String originData,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => _$ChatMessageModelFromJson(json);
}
