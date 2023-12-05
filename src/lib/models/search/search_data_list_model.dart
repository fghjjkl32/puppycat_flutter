import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_data.dart';

part 'search_data_list_model.freezed.dart';
part 'search_data_list_model.g.dart';

@freezed
class SearchDataListModel with _$SearchDataListModel {
  const factory SearchDataListModel({
    @Default([]) List<SearchData> list,
    ParamsModel? params,
    @Default(1) int page,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadMoreDone,
    @Default(0) int totalCount,
    String? imgDomain,
    int? nick_count,
    int? tag_count,
    @Default([]) List<NickListData>? nick_list,
    @Default([]) List<TagListData>? tag_list,
    @Default([]) List<BestListData>? best_list,
  }) = _SearchDataListModel;

  factory SearchDataListModel.fromJson(Map<String, dynamic> json) => _$SearchDataListModelFromJson(json);
}

@freezed
class NickListData with _$NickListData {
  factory NickListData({
    String? nick,
    String? memberUuid,
    String? intro,
    String? profileImgUrl,
    int? isBadge,
    int? followerCnt,
    int? favoriteState,
  }) = _NickListData;

  factory NickListData.fromJson(Map<String, dynamic> json) => _$NickListDataFromJson(json);
}

@freezed
class TagListData with _$TagListData {
  factory TagListData({
    String? hashTagContentsCnt,
    int? idx,
    String? hashTag,
  }) = _TagListData;

  factory TagListData.fromJson(Map<String, dynamic> json) => _$TagListDataFromJson(json);
}

@freezed
class BestListData with _$BestListData {
  factory BestListData({
    String? searchWord,
    String? searchCnt,
  }) = _BestListData;

  factory BestListData.fromJson(Map<String, dynamic> json) => _$BestListDataFromJson(json);
}
