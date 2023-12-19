import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/restrain/restrain_list_model.dart';

part 'restrain_response_model.freezed.dart';
part 'restrain_response_model.g.dart';

@freezed
class RestrainResponseModel with _$RestrainResponseModel {
  factory RestrainResponseModel({
    required bool result,
    required String code,
    required RestrainDataModel? data,
    String? message,
  }) = _RestrainResponseModel;

  factory RestrainResponseModel.fromJson(Map<String, dynamic> json) => _$RestrainResponseModelFromJson(json);
}
