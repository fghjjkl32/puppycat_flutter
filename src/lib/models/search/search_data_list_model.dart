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
  }) = _SearchDataListModel;

  factory SearchDataListModel.fromJson(Map<String, dynamic> json) =>
      _$SearchDataListModelFromJson(json);
}
