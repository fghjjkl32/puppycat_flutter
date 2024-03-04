import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/params_model.dart';

part 'chat_enter_model.freezed.dart';
part 'chat_enter_model.g.dart';

@freezed
class ChatEnterModel with _$ChatEnterModel {
  factory ChatEnterModel({
    required String roomUuid,
    required String generateToken,
    List<String>? log,
    Map<String, dynamic>? memberScore,
    ParamsModel? params,
  }) = _ChatEnterModel;

  factory ChatEnterModel.fromJson(Map<String, dynamic> json) => _$ChatEnterModelFromJson(json);
}
