import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_user_register_model.freezed.dart';
part 'chat_user_register_model.g.dart';

@freezed
class ChatUserRegisterModel with _$ChatUserRegisterModel {
  factory ChatUserRegisterModel({
    String? chatMemberId,
    String? homeServer,
    String? accessToken,
    String? deviceId,
  }) = _ChatUserRegisterModel;

  factory ChatUserRegisterModel.fromJson(Map<String, dynamic> json) => _$ChatUserRegisterModelFromJson(json);
}