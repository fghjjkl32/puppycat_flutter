import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_list_model.dart';

part 'walk_result_detail_response_model.freezed.dart';
part 'walk_result_detail_response_model.g.dart';

@freezed
class WalkResultDetailResponseModel with _$WalkResultDetailResponseModel {
  factory WalkResultDetailResponseModel({
    required bool result,
    required String code,
    required WalkResultDetailListModel data,
    String? message,
  }) = _WalkResultDetailResponseModel;

  factory WalkResultDetailResponseModel.fromJson(Map<String, dynamic> json) => _$WalkResultDetailResponseModelFromJson(json);
}
