import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_data.freezed.dart';
part 'follow_data.g.dart';

@freezed
class FollowData with _$FollowData {
  factory FollowData({
    String? followNick,
    String? followerNick,
    String? url,
    int? isBadge,
    String? memberUuid,
    int? followerCnt,
    String? regDate,
    String? followUuid,
    int? newState,
    String? intro,
    int? isFollow,
    String? followerUuid,
    String? followerId,
    int? favoriteState,
  }) = _FollowData;

  factory FollowData.fromJson(Map<String, dynamic> json) => _$FollowDataFromJson(json);
}
