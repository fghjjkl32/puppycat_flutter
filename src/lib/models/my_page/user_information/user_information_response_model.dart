import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_information_response_model.freezed.dart';
part 'user_information_response_model.g.dart';

@freezed
class UserInformationResponseModel with _$UserInformationResponseModel {
  factory UserInformationResponseModel({
    required bool result,
    required String code,
    Map<String, dynamic>? data,
    String? message,
  }) = _UserInformationResponseModel;

  factory UserInformationResponseModel.fromJson(Map<String, dynamic> json) => _$UserInformationResponseModelFromJson(json);
}
