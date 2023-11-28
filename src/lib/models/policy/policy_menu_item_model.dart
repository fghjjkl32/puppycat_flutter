import 'package:freezed_annotation/freezed_annotation.dart';

part 'policy_menu_item_model.freezed.dart';
part 'policy_menu_item_model.g.dart';

@freezed
class PolicyMenuItemModel with _$PolicyMenuItemModel {
  factory PolicyMenuItemModel({
    String? menuName,
    int? idx,
    List<String>? dateList,
  }) = _PolicyMenuItemModel;

  factory PolicyMenuItemModel.fromJson(Map<String, dynamic> json) => _$PolicyMenuItemModelFromJson(json);
}
