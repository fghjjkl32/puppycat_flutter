import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/my_page/setting/main_list_data.dart';
import 'package:pet_mobile_social_flutter/models/my_page/setting/setting_data_list_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/setting/sub_list_data.dart';
import 'package:pet_mobile_social_flutter/providers/api_error/api_error_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/my_page/setting/setting_repository.dart';

final settingStateProvider = StateNotifierProvider<SettingStateNotifier, SettingDataListModel>((ref) {
  return SettingStateNotifier(ref);
});

class SettingStateNotifier extends StateNotifier<SettingDataListModel> {
  SettingStateNotifier(this.ref) : super(const SettingDataListModel());

  final Ref ref;

  initSetting(
    memberIdx,
  ) async {
    try {
      final lists = await SettingRepository(dio: ref.read(dioProvider)).getSetting(memberIdx: memberIdx);

      if (lists == null) {
        return null;
      }
      Map<String, int> switchState = {
        "main_1": lists.data.mainList[0].state!,
        "main_2": lists.data.mainList[1].state!,
        "main_3": lists.data.mainList[2].state!,
        "sub_1_1": lists.data.subList[0].state!,
        "sub_1_2": lists.data.subList[1].state!,
        "sub_1_3": lists.data.subList[2].state!,
        "sub_1_4": lists.data.subList[3].state!,
        "sub_1_5": lists.data.subList[4].state!,
        "sub_1_6": lists.data.subList[5].state!,
        "sub_2_1": lists.data.mainList[1].state!,
        "sub_3_1": lists.data.mainList[2].state!,
      };

      state = state.copyWith(
        mainList: lists.data.mainList,
        subList: lists.data.subList,
        switchState: switchState,
      );
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('initSetting error $e');
    }
  }

  void updateSwitchState(String key, int value) {
    Map<String, int> newSwitchState = Map.from(state.switchState);

    newSwitchState[key] = value;

    if (key == 'main_1') {
      for (int i = 1; i <= 6; i++) {
        newSwitchState['sub_1_$i'] = newSwitchState[key]!;
        print(newSwitchState[key]);
      }
    } else if (key == 'main_2') {
      for (int i = 1; i <= 1; i++) {
        newSwitchState['sub_2_$i'] = newSwitchState[key]!;
      }
    } else if (key == 'main_3') {
      for (int i = 1; i <= 1; i++) {
        newSwitchState['sub_3_$i'] = newSwitchState[key]!;
      }
    }

    state = state.copyWith(switchState: newSwitchState);
  }

  putSetting({
    required int memberIdx,
    required Map<String, dynamic> body,
  }) async {
    try {
      await SettingRepository(dio: ref.read(dioProvider)).putSetting(memberIdx: memberIdx, body: body);
      await initSetting(memberIdx);
    } on APIException catch (apiException) {
      await ref.read(aPIErrorStateProvider.notifier).apiErrorProc(apiException);
    } catch (e) {
      print('initContentLikeUserList error $e');
    }
  }
}
