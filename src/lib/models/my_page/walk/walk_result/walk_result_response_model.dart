import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_list_model.dart';

part 'walk_result_response_model.freezed.dart';
part 'walk_result_response_model.g.dart';

@freezed
class WalkResultResponseModel with _$WalkResultResponseModel {
  factory WalkResultResponseModel({
    required bool result,
    required String code,
    required WalkResultListModel data,
    String? message,
  }) = _WalkResultResponseModel;

  factory WalkResultResponseModel.fromJson(Map<String, dynamic> json) => _$WalkResultResponseModelFromJson(json);
}
