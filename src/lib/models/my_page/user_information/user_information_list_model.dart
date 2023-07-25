import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';

part 'user_information_list_model.freezed.dart';
part 'user_information_list_model.g.dart';

@freezed
class UserInformationListModel with _$UserInformationListModel {
  const factory UserInformationListModel({
    @Default([]) List<UserInformationItemModel> list,
    @Default(true) bool isLoading,
  }) = _UserInformationListModel;

  factory UserInformationListModel.fromJson(Map<String, dynamic> json) =>
      _$UserInformationListModelFromJson(json);
}
