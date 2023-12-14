import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_data.freezed.dart';
part 'search_data.g.dart';

@freezed
class SearchData with _$SearchData {
  factory SearchData({
    String? nick,
    @JsonKey(name: 'uuid') String? memberUuid,
    String? intro,
    String? profileImgUrl,
    int? isBadge,
    int? followerCnt,
    int? favoriteState,
    String? hashTagContentsCnt,
    String? hashTag,
  }) = _SearchData;

  factory SearchData.fromJson(Map<String, dynamic> json) => _$SearchDataFromJson(json);
}
