import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/user_list/user_list_data_list_model.dart';

part 'user_list_response_model.freezed.dart';
part 'user_list_response_model.g.dart';

@freezed
class UserListResponseModel with _$UserListResponseModel {
  factory UserListResponseModel({
    required bool result,
    required String code,
    required UserListDataListModel? data,
    String? message,
  }) = _UserListResponseModel;

  factory UserListResponseModel.fromJson(Map<String, dynamic> json) => _$UserListResponseModelFromJson(json);
}
