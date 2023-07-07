import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_information/my_information_item_model.dart';

part 'my_information_response_model.freezed.dart';
part 'my_information_response_model.g.dart';

@freezed
class MyInformationResponseModel with _$MyInformationResponseModel {
  factory MyInformationResponseModel({
    required bool result,
    required String code,
    required DataListModel<MyInformationItemModel> data,
    String? message,
  }) = _MyInformationResponseModel;

  factory MyInformationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MyInformationResponseModelFromJson(json);
}
