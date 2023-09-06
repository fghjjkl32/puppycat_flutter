import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';

part 'select_button_list_model.freezed.dart';
part 'select_button_list_model.g.dart';

@freezed
class SelectButtonListModel with _$SelectButtonListModel {
  const factory SelectButtonListModel({
    @Default([]) List<SelectButtonItemModel> list,
    @Default(true) bool isLoading,
  }) = _ReportListModel;

  factory SelectButtonListModel.fromJson(Map<String, dynamic> json) => _$SelectButtonListModelFromJson(json);
}
