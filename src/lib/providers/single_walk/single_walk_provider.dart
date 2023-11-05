///TODO
///좌표 수신 On/Off
///walk_util에게 좌표 전송 후 결과값 처리
///Fila Manager에 데이터 전송 ?
///

import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/controller/walk_cache/walk_cache_controller.dart';
import 'package:pet_mobile_social_flutter/providers/login/login_state_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_selected_pet_provider.dart';
import 'package:pet_mobile_social_flutter/providers/walk/walk_state_provider.dart';
import 'package:pet_mobile_social_flutter/repositories/walk/walk_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pet_mobile_social_flutter/common/util/walk_util.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'single_walk_provider.g.dart';

final naverMapControllerStateProvider = StateProvider<NaverMapController?>((ref) => null);

// final singleWalkStatusStateProvider = StateProvider<WalkStatus>((ref) => WalkStatus.idle);

@Riverpod(keepAlive: true)
class SingleWalkState extends _$SingleWalkState {
  // StreamSubscription<LocationData>? _locationDataCollectionStream;
  StreamSubscription<Map<String, dynamic>?>? _backgroundLocationDataStream;

  @override
  List<WalkStateModel> build() {
    return [];
  }

  void startBackgroundLocation(Position initLocationData) async {
    final selectedPetList = ref.read(walkSelectedPetStateProvider);

    _backgroundLocationDataStream = FlutterBackgroundService().on('walk_update').listen((event) async {
      if(event == null) {
        return;
      }

      WalkStateModel walkStateModel;
      try {
        walkStateModel = WalkStateModel.fromJson(event['walkStateModel']);
      } catch(e) {
        print('background walkStateModel error $e');
        walkStateModel = WalkStateModel(
          dateTime: DateTime.now(),
          latitude: initLocationData.latitude,
          longitude: initLocationData.longitude,
          distance: 0,
          walkTime: 0,
          walkCount: 0,
          calorie: {},
          petList: selectedPetList,
        );
      }
      print('walkStateModel $walkStateModel');
      state = [...state, walkStateModel];
      // if (state.isNotEmpty) {
      //   await ref.read(walkStateProvider.notifier).sendWalkInfo(state.last);
      // }
      // await WalkCacheController.writeWalkInfo(walkStateModel, _walk);
    });

    // ref.read(singleWalkStatusStateProvider.notifier).state = WalkStatus.walking;
  }

  Future stopBackgroundLocation() async {
    // ref.read(singleWalkStatusStateProvider.notifier).state = WalkStatus.idle;

    if (_backgroundLocationDataStream != null) {
      _backgroundLocationDataStream!.cancel();
    }

    // if (state.isNotEmpty) {
    //   await ref.read(walkStateProvider.notifier).sendWalkInfo(state.last, true);
    // }
  }

  // void startLocationCollection(LocationData initLocationData) async {
  //   stopLocationCollection();
  //
  //   final selectedPetList = ref.read(walkSelectedPetStateProvider);
  //
  //   _locationDataCollectionStream = Location().onLocationChanged.listen((LocationData currentLocation) async {
  //     final WalkStateModel previousWalkStateModel;
  //     if (state.isEmpty) {
  //       previousWalkStateModel = WalkStateModel(
  //         dateTime: DateTime.now(),
  //         latitude: initLocationData.latitude!,
  //         longitude: initLocationData.longitude!,
  //         distance: 0,
  //         walkTime: 0,
  //         walkCount: 0,
  //         calorie: {},
  //       );
  //     } else {
  //       previousWalkStateModel = state.last;
  //     }
  //
  //     if(ref.read(singleWalkStatusStateProvider) == WalkStatus.idle) {
  //       return;
  //     }
  //
  //     final walkStateModel = WalkUtil.calcWalkStateValue(previousWalkStateModel, currentLocation, selectedPetList);
  //     state = [...state, walkStateModel];
  //     if (state.isNotEmpty) {
  //       await ref.read(walkStateProvider.notifier).sendWalkInfo(state.last);
  //     }
  //   });
  //
  //
  //
  //   ref.read(singleWalkStatusStateProvider.notifier).state = WalkStatus.walking;
  // }
  //
  // Future stopLocationCollection() async {
  //   ref.read(singleWalkStatusStateProvider.notifier).state = WalkStatus.idle;
  //
  //   if (_locationDataCollectionStream != null) {
  //     _locationDataCollectionStream!.cancel();
  //   }
  //
  //   if (state.isNotEmpty) {
  //     await ref.read(walkStateProvider.notifier).sendWalkInfo(state.last, true);
  //   }
  //
  //   // state.clear();
  //   // ref.read(walkSelectedPetStateProvider.notifier).state.clear();
  // }
}
