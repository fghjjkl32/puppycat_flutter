import 'package:freezed_annotation/freezed_annotation.dart';

part 'jwt_response_model.freezed.dart';
part 'jwt_response_model.g.dart';

@freezed
class JWTResponseModel with _$JWTResponseModel {
  factory JWTResponseModel({
    required bool result,
    required String code,
    Map<String, dynamic>? data,
    List<String>? restrainList,
    String? message,
  }) = _JWTResponseModel;

  factory JWTResponseModel.fromJson(Map<String, dynamic> json) => _$JWTResponseModelFromJson(json);
}
