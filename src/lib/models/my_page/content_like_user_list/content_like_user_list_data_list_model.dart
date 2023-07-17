import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_data.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'content_like_user_list_data_list_model.freezed.dart';
part 'content_like_user_list_data_list_model.g.dart';

@freezed
class ContentLikeUserListDataListModel with _$ContentLikeUserListDataListModel {
  const factory ContentLikeUserListDataListModel({
    @Default([]) List<ContentLikeUserListData> list,
    ParamsModel? params,
    @Default(1) int page,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadMoreDone,
    @Default(0) int totalCount,
  }) = _ContentLikeUserListDataListModel;

  factory ContentLikeUserListDataListModel.fromJson(
          Map<String, dynamic> json) =>
      _$ContentLikeUserListDataListModelFromJson(json);
}
