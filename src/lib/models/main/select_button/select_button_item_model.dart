import 'package:freezed_annotation/freezed_annotation.dart';

part 'select_button_item_model.freezed.dart';
part 'select_button_item_model.g.dart';

@freezed
class SelectButtonItemModel with _$SelectButtonItemModel {
  factory SelectButtonItemModel({
    int? reportCode,
    int? code,
    String? name,
  }) = _SelectButtonItemModel;

  factory SelectButtonItemModel.fromJson(Map<String, dynamic> json) => _$SelectButtonItemModelFromJson(json);
}
