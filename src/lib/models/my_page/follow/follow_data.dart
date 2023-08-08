import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'follow_data.freezed.dart';
part 'follow_data.g.dart';

@freezed
class FollowData with _$FollowData {
  factory FollowData({
    String? followNick,
    String? followerNick,
    String? url,
    int? isBadge,
    int? memberIdx,
    int? followerCnt,
    String? regDate,
    int? followIdx,
    int? newState,
    String? intro,
    int? isFollow,
    int? followerIdx,
    String? followerId,
    String? chatMemberId,
    String? chatHomeServer,
    String? chatDeviceId,
    String? chatAccessToken,
    int? favoriteState,
  }) = _FollowData;

  factory FollowData.fromJson(Map<String, dynamic> json) =>
      _$FollowDataFromJson(json);
}
