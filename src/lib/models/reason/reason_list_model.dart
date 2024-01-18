import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/reason/reason_list_item_model.dart';

part 'reason_list_model.freezed.dart';
part 'reason_list_model.g.dart';

@freezed
class ReasonListModel with _$ReasonListModel {
  const factory ReasonListModel({
    @Default([]) List<ReasonListItemModel> list,
    @Default(true) bool isLoading,
  }) = _ReasonListModel;

  factory ReasonListModel.fromJson(Map<String, dynamic> json) => _$ReasonListModelFromJson(json);
}
