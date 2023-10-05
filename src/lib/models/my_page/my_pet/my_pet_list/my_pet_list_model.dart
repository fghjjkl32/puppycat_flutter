import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'my_pet_list_model.freezed.dart';
part 'my_pet_list_model.g.dart';

@freezed
class MyPetListModel with _$MyPetListModel {
  const factory MyPetListModel({
    required List<MyPetItemModel> list,
    @Default(true) bool isLoading,
    String? imgDomain,
    ParamsModel? params,
  }) = _MyPetListModel;

  factory MyPetListModel.fromJson(Map<String, dynamic> json) => _$MyPetListModelFromJson(json);
}
