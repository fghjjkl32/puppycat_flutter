import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'feed_data_list_model.freezed.dart';
part 'feed_data_list_model.g.dart';

@freezed
class FeedDataListModel with _$FeedDataListModel {
  const factory FeedDataListModel({
    @Default([]) List<FeedData> list,
    List<FeedMemberInfoListData>? memberInfo,
    String? imgDomain,
    ParamsModel? params,
    @Default(1) int page,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadMoreDone,
    @Default(0) int totalCount,
  }) = _FeedDataListModel;

  factory FeedDataListModel.fromJson(Map<String, dynamic> json) =>
      _$FeedDataListModelFromJson(json);
}
