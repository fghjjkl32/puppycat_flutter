import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_write_result_detail/walk_write_result_detail_list_model.dart';

part 'walk_write_result_detail_response_model.freezed.dart';
part 'walk_write_result_detail_response_model.g.dart';

@freezed
class WalkWriteResultDetailResponseModel with _$WalkWriteResultDetailResponseModel {
  factory WalkWriteResultDetailResponseModel({
    required bool result,
    required String code,
    required WalkWriteResultDetailListModel? data,
    String? message,
  }) = _WalkWriteResultDetailResponseModel;

  factory WalkWriteResultDetailResponseModel.fromJson(Map<String, dynamic> json) => _$WalkWriteResultDetailResponseModelFromJson(json);
}
