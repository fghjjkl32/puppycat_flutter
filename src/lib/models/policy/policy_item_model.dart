
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/data_list_model.dart';

part 'policy_item_model.freezed.dart';
part 'policy_item_model.g.dart';

@freezed
class PolicyItemModel with _$PolicyItemModel {
  factory PolicyItemModel({
    required int idx,
    required String required,
    String? detail,
    String? title,
    @Default(false) bool isAgreed,
  }) = _PolicyItemModel;

  factory PolicyItemModel.fromJson(Map<String, dynamic> json) => _$PolicyItemModelFromJson(json);
}