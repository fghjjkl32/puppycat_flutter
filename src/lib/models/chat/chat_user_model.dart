import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_user_model.freezed.dart';
part 'chat_user_model.g.dart';

@freezed
class ChatUserModel with _$ChatUserModel {
  factory ChatUserModel({
    @JsonKey(name: 'user_id') String? chatMemberId,
    @JsonKey(name: 'access_token') String? accessToken,
    @JsonKey(name: 'home_server') String? homeServer,
    @JsonKey(name: 'device_id') String? deviceId,
  }) = _ChatUserModel;

  factory ChatUserModel.fromJson(Map<String, dynamic> json) => _$ChatUserModelFromJson(json);
}