import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_response_model.freezed.dart';
part 'token_response_model.g.dart';

@freezed
class TokenResponseModel with _$TokenResponseModel {
  factory TokenResponseModel({
    required bool result,
    required String code,
    required Map<String, dynamic>? data,
    List<String>? restrainList,
    String? message,
  }) = _TokenResponseModel;

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) => _$TokenResponseModelFromJson(json);
}
