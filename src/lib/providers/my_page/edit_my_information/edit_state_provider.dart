import 'package:image_picker/image_picker.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/edit_my_information/edit_my_information_state.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/authentication/auth_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/signUp/sign_up_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/user/my_info_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_state_provider.g.dart';

@Riverpod(keepAlive: true)
class EditState extends _$EditState {
  @override
  EditMyInformationState build() {
    return EditMyInformationState(
      authModel: null,
      myInfoModel: ref.read(myInfoStateProvider),
    );
  }

  void saveAuthModel() {
    state = state.copyWith(authModel: ref.read(authModelProvider.notifier).state);
  }

  void resetState() {
    state = state.copyWith(authModel: null, myInfoModel: ref.read(myInfoStateProvider));

    ref.watch(nickNameProvider.notifier).state = NickNameStatus.none;
  }

  Future<ResponseModel> putMyInfo({
    required UserInformationItemModel myInfoModel,
    required XFile? file,
    required String beforeNick,
    required bool isProfileImageDelete,
    required bool isPhoneNumberEdit,
  }) async {
    try {
      final result = await ref.read(userInfoRepositoryProvider(ref.read(dioProvider))).updateMyInfo(myInfoModel, file, beforeNick, isProfileImageDelete, isPhoneNumberEdit);

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('putMyInfo error $e');
      rethrow;
    }
  }
}
