import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/comment/comment_data_list_model.dart';

part 'comment_response_model.freezed.dart';

part 'comment_response_model.g.dart';

@freezed
class CommentResponseModel with _$CommentResponseModel {
  factory CommentResponseModel({
    required bool result,
    required String code,
    required CommentDataListModel? data,
    String? message,
  }) = _CommentResponseModel;

  factory CommentResponseModel.fromJson(Map<String, dynamic> json) => _$CommentResponseModelFromJson(json);
}
