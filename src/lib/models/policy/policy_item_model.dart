import 'package:freezed_annotation/freezed_annotation.dart';

part 'policy_item_model.freezed.dart';

part 'policy_item_model.g.dart';

@freezed
class PolicyItemModel with _$PolicyItemModel {
  factory PolicyItemModel({
    required int idx,
    required String required,
    String? detail,
    String? title,
    int? menuIdx,
    String? menuName,
    @Default(false) bool isAgreed,
  }) = _PolicyItemModel;

  factory PolicyItemModel.fromJson(Map<String, dynamic> json) => _$PolicyItemModelFromJson(json);
}
