import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/my_page/user_information/user_information_repository.dart';
import 'package:riverpod/riverpod.dart';

final myInformationStateProvider = StateNotifierProvider<MyInformationStateNotifier, UserInformationListModel>((ref) {
  return MyInformationStateNotifier(ref);
});

class MyInformationStateNotifier extends StateNotifier<UserInformationListModel> {
  MyInformationStateNotifier(this.ref) : super(const UserInformationListModel());

  final Ref ref;

  getInitUserInformation([
    memberIdx,
  ]) async {
    try {
      final lists = await UserInfoRepository(dio: ref.read(dioProvider)).getUserInformation(memberIdx, memberIdx);

      if (lists == null) {
        state = state.copyWith(isLoading: false);

        return;
      }

      state = state.copyWith(isLoading: false, list: lists.data!.info);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      print('getInitUserInformation error $e');
      state = state.copyWith(isLoading: false);
    }
  }
}
