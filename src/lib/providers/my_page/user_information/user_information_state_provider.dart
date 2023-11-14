import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_list_model.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/block/block_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/my_page/user_information/user_information_repository.dart';
import 'package:riverpod/riverpod.dart';

final userInformationStateProvider = StateNotifierProvider<UserInformationStateNotifier, UserInformationListModel>((ref) {
  return UserInformationStateNotifier(ref);
});

class UserInformationStateNotifier extends StateNotifier<UserInformationListModel> {
  UserInformationStateNotifier(this.ref) : super(const UserInformationListModel());

  final Ref ref;

  final Map<int, UserInformationListModel> userInformationStateMap = {};

  void getStateForUserInformation(int userIdx) {
    state = userInformationStateMap[userIdx] ?? const UserInformationListModel();
  }

  getInitUserInformation([
    loginMemberIdx,
    memberIdx,
  ]) async {
    final lists = await UserInfoRepository(dio: ref.read(dioProvider)).getUserInformation(loginMemberIdx, memberIdx);

    if (lists == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: false, list: lists.data.info);

    userInformationStateMap[memberIdx] = state.copyWith(isLoading: false, list: lists.data.info);

    ref.read(followUserStateProvider.notifier).setFollowState(memberIdx!, state.list[0].followState == 1);
  }

  Future<ResponseModel> postBlock({
    required memberIdx,
    required blockIdx,
  }) async {
    final result = await BlockRepository(dio: ref.read(dioProvider)).postBlock(
      memberIdx: memberIdx,
      blockIdx: blockIdx,
    );

    return result;
  }

  void updateFollowState() {
    state = state.copyWith(list: [state.list[0].copyWith(followState: 1, followerCnt: state.list[0].followerCnt! + 1)]);
  }

  void updateUnFollowState() {
    state = state.copyWith(list: [state.list[0].copyWith(followState: 0, followerCnt: state.list[0].followerCnt! - 1)]);
  }

  Future<void> updateBlockState() async {
    state = state.copyWith(list: [state.list[0].copyWith(blockedState: 1, followerCnt: 0, followCnt: 0)]);
  }

  Future<void> updateUnBlockState(loginMemberIdx, memberIdx) async {
    state = state.copyWith(list: [
      state.list[0].copyWith(
        blockedState: 0,
        followerCnt: 0,
        followCnt: 0,
        followState: 0,
      )
    ]);

    final lists = await UserInfoRepository(dio: ref.read(dioProvider)).getUserInformation(loginMemberIdx, memberIdx);

    state = state.copyWith(list: [
      state.list[0].copyWith(
        blockedState: 0,
        followerCnt: lists.data.info[0].followerCnt,
        followCnt: lists.data.info[0].followCnt,
        followState: 0,
      )
    ]);
  }
}
