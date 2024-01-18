import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/reason/reason_list_model.dart';

part 'reason_response_model.freezed.dart';
part 'reason_response_model.g.dart';

@freezed
class ReasonResponseModel with _$ReasonResponseModel {
  factory ReasonResponseModel({
    required bool result,
    required String code,
    required ReasonListModel? data,
    String? message,
  }) = _ReasonResponseModel;

  factory ReasonResponseModel.fromJson(Map<String, dynamic> json) => _$ReasonResponseModelFromJson(json);
}
