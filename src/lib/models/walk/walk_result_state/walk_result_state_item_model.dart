import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data.dart';

part 'walk_result_state_item_model.freezed.dart';
part 'walk_result_state_item_model.g.dart';

@freezed
class WalkResultStateItemModel with _$WalkResultStateItemModel {
  factory WalkResultStateItemModel({
    bool? isRegistWalk,
    String? walkUuid,
    bool? isEndWalk,
    bool? isForce,
  }) = _WalkResultStateItemModel;

  factory WalkResultStateItemModel.fromJson(Map<String, dynamic> json) => _$WalkResultStateItemModelFromJson(json);
}
