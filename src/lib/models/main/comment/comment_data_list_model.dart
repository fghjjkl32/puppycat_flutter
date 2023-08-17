import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_data.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'comment_data_list_model.freezed.dart';
part 'comment_data_list_model.g.dart';

@freezed
class CommentDataListModel with _$CommentDataListModel {
  const factory CommentDataListModel({
    @Default([]) List<CommentData> list,
    ParamsModel? params,
    @Default(1) int page,
    @Default(true) bool isLoading,
    @Default(false) bool isLoadMoreError,
    @Default(false) bool isLoadMoreDone,
    @Default(0) int totalCount,
  }) = _CommentDataListModel;

  factory CommentDataListModel.fromJson(Map<String, dynamic> json) =>
      _$CommentDataListModelFromJson(json);
}
