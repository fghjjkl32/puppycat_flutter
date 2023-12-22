import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_list_model.dart';

part 'my_pet_list_response_model.freezed.dart';
part 'my_pet_list_response_model.g.dart';

@freezed
class MyPetListResponseModel with _$MyPetListResponseModel {
  factory MyPetListResponseModel({
    required bool result,
    required String code,
    required MyPetListModel? data,
    String? message,
  }) = _MyPetListResponseModel;

  factory MyPetListResponseModel.fromJson(Map<String, dynamic> json) => _$MyPetListResponseModelFromJson(json);
}
