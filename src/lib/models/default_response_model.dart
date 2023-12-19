import 'package:freezed_annotation/freezed_annotation.dart';

part 'default_response_model.freezed.dart';
part 'default_response_model.g.dart';

@freezed
class ResponseModel with _$ResponseModel {
  factory ResponseModel({
    required bool result,
    required String code,
    @Default(null) Map<String, dynamic>? data,
    required String message,
  }) = _ResponseModel;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => _$ResponseModelFromJson(json);
}
