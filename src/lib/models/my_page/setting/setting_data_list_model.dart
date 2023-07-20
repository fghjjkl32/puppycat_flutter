import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/setting/main_list_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/setting/sub_list_data.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'setting_data_list_model.freezed.dart';
part 'setting_data_list_model.g.dart';

@freezed
class SettingDataListModel with _$SettingDataListModel {
  const factory SettingDataListModel({
    @Default([]) List<MainListData> mainList,
    @Default([]) List<SubListData> subList,
    @Default({}) Map<String, int> switchState,
  }) = _SettingDataListModel;

  factory SettingDataListModel.fromJson(Map<String, dynamic> json) =>
      _$SettingDataListModelFromJson(json);
}
