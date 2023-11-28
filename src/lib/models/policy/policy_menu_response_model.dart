import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_menu_item_model.dart';

part 'policy_menu_response_model.freezed.dart';
part 'policy_menu_response_model.g.dart';

@freezed
class PolicyMenuResponseModel with _$PolicyMenuResponseModel {
  factory PolicyMenuResponseModel({
    required bool result,
    required String code,
    required DataListModel<PolicyMenuItemModel> data,
    String? message,
  }) = _PolicyMenuResponseModel;

  factory PolicyMenuResponseModel.fromJson(Map<String, dynamic> json) => _$PolicyMenuResponseModelFromJson(json);
}
