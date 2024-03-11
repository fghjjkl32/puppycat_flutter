import 'package:freezed_annotation/freezed_annotation.dart';

part 'firebase_chat_data_model.freezed.dart';
part 'firebase_chat_data_model.g.dart';

@freezed
class FirebaseChatDataModel with _$FirebaseChatDataModel {
  factory FirebaseChatDataModel({
    required String roomUuid,
    required String targetMemberUuid,
    required String senderMemberUuid,
    required String senderNick,
    required String senderMemberProfileImg,
    required String message,
    required String regDate,
  }) = _FirebaseChatDataModel;

  factory FirebaseChatDataModel.fromJson(Map<String, dynamic> json) => _$FirebaseChatDataModelFromJson(json);
}
