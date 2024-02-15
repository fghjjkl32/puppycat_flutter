import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_enter_model.freezed.dart';
part 'chat_enter_model.g.dart';

@freezed
class ChatEnterModel with _$ChatEnterModel {
  factory ChatEnterModel({
    required String roomId,
    required String generateToken,
    List<String>? log,
  }) = _ChatEnterModel;

  factory ChatEnterModel.fromJson(Map<String, dynamic> json) => _$ChatEnterModelFromJson(json);
}
