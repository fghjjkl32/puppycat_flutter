import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/select_button/select_button_list_model.dart';

part 'select_button_response_model.freezed.dart';
part 'select_button_response_model.g.dart';

@freezed
class SelectButtonResponseModel with _$SelectButtonResponseModel {
  factory SelectButtonResponseModel({
    required bool result,
    required String code,
    required SelectButtonListModel? data,
    String? message,
  }) = _ReportResponseModel;

  factory SelectButtonResponseModel.fromJson(Map<String, dynamic> json) => _$SelectButtonResponseModelFromJson(json);
}
