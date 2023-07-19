import 'dart:ffi';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_user_model.dart';
import 'package:pet_mobile_social_flutter/models/data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';

part 'chat_favorite_model.freezed.dart';

part 'chat_favorite_model.g.dart';

ChatUserModel _parseChatInfo(Object input) {
  var jsonInput = input as Map<String, dynamic>;
  return ChatUserModel.fromJson(jsonInput.map((key, value) {
    switch (key) {
      case 'chatMemberId' :
        return MapEntry('user_id', value);
      case 'accessToken' :
        return MapEntry('access_token', value);
      case 'homeServer' :
        return MapEntry('home_server', value);
      case 'deviceId' :
        return MapEntry('device_id', value);
      default:
        return MapEntry(key, value);
    }
  }));
}

@freezed
class ChatFavoriteModel with _$ChatFavoriteModel {
  factory ChatFavoriteModel({
    required int memberIdx,
    required int isBadge,
    required String nick,
    required String profileImgUrl,
    @JsonKey(name: 'chatInfo', fromJson: _parseChatInfo) required ChatUserModel chatInfo,
  }) = _ChatFavoriteModel;

  factory ChatFavoriteModel.fromJson(Map<String, dynamic> json) => _$ChatFavoriteModelFromJson(json);
}