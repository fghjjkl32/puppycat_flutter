import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/user/user_data_info_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';

part 'user_information_response_model.freezed.dart';
part 'user_information_response_model.g.dart';

@freezed
class UserInformationResponseModel with _$UserInformationResponseModel {
  factory UserInformationResponseModel({
    required bool result,
    required String code,
    required DataInfoModel<UserInformationItemModel> data,
    String? message,
  }) = _UserInformationResponseModel;

  factory UserInformationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserInformationResponseModelFromJson(json);
}
