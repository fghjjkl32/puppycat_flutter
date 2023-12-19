import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/providers/restrain/restrain_state_provider.dart';

part 'default_response_model.freezed.dart';
part 'default_response_model.g.dart';

@freezed
class ResponseModel with _$ResponseModel {
  factory ResponseModel({
    required bool result,
    required String code,
    @Default(null) Map<String, dynamic>? data,
    required String message,
    List<RestrainType>? restrainList,
  }) = _ResponseModel;

  factory ResponseModel.fromJson(Map<String, dynamic> json) => _$ResponseModelFromJson(json);
}
