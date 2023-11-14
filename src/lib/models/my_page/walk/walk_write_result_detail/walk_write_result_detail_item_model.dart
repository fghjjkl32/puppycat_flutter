import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_item_model.dart';

part 'walk_write_result_detail_item_model.freezed.dart';
part 'walk_write_result_detail_item_model.g.dart';

@freezed
class WalkWriteResultDetailItemModel with _$WalkWriteResultDetailItemModel {
  factory WalkWriteResultDetailItemModel({
    int? owner,
    String? memberUuid,
    String? endDate,
    List<WalkPetList>? walkPetList,
    String? walkTime,
    String? calorieText,
    String? endDateText,
    String? startDateText,
    String? routeUrl,
    String? distanceText,
    String? walkUuid,
    String? stepText,
    String? startDate,
  }) = _WalkWriteResultDetailItemModel;

  factory WalkWriteResultDetailItemModel.fromJson(Map<String, dynamic> json) => _$WalkWriteResultDetailItemModelFromJson(json);
}

// @freezed
// class WalkResultPetList with _$WalkResultPetList {
//   factory WalkResultPetList({
//     String? petUuid,
//     String? petProfileUrl,
//     String? name,
//     String? petProfileWidth,
//     String? petProfileHeight,
//     int? idx,
//   }) = _WalkResultPetList;
//
//   factory WalkResultPetList.fromJson(Map<String, dynamic> json) => _$WalkPetListFromJson(json);
// }
