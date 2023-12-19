import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';

part 'chat_favorite_response_model.freezed.dart';

part 'chat_favorite_response_model.g.dart';

@freezed
class ChatFavoriteResponseModel with _$ChatFavoriteResponseModel {
  factory ChatFavoriteResponseModel({
    required bool result,
    required String code,
    required ChatFavoriteDataListModel? data,
    String? message,
  }) = _ChatFavoriteResponseModel;

  factory ChatFavoriteResponseModel.fromJson(Map<String, dynamic> json) => _$ChatFavoriteResponseModelFromJson(json);
}
