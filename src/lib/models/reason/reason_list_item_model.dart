import 'package:freezed_annotation/freezed_annotation.dart';

part 'reason_list_item_model.freezed.dart';
part 'reason_list_item_model.g.dart';

@freezed
class ReasonListItemModel with _$ReasonListItemModel {
  factory ReasonListItemModel({
    int? reportCode,
    int? code,
    String? name,
  }) = _ReasonListItemModel;

  factory ReasonListItemModel.fromJson(Map<String, dynamic> json) => _$ReasonListItemModelFromJson(json);
}
