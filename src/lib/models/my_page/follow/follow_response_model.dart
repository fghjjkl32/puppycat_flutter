import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_data_list_model.dart';

part 'follow_response_model.freezed.dart';
part 'follow_response_model.g.dart';

@freezed
class FollowResponseModel with _$FollowResponseModel {
  factory FollowResponseModel({
    required bool result,
    required String code,
    required FollowDataListModel? data,
    String? message,
  }) = _FollowResponseModel;

  factory FollowResponseModel.fromJson(Map<String, dynamic> json) => _$FollowResponseModelFromJson(json);
}
