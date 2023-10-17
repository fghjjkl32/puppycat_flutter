import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/single_walk/single_walk_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_selected_pet_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/walk/walk_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'walk_state_provider.g.dart';

enum WalkStatus {
  idle,
  walking,
}

@Riverpod(keepAlive: true)
class WalkState extends _$WalkState {
  String _walkUuid = '';
  String _walkStartDate = '';
  @override
  WalkStatus build() {
    return WalkStatus.idle;
  }

  Future<int> getTodayWalkCount() async {
    final walkRepository = WalkRepository(dio: ref.read(dioProvider));
    try {
      final userInfo = ref.read(userInfoProvider).userModel;
      print('userModel $userInfo');
      final String memberUuid = ref
          .read(userInfoProvider)
          .userModel!
          .uuid!;
      var result = await walkRepository.getTodayWalkCount(memberUuid, false);
      print('walkCount $result');
      return result + 1;
    } catch(e) {
      print('getTodayWalkCount error $e');
      return 0;
    }
  }

  Future startWalk() async {
    final walkRepository = WalkRepository(dio: ref.read(dioProvider));
    try {
      final userInfo = ref.read(userInfoProvider).userModel;
      print('userModel $userInfo');
      final String memberUuid = ref
          .read(userInfoProvider)
          .userModel!
          .uuid!;

      final selectedPetList = ref.read(walkSelectedPetStateProvider);
      final String standardPet = ref.read(walkSelectedPetStateProvider.notifier).getFirstRegPet().uuid!;
      final List<String> petUuidList = selectedPetList.map((e) => e.uuid!).toList();

      var result = await walkRepository.startWalk(memberUuid, petUuidList, standardPet);
      _walkUuid = result.$1;
      _walkStartDate = result.$2;

    } catch(e) {
      print('startWalk error $e');
    }
  }

  Future stopWalk() async {
    final walkRepository = WalkRepository(dio: ref.read(dioProvider));
    try {
      final userInfo = ref.read(userInfoProvider).userModel;
      print('userModel $userInfo');
      final String memberUuid = ref
          .read(userInfoProvider)
          .userModel!
          .uuid!;

      final walkState = ref.read(singleWalkStateProvider);
      print('walkState $walkState');
      final lastWalkState = ref.read(singleWalkStateProvider).last;
      print('lastWalkState $lastWalkState');
      ///String memberUuid, String walkUuid, int steps, String startDate, double distance, Map<String, dynamic> petWalkInfo,

      var result = await walkRepository.stopWalk(memberUuid, _walkUuid, lastWalkState.walkCount, _walkStartDate, lastWalkState.distance, lastWalkState.calorie);
    } catch(e) {
      print('stopWalk error $e');
    }
  }
}
