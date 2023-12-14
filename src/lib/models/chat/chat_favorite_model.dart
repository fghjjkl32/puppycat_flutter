// import 'dart:ffi';
//
// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:pet_mobile_social_flutter/models/chat/chat_user_model.dart';
// import 'package:pet_mobile_social_flutter/models/data_list_model.dart';
// import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
//
// part 'chat_favorite_model.freezed.dart';
//
// part 'chat_favorite_model.g.dart';
//
// ChatUserModel _parseChatInfo(Object input) {
//   var jsonInput = input as Map<String, dynamic>;
//   return ChatUserModel.fromJson(jsonInput.map((key, value) {
//     switch (key) {
//       case 'chatMemberId' :
//         return MapEntry('user_id', value);
//       case 'accessToken' :
//         return MapEntry('access_token', value);
//       case 'homeServer' :
//         return MapEntry('home_server', value);
//       case 'deviceId' :
//         return MapEntry('device_id', value);
//       default:
//         return MapEntry(key, value);
//     }
//   }));
// }
//
// @freezed
// class ChatFavoriteModel with _$ChatFavoriteModel {
//   factory ChatFavoriteModel({
//     required int memberIdx,
//     required int isBadge,
//     required String nick,
//     required String profileImgUrl,
//     required int? favoriteState,
//     // @JsonKey(name: 'chatInfo', fromJson: _parseChatInfo) required ChatUserModel chatInfo,
//     required String chatMemberId,
//     required String chatHomeServer,
//     required String chatAccessToken,
//     required String chatDeviceId,
//     @JsonKey(name: 'intro') required String introText,
//   }) = _ChatFavoriteModel;
//
//   factory ChatFavoriteModel.fromJson(Map<String, dynamic> json) => _$ChatFavoriteModelFromJson(json);
// }

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_favorite_model.freezed.dart';
part 'chat_favorite_model.g.dart';

@freezed
class ChatFavoriteModel with _$ChatFavoriteModel {
  factory ChatFavoriteModel({
    required String regDateTz,
    required String memberUuid,
    @JsonKey(name: 'result_cd') required String resultCd,
    required String regDate,
    required int sort,
    required int type,
    required String nick,
    required String targetMemberUuid,
    required String profileImgUrl,
    required int state,
    required int idx,
    required int maxUser,
  }) = _ChatFavoriteModel;

  factory ChatFavoriteModel.fromJson(Map<String, dynamic> json) => _$ChatFavoriteModelFromJson(json);
}
