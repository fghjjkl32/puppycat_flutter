import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_item_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'walk_result_detail_list_model.freezed.dart';
part 'walk_result_detail_list_model.g.dart';

@freezed
class WalkResultDetailListModel with _$WalkResultDetailListModel {
  const factory WalkResultDetailListModel({
    required List<WalkResultDetailItemModel> data,
    @Default(true) bool isLoading,
    String? imgDomain,
    ParamsModel? params,
  }) = _WalkResultDetailListModel;

  factory WalkResultDetailListModel.fromJson(Map<String, dynamic> json) => _$WalkResultDetailListModelFromJson(json);
}
