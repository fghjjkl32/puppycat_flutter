import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/user_information/user_information_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/my_page/follow/follow_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/block/block_repository.dart';
import 'package:pet_mobile_social_flutter/repositories/user/user_info_repository.dart';
// import 'package:pet_mobile_social_flutter/repositories/my_page/user_information/user_information_repository.dart';
import 'package:riverpod/riverpod.dart';

final userInformationStateProvider = StateNotifierProvider<UserInformationStateNotifier, UserInformationItemModel>((ref) {
  return UserInformationStateNotifier(ref);
});

class UserInformationStateNotifier extends StateNotifier<UserInformationItemModel> {
  UserInformationStateNotifier(this.ref) : super(UserInformationItemModel());

  final Ref ref;

  final Map<String, UserInformationItemModel> userInformationStateMap = {};

  void getStateForUserInformation(String memberUuid) {
    state = userInformationStateMap[memberUuid] ?? UserInformationItemModel();
  }

  getInitUserInformation({
    required String memberUuid,
  }) async {
    print("memberUuidmemberUuid ${memberUuid}");

    try {
      final userInformationItemModel = await UserInfoRepository(dio: ref.read(dioProvider)).getUserInformation(memberUuid);

      state = userInformationItemModel;

      userInformationStateMap[memberUuid] = userInformationItemModel;

      ref.read(followUserStateProvider.notifier).setFollowState(memberUuid, userInformationItemModel.followState == 1);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      state = UserInformationItemModel();
    } catch (e) {
      print('getInitUserInformation error $e');
      state = UserInformationItemModel();
    }
  }

  Future<ResponseModel> postBlock({
    required String blockUuid,
  }) async {
    try {
      final result = await BlockRepository(dio: ref.read(dioProvider)).postBlock(
        blockUuid: blockUuid,
      );

      return result;
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
      throw apiException.toString();
    } catch (e) {
      print('searchBlockList error $e');
      rethrow;
    }
  }

  void updateFollowState() {
    state = state.copyWith(
      followState: 1,
      followerCnt: state.followerCnt! + 1,
    );
  }

  void updateUnFollowState() {
    state = state.copyWith(
      followState: 0,
      followerCnt: state.followerCnt! - 1,
    );
  }

  Future<void> updateBlockState() async {
    state = state.copyWith(
      blockedState: 1,
      followerCnt: 0,
      followCnt: 0,
    );
  }

  Future<void> updateUnBlockState(String memberUuid) async {
    state = state.copyWith(
      blockedState: 0,
      followerCnt: 0,
      followCnt: 0,
      followState: 0,
    );

    try {
      final userInformationItemModel = await UserInfoRepository(dio: ref.read(dioProvider)).getUserInformation(memberUuid);

      state = userInformationItemModel.copyWith(
        blockedState: 0,
        followState: 0,
      );
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('updateUnBlockState error $e');
    }
  }
}
