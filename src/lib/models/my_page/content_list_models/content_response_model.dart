import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_data_list_model.dart';

part 'content_response_model.freezed.dart';
part 'content_response_model.g.dart';

@freezed
class ContentResponseModel with _$ContentResponseModel {
  factory ContentResponseModel({
    required bool result,
    required String code,
    required ContentDataListModel data,
    String? message,
  }) = _ContentResponseModel;

  factory ContentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ContentResponseModelFromJson(json);
}
