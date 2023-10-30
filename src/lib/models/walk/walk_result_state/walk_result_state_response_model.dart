import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_write_result_detail/walk_write_result_detail_list_model.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_result_state/walk_result_state_list_model.dart';

part 'walk_result_state_response_model.freezed.dart';
part 'walk_result_state_response_model.g.dart';

@freezed
class WalkResultStateResponseModel with _$WalkResultStateResponseModel {
  factory WalkResultStateResponseModel({
    required bool result,
    required String code,
    required WalkResultStateListModel data,
    String? message,
  }) = _WalkResultStateResponseModel;

  factory WalkResultStateResponseModel.fromJson(Map<String, dynamic> json) => _$WalkResultStateResponseModelFromJson(json);
}
