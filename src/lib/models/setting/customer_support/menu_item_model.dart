import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item_model.freezed.dart';
part 'menu_item_model.g.dart';

@freezed
class MenuItemModel with _$MenuItemModel {
  factory MenuItemModel({
    String? menuName,
    int? idx,
  }) = _MenuItemModel;

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);
}
