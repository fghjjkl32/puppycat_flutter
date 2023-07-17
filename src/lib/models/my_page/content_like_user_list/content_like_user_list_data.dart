import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'content_like_user_list_data.freezed.dart';
part 'content_like_user_list_data.g.dart';

@freezed
class ContentLikeUserListData with _$ContentLikeUserListData {
  factory ContentLikeUserListData({
    required String nick,
    required int isFollow,
    required int isBadge,
    required int memberIdx,
    required int followerCnt,
    required String intro,
    required String profileImgUrl,
  }) = _ContentLikeUserListData;

  factory ContentLikeUserListData.fromJson(Map<String, dynamic> json) =>
      _$ContentLikeUserListDataFromJson(json);
}
