import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/setting/customer_support/menu_item_model.dart';

part 'menu_data_list_model.freezed.dart';
part 'menu_data_list_model.g.dart';

@freezed
class MenuDataListModel with _$MenuDataListModel {
  const factory MenuDataListModel({
    @Default([]) List<MenuItemModel> list,
    @Default(true) bool isLoading,
  }) = _MenuDataListModel;

  factory MenuDataListModel.fromJson(Map<String, dynamic> json) => _$MenuDataListModelFromJson(json);
}
