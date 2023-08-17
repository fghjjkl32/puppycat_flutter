import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_list_model.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/my_page/user_information/user_information_repository.dart';
import 'package:riverpod/riverpod.dart';

final myInformationStateProvider =
    StateNotifierProvider<MyInformationStateNotifier, UserInformationListModel>(
        (ref) {
  return MyInformationStateNotifier();
});

class MyInformationStateNotifier
    extends StateNotifier<UserInformationListModel> {
  MyInformationStateNotifier() : super(const UserInformationListModel());

  getInitUserInformation([
    memberIdx,
  ]) async {
    final lists = await UserInfoRepository()
        .getUserInformation(memberIdx, memberIdx);

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: false, list: lists.data.info);
  }
}
