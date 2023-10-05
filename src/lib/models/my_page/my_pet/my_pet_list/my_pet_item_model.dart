import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/item_model.dart';

part 'my_pet_item_model.freezed.dart';
part 'my_pet_item_model.g.dart';

@freezed
class MyPetItemModel with _$MyPetItemModel {
  factory MyPetItemModel({
    int? idx,
    int? imgSort,
    int? imgWidth,
    int? imgHeight,
    int? personalityIdx,
    int? memberIdx,
    String? typeName,
    String? birth,
    String? ageText,
    double? weight,
    String? genderText,
    String? personalityEtc,
    String? url,
    String? breedName,
    String? personality,
    String? sizeText,
    String? breedNameEtc,
    String? name,
    int? breedIdx,
    List<ItemModel>? healthList,
    List<ItemModel>? allergyList,
  }) = _MyPetItemModel;

  factory MyPetItemModel.fromJson(Map<String, dynamic> json) => _$MyPetItemModelFromJson(json);
}
