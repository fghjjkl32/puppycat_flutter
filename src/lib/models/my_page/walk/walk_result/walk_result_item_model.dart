import 'package:freezed_annotation/freezed_annotation.dart';

part 'walk_result_item_model.freezed.dart';
part 'walk_result_item_model.g.dart';

@freezed
class WalkResultItemModel with _$WalkResultItemModel {
  factory WalkResultItemModel({
    int? resultImgWidth,
    int? resultImgHeight,
    String? endDate,
    String? memberUuid,
    List<WalkPetList>? walkPetList,
    String? resultImgUrl,
    String? standardPetUuid,
    int? petCnt,
    String? walkTime,
    String? regDate,
    String? calorieText,
    String? endDateText,
    String? startDateText,
    String? distanceText,
    String? walkUuid,
    String? stepText,
    int? together,
    String? startDate,
  }) = _WalkResultItemModel;

  factory WalkResultItemModel.fromJson(Map<String, dynamic> json) => _$WalkResultItemModelFromJson(json);
}

@freezed
class WalkPetList with _$WalkPetList {
  factory WalkPetList({
    String? petUuid,
    String? petProfileUrl,
    String? name,
    String? petProfileWidth,
    String? petProfileHeight,
    int? idx,
  }) = _WalkPetList;

  factory WalkPetList.fromJson(Map<String, dynamic> json) => _$WalkPetListFromJson(json);
}
