

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required String id, //email
    required String simpleId,
    String? name,
    String? gender,
    String? birth,
    String? phone,
    required String refreshToken,
    required String isSimple,
    required String simpleType,
    required String accessToken,
    required String password,
    required String passwordConfirm,
    String? partner,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}