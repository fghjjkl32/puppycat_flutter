import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_last_message_info_model.freezed.dart';
part 'chat_last_message_info_model.g.dart';

@freezed
class ChatLastMessageInfoModel with _$ChatLastMessageInfoModel {
  factory ChatLastMessageInfoModel({
    required String score,
    required String senderMemberUuid,
    required String regDate,
    required String senderNick,
    required String message,
    required String type,
    required String roomId,
    // required String target,
  }) = _ChatLastMessageInfoModel;

  factory ChatLastMessageInfoModel.fromJson(Map<String, dynamic> json) => _$ChatLastMessageInfoModelFromJson(json);
}
