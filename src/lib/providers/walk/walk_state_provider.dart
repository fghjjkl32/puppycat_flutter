import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/single_walk/single_walk_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_selected_pet_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/walk/walk_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'walk_state_provider.g.dart';

enum WalkStatus {
  idle,
  walking,
}

@Riverpod(keepAlive: true)
class WalkState extends _$WalkState {
  String _walkUuid = '';
  String _walkStartDate = '';
  List<WalkStateModel> _walkInfoList = [];
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
      return result;
    } catch(e) {
      print('getTodayWalkCount error $e');
      return 0;
    }
  }

  Future<String> startWalk() async {
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

      if(_walkUuid.isEmpty) {
        return '';
      }

      if(_walkStartDate.isEmpty) {
        _walkStartDate = DateTime.now().toString();
      }

      // CookieJar cookieJar = GetIt.I<CookieJar>();
      // var cookies = await cookieJar.loadForRequest(Uri.parse(baseUrl));
      // Map<String, dynamic> cookieMap = {};
      // for (var cookie in cookies) {
      //   cookieMap[cookie.name] = cookie.value;
      // }

      // FlutterBackgroundService().invoke("setAsForeground");
      // FlutterBackgroundService().invoke('setData', {
      //   'memberUuid' : memberUuid,
      //   'walkUuid' : _walkUuid,
      //    'cookieMap' : cookieMap,
      // });
      // FlutterBackgroundService().startService();


      return _walkUuid;
    } catch(e) {
      print('startWalk error $e');
      return '';
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

      if(_walkInfoList.isNotEmpty) {
        sendWalkInfo(lastWalkState, true);
      }
      var result = await walkRepository.stopWalk(memberUuid, _walkUuid, lastWalkState.walkCount, _walkStartDate, lastWalkState.distance, lastWalkState.calorie);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.reload();
      await preferences.setString('memberUuid', '');
      await preferences.setString('walkUuid', '');

      ref.read(singleWalkStateProvider.notifier).state.clear();
      ref.read(walkSelectedPetStateProvider.notifier).state.clear();
    } catch(e) {
      print('stopWalk error $e');
    }
  }
  Future sendWalkInfo(WalkStateModel walkInfo, [bool isFinished = false]) async {
    final walkRepository = WalkRepository(dio: ref.read(dioProvider), baseUrl: 'https://walk-gps.pcstg.co.kr/');
    // final walkRepository = WalkRepository(dio: ref.read(dioProvider), baseUrl: 'https://pet-walk-dev-gps.devlabs.co.kr');

    try {
      if(!_walkInfoList.contains(walkInfo)) {
        _walkInfoList.add(walkInfo);
      }

      if(_walkInfoList.length < 20 && !isFinished) {
        print('_walkInfoList.length ${_walkInfoList.length}');
        return;
      }

      final userInfo = ref.read(userInfoProvider).userModel;
      print('userModel $userInfo');
      final String memberUuid = ref.read(userInfoProvider).userModel!.uuid!;

      await walkRepository.sendWalkInfo(memberUuid, _walkUuid, _walkInfoList, isFinished).then((value) => _walkInfoList.clear());
    } catch(e) {
      print('sendWalkInfo error $e');
    }
  }
}
