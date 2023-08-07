import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/popular_user_list/popular_user_list_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/main/user_list/user_list_data_list_model.dart';

part 'popular_user_list_response_model.freezed.dart';
part 'popular_user_list_response_model.g.dart';

@freezed
class PopularUserListResponseModel with _$PopularUserListResponseModel {
  factory PopularUserListResponseModel({
    required bool result,
    required String code,
    required PopularUserListDataListModel data,
    String? message,
  }) = _PopularUserListResponseModel;

  factory PopularUserListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PopularUserListResponseModelFromJson(json);
}
