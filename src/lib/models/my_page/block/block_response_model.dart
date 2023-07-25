import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/block/block_data_list_model.dart';

part 'block_response_model.freezed.dart';
part 'block_response_model.g.dart';

@freezed
class BlockResponseModel with _$BlockResponseModel {
  factory BlockResponseModel({
    required bool result,
    required String code,
    required BlockDataListModel data,
    String? message,
  }) = _BlockResponseModel;

  factory BlockResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BlockResponseModelFromJson(json);
}
