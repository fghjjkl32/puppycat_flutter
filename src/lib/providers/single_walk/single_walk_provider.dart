///TODO
///좌표 수신 On/Off
///walk_util에게 좌표 전송 후 결과값 처리
///Fila Manager에 데이터 전송 ?
///

import 'dart:async';

import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_selected_pet_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/walk/walk_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pet_mobile_social_flutter/common/util/walk_util.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';

part 'single_walk_provider.g.dart';

final naverMapControllerStateProvider = StateProvider<NaverMapController?>((ref) => null);



final singleWalkStatusStateProvider = StateProvider<WalkStatus>((ref) => WalkStatus.idle);

@Riverpod(keepAlive: true)
class SingleWalkState extends _$SingleWalkState {
  StreamSubscription<LocationData>? _locationDataCollectionStream;

  @override
  List<WalkStateModel> build() {
    return [];
  }

  void startLocationCollection(LocationData initLocationData, double petWeight) {
    stopLocationCollection();

    final selectedPetList = ref.read(walkSelectedPetStateProvider);
    final firstPet = ref.read(walkSelectedPetStateProvider.notifier).getFirstRegPet();
    print('firstPet $firstPet');

    _locationDataCollectionStream = Location().onLocationChanged.listen((LocationData currentLocation) {
      final WalkStateModel previousWalkStateModel;
      if (state.isEmpty) {
        previousWalkStateModel = WalkStateModel(
          dateTime: DateTime.now(),
          latitude: initLocationData.latitude!,
          longitude: initLocationData.longitude!,
          distance: 0,
          walkTime: 0,
          walkCount: 0,
          calorie: {},
        );
      } else {
        previousWalkStateModel = state.last;
      }

      final walkStateModel = WalkUtil.calcWalkStateValue(previousWalkStateModel, currentLocation, selectedPetList);
      state = [...state, walkStateModel];
    });

    ref.read(singleWalkStatusStateProvider.notifier).state = WalkStatus.walking;
  }

  void stopLocationCollection() {
    if (_locationDataCollectionStream != null) {
      _locationDataCollectionStream!.cancel();
    }

    state.clear();
    ref.read(singleWalkStatusStateProvider.notifier).state = WalkStatus.idle;
  }


}
