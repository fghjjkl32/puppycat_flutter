import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/create_my_pet/item_model.dart';

part 'my_pet_item_model.freezed.dart';
part 'my_pet_item_model.g.dart';

@freezed
class MyPetItemModel with _$MyPetItemModel {
  factory MyPetItemModel({
    @Default(0) int? idx,
    @Default(0) int? imgSort,
    @Default(0) int? imgWidth,
    @Default(0) int? imgHeight,
    @Default(0) int? personalityIdx,
    @Default(0) int? memberIdx,
    @Default('') String? typeName,
    @Default('') String? birth,
    @Default('') String? ageText,
    @Default(0.0) double? weight,
    @Default('') String? genderText,
    @Default('') String? personalityEtc,
    @Default('') String? url,
    @Default('') String? breedName,
    @Default('') String? personality,
    @Default('') String? sizeText,
    @Default('') String? breedNameEtc,
    @Default('') String? name,
    @Default(0) int? breedIdx,
    @Default('') String? uuid,
    List<ItemModel>? healthList,
    List<ItemModel>? allergyList,
    @Default(false) bool selected,
  }) = _MyPetItemModel;

  factory MyPetItemModel.fromJson(Map<String, dynamic> json) => _$MyPetItemModelFromJson(json);
}
