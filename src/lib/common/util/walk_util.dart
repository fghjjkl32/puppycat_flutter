import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:location/location.dart';
import 'package:pet_mobile_social_flutter/models/my_page/my_pet/my_pet_list/my_pet_item_model.dart';
import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';

///TODO
///거리 계산
///산책 시간 계산
///걸음수 계산
///칼로리 계산
///    required String dateTime,
///     required double latitude,
///     required double longitude,
///     required double distance,
///     required double walkTime,
///     required int walkCount,
///     required double calorie,

class WalkUtil {
  static WalkStateModel calcWalkStateValue(WalkStateModel previousWalkStateModel, LocationData currentLocationData, List<MyPetItemModel> petList) {
    LocationData previousLocationData = LocationData.fromMap({
      'latitude': previousWalkStateModel.latitude,
      'longitude': previousWalkStateModel.longitude,
    });

    final distance = calcDistance(previousLocationData, currentLocationData);
    final walkCount = calcWalkCount(previousWalkStateModel.distance + distance);
    final walkTime = calcWalkTime(previousWalkStateModel.dateTime);
    // final calorie = calcCalorie(petWeight, walkTime);


    return WalkStateModel(
      dateTime: DateTime.now(),
      latitude: currentLocationData.latitude ?? previousLocationData.latitude!,
      longitude: currentLocationData.longitude ?? previousLocationData.longitude!,
      distance: previousWalkStateModel.distance + distance,
      walkTime: previousWalkStateModel.walkTime + walkTime,
      walkCount: walkCount,
      calorie: calcALlCalorie(petList, previousWalkStateModel.walkTime + walkTime),
    );
  }

  static double calcDistance(LocationData previousLocationData, LocationData currentLocationData) {
    ///NOTE
    ///latitude, longitude가  null 인 경우는 없다고 가정
    ///이 함수 호출되기 전에 앞에서 이미 검증했을테니 ..
    NLatLng preLocation = NLatLng(previousLocationData.latitude!, previousLocationData.longitude!);
    final distance = preLocation.distanceTo(NLatLng(currentLocationData.latitude!, currentLocationData.longitude!));
    return distance / 1000;
  }

  static int calcWalkCount(double distance) {
    ///NOTE
    ///기획 + 운영에서 찾아둔 공식 적용
    /// https://www.notion.so/f569eb49de7546738580945fc79379a2?pvs=4
    return ((distance * 1000) * 100 / 60).round();
  }

  static double calcCalorie(double petWeight, int walkTime) {
    final cal = 1.766 * petWeight.toDouble() * (walkTime / 3600000);
    return cal;
  }

  static Map<String, dynamic> calcALlCalorie(List<MyPetItemModel> petList, int walkTime) {
    final walkTimeH = (walkTime / 3600000);
    final Map<String, dynamic> resultMap = {};

    for (var element in petList) {
      print('element.uuid ${element.uuid}');
      final weight = element.weight ?? 1.0;
      final cal = 1.766 * weight * walkTimeH;
      Map<String, double> calorieMap = {
        'calorie' : cal,
      };
      resultMap[element.uuid ?? element.idx!.toString()] = calorieMap;
    }

    return resultMap;
  }

  static int calcWalkTime(DateTime previousWalkDateTime) {
    final currentDateTime = DateTime.now();
    Duration difference = currentDateTime.difference(previousWalkDateTime);
    int milliseconds = difference.inMilliseconds.abs();

    return milliseconds;
  }
}
