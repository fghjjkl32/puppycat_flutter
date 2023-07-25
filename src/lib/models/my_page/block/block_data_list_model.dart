import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/block/block_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_data.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'block_data_list_model.freezed.dart';
part 'block_data_list_model.g.dart';

@freezed
class BlockDataListModel with _$BlockDataListModel {
  const factory BlockDataListModel({
    @Default([]) List<BlockData> list,
    ParamsModel? params,
    @Default(1) int page,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadMoreDone,
    @Default(0) int totalCount,
  }) = _BlockDataListModel;

  factory BlockDataListModel.fromJson(Map<String, dynamic> json) =>
      _$BlockDataListModelFromJson(json);
}
