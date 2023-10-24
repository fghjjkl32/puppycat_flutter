import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';

part 'walk_result_detail_item_model.freezed.dart';
part 'walk_result_detail_item_model.g.dart';

@freezed
class WalkResultDetailItemModel with _$WalkResultDetailItemModel {
  factory WalkResultDetailItemModel({
    int? owner,
    String? endDate,
    String? memberUuid,
    List<WalkPetList>? walkPetList,
    String? standardPetUuid,
    String? walkTime,
    String? regDate,
    String? calorieText,
    String? routeUrl,
    String? contents,
    String? modiDate,
    String? routeUuid,
    String? distanceText,
    String? walkUuid,
    String? stepText,
    int? idx,
    String? startDate,
    int? together,
    List<ImgList>? imgList,
    List<MentionListData>? mentionList,
  }) = _WalkResultDetailItemModel;

  factory WalkResultDetailItemModel.fromJson(Map<String, dynamic> json) => _$WalkResultDetailItemModelFromJson(json);
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
    int? poopCount,
    int? peeCount,
    String? peeColorText,
    String? poopFormText,
    String? peeAmountText,
    String? poopAmountText,
    String? poopColorText,
  }) = _WalkPetList;

  factory WalkPetList.fromJson(Map<String, dynamic> json) => _$WalkPetListFromJson(json);
}

@freezed
class ImgList with _$ImgList {
  factory ImgList({
    int? imgWidth,
    int? imgHeight,
    int? sort,
    int? isRoute,
    int? idx,
    String? url,
  }) = _ImgList;

  factory ImgList.fromJson(Map<String, dynamic> json) => _$ImgListFromJson(json);
}
