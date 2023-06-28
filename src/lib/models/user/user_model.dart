

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum LoginStatus {
  none,
  success,
  failure,
  needSignUp,
  restriction,
  withdrawalPending,
  fourteen,
}

@freezed
class UserModel with _$UserModel {
  factory UserModel({
    required LoginStatus loginStatus,
    required int idx,
    @Default('') String appKey,
    required String nick,
    required String id, //email
    required String simpleId,
    String? name,
    String? gender,
    String? birth,
    String? phone,
    required String refreshToken,
    required int isSimple,
    required String simpleType,
    required String accessToken,
    required String password,
    required String passwordConfirm,
    @Default('') String? partner,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}