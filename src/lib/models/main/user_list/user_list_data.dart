import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_list_data.freezed.dart';
part 'user_list_data.g.dart';

@freezed
class UserListData with _$UserListData {
  factory UserListData({
    String? nick,
    int? redDotState,
    String? memberUuid,
    String? profileImgUrl,
    String? intro,
    String? regDate,
    int? isBadge,
    int? followerCnt,
  }) = _UserListData;

  factory UserListData.fromJson(Map<String, dynamic> json) => _$UserListDataFromJson(json);
}
