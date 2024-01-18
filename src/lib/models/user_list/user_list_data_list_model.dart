import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/user_list/user_list_data.dart';

part 'user_list_data_list_model.freezed.dart';
part 'user_list_data_list_model.g.dart';

@freezed
class UserListDataListModel with _$UserListDataListModel {
  const factory UserListDataListModel({
    @Default([]) List<UserListData> memberList,
    @Default(true) bool isLoading,
  }) = _UserListDataListModel;

  factory UserListDataListModel.fromJson(Map<String, dynamic> json) => _$UserListDataListModelFromJson(json);
}
