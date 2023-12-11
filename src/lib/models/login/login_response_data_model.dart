import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_data_model.freezed.dart';
part 'login_response_data_model.g.dart';

@freezed
class LoginResponseDataModel with _$LoginResponseDataModel {
  factory LoginResponseDataModel({
    required List<String> restrainList,
    required String accessToken,
    required String refreshToken,
  }) = _LoginResponseDataModel;

  factory LoginResponseDataModel.fromJson(Map<String, dynamic> json) => _$LoginResponseDataModelFromJson(json);
}
