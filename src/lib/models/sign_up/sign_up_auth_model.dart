
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_auth_model.freezed.dart';
part 'sign_up_auth_model.g.dart';

@freezed
class SignUpAuthModel with _$SignUpAuthModel {
  factory SignUpAuthModel({
    String? ci,
    String? di,
    String? gender,
    String? name,
    String? phone,
    String? birth,
  }) = _SignUpAuthModel;

  factory SignUpAuthModel.fromJson(Map<String, dynamic> json) => _$SignUpAuthModelFromJson(json);
}