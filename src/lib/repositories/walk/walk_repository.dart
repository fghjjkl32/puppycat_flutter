import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
import 'package:pet_mobile_social_flutter/services/walk/walk_service.dart';

class WalkRepository {
  late final WalkService _walkService; // = PolicyService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;
  final String? baseUrl;

  WalkRepository({
    required this.dio,
    this.baseUrl,
  }) {
    _walkService = WalkService(dio, baseUrl: baseUrl ?? walkBaseUrl);
  }

  Future<int> getTodayWalkCount(String memberUuid, [bool isTogetherWalk = false]) async {
    ResponseModel responseModel = await _walkService.getTodayWalkCount(memberUuid, isTogetherWalk ? 1 : 0);

    if (responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    int walkCount = 0;
    try {
      walkCount = responseModel.data!['walkCnt'];
    } catch (e) {
      rethrow;
    }
    return walkCount;
  }

  Future<(String, String)> startWalk(String memberUuid, List<String> petUuidList, String standardPet, [bool isTogetherWalk = false]) async {
    Map<String, dynamic> body = {
      'memberUuid': memberUuid,
      'petUuidList': petUuidList,
      'standardPet': standardPet,
      'together': isTogetherWalk ? 1 : 0,
    };

    print('start Body $body');

    ResponseModel responseModel = await _walkService.startWalk(body);

    if (responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    try {
      print('walkUuid : ${responseModel.data!['walkUuid']}');
      print('startDate : ${responseModel.data!['startDate']}');
      return (responseModel.data!['walkUuid'].toString(), responseModel.data!['startDate'].toString());
    } catch (e) {
      rethrow;
    }
    // return walkCount;
  }

  Future stopWalk(String memberUuid, String walkUuid, int steps, String startDate, double distance, Map<String, dynamic> petWalkInfo, [bool isForce = false]) async {
    List<Map<String, dynamic>> petWalkInfoList = [];

    petWalkInfo.forEach((key, value) {
      Map<String, dynamic> petMap = {
        key: value,
      };

      petWalkInfoList.add(petMap);
    });

    Map<String, dynamic> body = {
      'memberUuid': memberUuid,
      'uuid': walkUuid,
      'step': steps,
      'startDate': startDate,
      'distance': distance,
      'petWalkInfo': petWalkInfoList,
      'isForce': isForce ? 1 : 0,
    };

    ResponseModel responseModel = await _walkService.stopWalk(body);

    if (responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }

    try {
      print('stop result : ${responseModel.result}');
    } catch (e) {
      rethrow;
    }
    // return walkCount;
  }

  ///walkUuid
  // memberUuid
  // data.gps
  // data.state
  // data.step
  // data.distance
  // data.calorie
  // data.petUuid
  // data.time

  Future sendWalkInfo(String memberUuid, String walkUuid, List<WalkStateModel> walkInfoList, [bool isFinished = false]) async {
    List dataList = [];
    for (var walkInfo in walkInfoList) {
      List<String> petUuidList = walkInfo.calorie.keys.toList();
      List calorieList = walkInfo.calorie.values.map((e) => e['calorie']).toList();

      String petUuids = petUuidList.join('&');
      String calorie = calorieList.join('&');

      Map<String, dynamic> data = {
        'gps': '${walkInfo.latitude}, ${walkInfo.longitude}',
        'state': isFinished ? '0' : '1',
        'step': walkInfo.walkCount.toString(),
        'distance': walkInfo.distance.toString(),
        'petUuid': petUuids,
        'calorie': calorie,
        'time': walkInfo.dateTime.toUtc().toString(),
      };

      dataList.add(data);
    }

    Map<String, dynamic> body = {
      'walkUuid': walkUuid,
      'memberUuid': memberUuid,
      'data': dataList,
    };

    print('waking Body $body');

    ResponseModel responseModel = await _walkService.sendWalkInfo(body);

    if (responseModel == null) {
      ///TODO
      ///throw로 할지 그냥 return null로 할지 생각해보기
      throw "error";
    }
  }
}
