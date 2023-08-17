import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_data_list_model.dart';

part 'content_like_user_list_response_model.freezed.dart';
part 'content_like_user_list_response_model.g.dart';

@freezed
class ContentLikeUserListResponseModel with _$ContentLikeUserListResponseModel {
  factory ContentLikeUserListResponseModel({
    required bool result,
    required String code,
    required ContentLikeUserListDataListModel data,
    String? message,
  }) = _ContentLikeUserListResponseModel;

  factory ContentLikeUserListResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$ContentLikeUserListResponseModelFromJson(json);
}
