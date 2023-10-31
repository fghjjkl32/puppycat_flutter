import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/controller/walk_cache/walk_cache_controller.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_result_state/walk_result_state_response_model.dart';
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
  walkEndedWithoutLog,
  finished,
}

final walkStatusStateProvider = StateProvider<WalkStatus>((ref) => WalkStatus.idle);
final walkPathImgStateProvider = StateProvider<File?>((ref) => null);
final isNavigatedFromMapProvider = StateProvider<bool>((ref) => false);

@Riverpod(keepAlive: true)
class WalkState extends _$WalkState {
  String _walkUuid = '';
  String _walkStartDate = '';
  List<WalkStateModel> _walkInfoList = [];

  String get walkUuid => _walkUuid;

  @override
  WalkStatus build() {
    return WalkStatus.idle;
  }

  Future<int> getTodayWalkCount() async {
    final walkRepository = WalkRepository(dio: ref.read(dioProvider));
    try {
      final userInfo = ref.read(userInfoProvider).userModel;
      print('userModel $userInfo');
      final String memberUuid = ref.read(userInfoProvider).userModel!.uuid!;
      var result = await walkRepository.getTodayWalkCount(memberUuid, false);
      print('walkCount $result');
      return result;
    } catch (e) {
      print('getTodayWalkCount error $e');
      return 0;
    }
  }

  Future<String> startWalk() async {
    final walkRepository = WalkRepository(dio: ref.read(dioProvider));
    try {
      final userInfo = ref.read(userInfoProvider).userModel;
      print('userModel $userInfo');
      final String memberUuid = ref.read(userInfoProvider).userModel!.uuid!;

      final selectedPetList = ref.read(walkSelectedPetStateProvider);
      final String standardPet = ref.read(walkSelectedPetStateProvider.notifier).getFirstRegPet().uuid!;
      final List<String> petUuidList = selectedPetList.map((e) => e.uuid!).toList();

      var result = await walkRepository.startWalk(memberUuid, petUuidList, standardPet);
      _walkUuid = result.$1;
      _walkStartDate = result.$2;
      ref.read(walkStatusStateProvider.notifier).state = WalkStatus.walking;

      if (_walkUuid.isEmpty) {
        return '';
      }

      if (_walkStartDate.isEmpty) {
        _walkStartDate = DateTime.now().toString();
      }

      // ref.listen(singleWalkStateProvider, (previous, next) async {
      //   if (next.isEmpty) {
      //     return;
      //   }
      //   await WalkCacheController.writeWalkInfo(next.last, _walkUuid);
      // });

      return _walkUuid;
    } catch (e) {
      print('startWalk error $e');
      return '';
    }
  }

  Future<String> stopWalk() async {
    final walkRepository = WalkRepository(dio: ref.read(dioProvider));
    final mapController = ref.read(naverMapControllerStateProvider);
    try {
      final userInfo = ref.read(userInfoProvider).userModel;
      print('userModel $userInfo');
      final String memberUuid = ref.read(userInfoProvider).userModel!.uuid!;

      final walkState = ref.read(singleWalkStateProvider);
      print('walkState $walkState');

      if (walkState.isEmpty) {
        walkState.add(WalkStateModel(
          dateTime: DateTime.now(),
          latitude: 37.555759,
          longitude: 126.972939,
          distance: 0,
          walkTime: 0,
          walkCount: 0,
          calorie: {},
        ));
      }

      final lastWalkState = ref.read(singleWalkStateProvider).last;
      print('lastWalkState $lastWalkState');

      ///String memberUuid, String walkUuid, int steps, String startDate, double distance, Map<String, dynamic> petWalkInfo,

      // if(_walkInfoList.isNotEmpty) {
      final walkInfoList = await WalkCacheController.readWalkInfo('${walkUuid}_local');
      // await walkRepository.sendWalkInfo(memberUuid, walkUuid, walkInfoList, true);
      sendWalkInfo(walkInfoList, true);
      // }
      // await WalkCacheController.writeWalkInfo(lastWalkState, _walkUuid);

      try {
        if (mapController != null) {
          List<NLatLng> routeList = walkState.map((e) => NLatLng(e.latitude, e.longitude)).toList();
          final bounds = NLatLngBounds.from(routeList);
          final cameraUpdateWithPadding = NCameraUpdate.fitBounds(bounds, padding: const EdgeInsets.all(50));

          await mapController.updateCamera(cameraUpdateWithPadding).then((value) async {
            final screenShot = await mapController.takeSnapshot(showControls: false);
            // final tempDir = await getTemporaryDirectory();
            // await screenShot.rename('$tempDir/$_walkUuid.jpg');
            ref.read(walkPathImgStateProvider.notifier).state = screenShot;
            mapController.clearOverlays(type: NOverlayType.pathOverlay);
          });
        }
      } catch (e) {
        print('screenshot error $e');
      }

      if (_walkStartDate.isEmpty) {
        _walkStartDate = DateTime.now().toString();
      }

      var result = await walkRepository.stopWalk(memberUuid, _walkUuid, lastWalkState.walkCount, _walkStartDate, lastWalkState.distance, lastWalkState.calorie);

      ref.read(singleWalkStateProvider.notifier).state.clear();
      ref.read(walkSelectedPetStateProvider.notifier).state.clear();

      ref.read(walkStatusStateProvider.notifier).state = WalkStatus.finished;
      print('stop walk uuid : $_walkUuid');
      return _walkUuid;
    } catch (e) {
      print('stopWalk error $e');
      return '';
    }
  }

  Future sendWalkInfo(List<WalkStateModel> walkInfoList, [bool isFinished = false]) async {
    final walkRepository = WalkRepository(dio: ref.read(dioProvider), baseUrl: walkGpsBaseUrl);
    // final walkRepository = WalkRepository(dio: ref.read(dioProvider), baseUrl: 'https://pet-walk-dev-gps.devlabs.co.kr');

    try {
      // if (!_walkInfoList.contains(walkInfo)) {
      //   _walkInfoList.add(walkInfo);
      // }
      //
      // if (_walkInfoList.length < 20 && !isFinished) {
      //   print('_walkInfoList.length ${_walkInfoList.length}');
      //   return;
      // }

      final userInfo = ref.read(userInfoProvider).userModel;
      print('userModel $userInfo');
      final String memberUuid = ref.read(userInfoProvider).userModel!.uuid!;

      await walkRepository.sendWalkInfo(memberUuid, _walkUuid, walkInfoList, isFinished).then((value) => _walkInfoList.clear());
    } catch (e) {
      print('sendWalkInfo error $e');
    }
  }

  Future<WalkResultStateResponseModel> getWalkResultState(String memberUuid) async {
    final walkRepository = WalkRepository(dio: ref.read(dioProvider));

    WalkResultStateResponseModel walkResult = await walkRepository.getWalkResultState(memberUuid: memberUuid);

    final result = walkResult.data.list;
    if (!result.isRegistWalk! && !result.isEndWalk!) {
      ref.read(walkStatusStateProvider.notifier).state = WalkStatus.walking;
      _walkUuid = result.walkUuid!;
    } else if (result.isEndWalk!) {
      ref.read(walkStatusStateProvider.notifier).state = WalkStatus.walkEndedWithoutLog;
      _walkUuid = result.walkUuid!;
    } else {
      ref.read(walkStatusStateProvider.notifier).state = WalkStatus.idle;
    }
    return walkResult;
  }
}
