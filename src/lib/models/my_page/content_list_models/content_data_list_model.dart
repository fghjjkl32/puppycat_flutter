import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_contents/content_image_data.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'content_data_list_model.freezed.dart';
part 'content_data_list_model.g.dart';

@freezed
class ContentDataListModel with _$ContentDataListModel {
  const factory ContentDataListModel({
    @Default([]) List<ContentImageData> list,
    ParamsModel? params,
    @Default("0") String totalCnt,
    @Default(1) int page,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadMoreDone,
    @Default(0) int totalCount,
  }) = _ContentDataListModel;

  factory ContentDataListModel.fromJson(Map<String, dynamic> json) =>
      _$ContentDataListModelFromJson(json);
}
