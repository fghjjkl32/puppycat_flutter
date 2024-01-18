import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/setting/setting_data_list_model.dart';

part 'setting_response_model.freezed.dart';
part 'setting_response_model.g.dart';

@freezed
class SettingResponseModel with _$SettingResponseModel {
  factory SettingResponseModel({
    required bool result,
    required String code,
    required SettingDataListModel? data,
    String? message,
  }) = _SettingResponseModel;

  factory SettingResponseModel.fromJson(Map<String, dynamic> json) => _$SettingResponseModelFromJson(json);
}
