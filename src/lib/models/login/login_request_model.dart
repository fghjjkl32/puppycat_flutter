import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';

part 'login_request_model.g.dart';

@freezed
class LoginRequestModel with _$LoginRequestModel {
  factory LoginRequestModel({
    required String id,
    required String simpleId,
    @Default(1) int isSimple,
    required String simpleType,
    required String appKey,
    required String appVer,
    required int isBadge,
    @Default('puppycat.co.kr') String domain, // puppycat.co.kr  임시
    @Default('ko') String iso,
    required String fcmToken,
  }) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
}
