import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/chat/chat_favorite_model.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'chat_favorite_data_list_model.freezed.dart';
part 'chat_favorite_data_list_model.g.dart';

@freezed
class ChatFavoriteDataListModel with _$ChatFavoriteDataListModel {
  factory ChatFavoriteDataListModel({
    required List<ChatFavoriteModel> list,
    required ParamsModel params,
    String? message,
  }) = _ChatFavoriteDataListModel;

  factory ChatFavoriteDataListModel.fromJson(Map<String, dynamic> json) => _$ChatFavoriteDataListModelFromJson(json);
}
