import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_data_list_model.dart';

part 'feed_response_model.freezed.dart';
part 'feed_response_model.g.dart';

@freezed
class FeedResponseModel with _$FeedResponseModel {
  factory FeedResponseModel({
    required bool result,
    required String code,
    required FeedDataListModel data,
    String? message,
  }) = _FeedResponseModel;

  factory FeedResponseModel.fromJson(Map<String, dynamic> json) =>
      _$FeedResponseModelFromJson(json);
}
