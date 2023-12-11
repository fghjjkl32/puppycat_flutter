import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/models/sign_up/sign_up_auth_model.dart';
import 'package:pet_mobile_social_flutter/models/user/user_info_model.dart';

part 'edit_my_information_state.freezed.dart';
part 'edit_my_information_state.g.dart';

@freezed
class EditMyInformationState with _$EditMyInformationState {
  factory EditMyInformationState({
    SignUpAuthModel? authModel,
    UserInformationItemModel? myInfoModel,
  }) = _EditMyInformationState;

  factory EditMyInformationState.fromJson(Map<String, dynamic> json) => _$EditMyInformationStateFromJson(json);
}
