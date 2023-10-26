import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_item_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'walk_result_list_model.freezed.dart';
part 'walk_result_list_model.g.dart';

@freezed
class WalkResultListModel with _$WalkResultListModel {
  const factory WalkResultListModel({
    required List<WalkResultItemModel> list,
    @Default(true) bool isLoading,
    String? imgDomain,
    ParamsModel? params,
    int? totalCalorie,
    String? totalWalkTime,
    int? totalDistance,
  }) = _WalkResultListModel;

  factory WalkResultListModel.fromJson(Map<String, dynamic> json) => _$WalkResultListModelFromJson(json);
}
