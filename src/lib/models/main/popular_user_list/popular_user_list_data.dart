import 'package:freezed_annotation/freezed_annotation.dart';

part 'popular_user_list_data.freezed.dart';
part 'popular_user_list_data.g.dart';

@freezed
class PopularUserListData with _$PopularUserListData {
  factory PopularUserListData({
    String? nick,
    int? isBadge,
    String? memberUuid,
    int? followerCnt,
    String? profileImgUrl,
    List<ContentsListData>? contentsList,
  }) = _PopularUserListData;

  factory PopularUserListData.fromJson(Map<String, dynamic> json) => _$PopularUserListDataFromJson(json);
}

@freezed
class ContentsListData with _$ContentsListData {
  factory ContentsListData({
    String? imgUrl,
    String? regDate,
    int? idx,
    int? imageCnt,
  }) = _ContentsListData;

  factory ContentsListData.fromJson(Map<String, dynamic> json) => _$ContentsListDataFromJson(json);
}
