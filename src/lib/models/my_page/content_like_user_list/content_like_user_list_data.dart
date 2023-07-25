import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'content_like_user_list_data.freezed.dart';
part 'content_like_user_list_data.g.dart';

@freezed
class ContentLikeUserListData with _$ContentLikeUserListData {
  factory ContentLikeUserListData({
    String? nick,
    int? followState,
    int? isBadge,
    int? memberIdx,
    int? followerCnt,
    String? intro,
    String? profileImgUrl,
  }) = _ContentLikeUserListData;

  factory ContentLikeUserListData.fromJson(Map<String, dynamic> json) =>
      _$ContentLikeUserListDataFromJson(json);
}
