import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'pet_detail_item_model.freezed.dart';
part 'pet_detail_item_model.g.dart';

@freezed
class PetDetailItemModel with _$PetDetailItemModel {
  factory PetDetailItemModel({
    int? idx,
    int? memberIdx,
    String? name,
    int? number,
    int? gender,
    int? breedIdx,
    String? breedNameEtc,
    int? size,
    double? weight,
    int? age,
    String? birth,
    int? personalityCode,
    String? personalityEtc,
    List<String>? uploadFile,
    int? resetState,
    List<int>? healthIdxList,
    List<int>? allergyIdxList,
  }) = _PetDetailItemModel;

  factory PetDetailItemModel.fromJson(Map<String, dynamic> json) => _$PetDetailItemModelFromJson(json);
}
