import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/user_list/popular_user_list/popular_user_list_data.dart';

part 'popular_user_list_data_list_model.freezed.dart';
part 'popular_user_list_data_list_model.g.dart';

@freezed
class PopularUserListDataListModel with _$PopularUserListDataListModel {
  const factory PopularUserListDataListModel({
    @Default([]) List<PopularUserListData> list,
    @Default(true) bool isLoading,
  }) = _PopularUserListDataListModel;

  factory PopularUserListDataListModel.fromJson(Map<String, dynamic> json) => _$PopularUserListDataListModelFromJson(json);
}
