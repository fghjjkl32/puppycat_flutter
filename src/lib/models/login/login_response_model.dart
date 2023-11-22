import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/login/login_response_data_model.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

@freezed
class LoginResponseModel with _$LoginResponseModel {
  factory LoginResponseModel({
    required bool result,
    required String code,
    required LoginResponseDataModel? data,
    String? message,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);
}
