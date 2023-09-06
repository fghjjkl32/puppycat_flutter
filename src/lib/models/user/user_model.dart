import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

enum LoginStatus {
  none,
  success, //페이지 이동
  failure, // 팝업 다이얼로그
  needSignUp, // 화면 전환
  restriction, // 팝업 다이얼로그
  withdrawalPending, // 바텀 시트 띄워
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
    required String refreshToken,
    required int isSimple,
    required String simpleType,
    required String accessToken,
    required String password,
    required String passwordConfirm,
    required int isBadge,
    @Default('') String? partner,
    String? ci,
    String? di,
    String? name,
    String? phone,
    String? birth,
    String? gender,
    String? profileImgUrl,
    String? introText,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
