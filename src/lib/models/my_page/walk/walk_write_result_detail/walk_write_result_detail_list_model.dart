import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_item_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_write_result_detail/walk_write_result_detail_item_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'walk_write_result_detail_list_model.freezed.dart';
part 'walk_write_result_detail_list_model.g.dart';

@freezed
class WalkWriteResultDetailListModel with _$WalkWriteResultDetailListModel {
  const factory WalkWriteResultDetailListModel({
    required List<WalkWriteResultDetailItemModel> list,
    @Default(true) bool isLoading,
    String? imgDomain,
  }) = _WalkWriteResultDetailListModel;

  factory WalkWriteResultDetailListModel.fromJson(Map<String, dynamic> json) => _$WalkWriteResultDetailListModelFromJson(json);
}
