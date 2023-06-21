
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';

part 'policy_response_model.freezed.dart';
part 'policy_response_model.g.dart';

@freezed
class PolicyResponseModel with _$PolicyResponseModel {
  factory PolicyResponseModel({
    required bool result,
    required String code,
    required DataListModel<PolicyItemModel> data,
    String? message,
  }) = _PolicyResponseModel;

  factory PolicyResponseModel.fromJson(Map<String, dynamic> json) => _$PolicyResponseModelFromJson(json);
}