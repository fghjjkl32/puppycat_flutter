///NOTE
///2023.11.14.
///산책하기 보류로 전체 주석 처리
// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get_it/get_it.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pet_mobile_social_flutter/config/constanst.dart';
// import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
// import 'package:pet_mobile_social_flutter/models/policy/policy_item_model.dart';
// import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
// import 'package:pet_mobile_social_flutter/models/walk/walk_info_model.dart';
// import 'package:pet_mobile_social_flutter/models/walk/walk_result_state/walk_result_state_item_model.dart';
// import 'package:pet_mobile_social_flutter/models/walk/walk_result_state/walk_result_state_list_model.dart';
// import 'package:pet_mobile_social_flutter/models/walk/walk_result_state/walk_result_state_response_model.dart';
// import 'package:pet_mobile_social_flutter/services/walk/walk_service.dart';
//
// class WalkRepository {
//   late final WalkService _walkService; // = PolicyService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);
//
//   final Dio dio;
//   final String? baseUrl;
//
//   WalkRepository({
//     required this.dio,
//     this.baseUrl,
//   }) {
//     _walkService = WalkService(dio, baseUrl: baseUrl ?? walkBaseUrl);
//   }
//
//   Future<int> getTodayWalkCount(String memberUuid, [bool isTogetherWalk = false]) async {
//     ResponseModel responseModel = await _walkService.getTodayWalkCount(memberUuid, isTogetherWalk ? 1 : 0);
//
//     if (responseModel == null) {
//       ///TODO
//       ///throw로 할지 그냥 return null로 할지 생각해보기
//       throw "error";
//     }
//
//     int walkCount = 0;
//     try {
//       walkCount = responseModel.data!['walkCnt'];
//     } catch (e) {
//       rethrow;
//     }
//     return walkCount;
//   }
//
//   Future<WalkResultStateResponseModel> getWalkResultState({
//     required String memberUuid,
//   }) async {
//     WalkResultStateResponseModel? responseModel = await _walkService.getWalkResultState(memberUuid);
//
//     if (responseModel == null) {
//       return WalkResultStateResponseModel(
//         result: false,
//         code: "",
//         data: WalkResultStateListModel(
//           list: WalkResultStateItemModel(),
//         ),
//         message: "",
//       );
//     }
//
//     return responseModel;
//   }
//
//   Future<(String, String)> startWalk(String memberUuid, List<String> petUuidList, String standardPet, [bool isTogetherWalk = false]) async {
//     Map<String, dynamic> body = {
//       'memberUuid': memberUuid,
//       'petUuidList': petUuidList,
//       'standardPet': standardPet,
//       'together': isTogetherWalk ? 1 : 0,
//     };
//
//     print('start Body $body');
//
//     ResponseModel responseModel = await _walkService.startWalk(body);
//
//     if (responseModel == null) {
//       ///TODO
//       ///throw로 할지 그냥 return null로 할지 생각해보기
//       throw "error";
//     }
//
//     try {
//       print('walkUuid : ${responseModel.data!['walkUuid']}');
//       print('startDate : ${responseModel.data!['startDate']}');
//       return (responseModel.data!['walkUuid'].toString(), responseModel.data!['startDate'].toString());
//     } catch (e) {
//       rethrow;
//     }
//     // return walkCount;
//   }
//
//   Future<bool> stopWalk(String memberUuid, String walkUuid, int steps, String startDate, double distance, Map<String, dynamic> petWalkInfo, [bool isForce = false]) async {
//     List<Map<String, dynamic>> petWalkInfoList = [];
//
//     petWalkInfo.forEach((key, value) {
//       Map<String, dynamic> petMap = {
//         key: value,
//       };
//
//       petWalkInfoList.add(petMap);
//     });
//
//     Map<String, dynamic> body = {
//       'memberUuid': memberUuid,
//       'uuid': walkUuid,
//       'step': steps,
//       'startDate': startDate,
//       'distance': distance,
//       'petWalkInfo': petWalkInfoList,
//       'isForce': isForce ? 1 : 0,
//     };
//
//     ResponseModel responseModel = await _walkService.stopWalk(body);
//
//     if (responseModel == null) {
//       ///TODO
//       ///throw로 할지 그냥 return null로 할지 생각해보기
//       throw "error";
//     }
//
//     try {
//       print('stop result : ${responseModel.result}');
//       return responseModel.result;
//     } catch (e) {
//       // rethrow;
//       print('stopWalk error $e');
//       return false;
//     }
//     // return walkCount;
//   }
//
//   ///walkUuid
//   // memberUuid
//   // data.gps
//   // data.state
//   // data.step
//   // data.distance
//   // data.calorie
//   // data.petUuid
//   // data.time
//
//   Future sendWalkInfo(String memberUuid, String walkUuid, List<WalkStateModel> walkInfoList, [bool isFinished = false]) async {
//     List dataList = [];
//     for (var walkInfo in walkInfoList) {
//       List<String> petUuidList = walkInfo.calorie.keys.toList();
//       List calorieList = walkInfo.calorie.values.map((e) => e['calorie']).toList();
//
//       String petUuids = petUuidList.join('&');
//       String calorie = calorieList.join('&');
//
//       Map<String, dynamic> data = {
//         // 'gps': '${walkInfo.latitude}, ${walkInfo.longitude}',
//         'latitude' : walkInfo.latitude.toString(),
//         'longitude' : walkInfo.longitude.toString(),
//         // 'state': isFinished ? '0' : '1',
//         'step': walkInfo.walkCount.toString(),
//         'distance': walkInfo.distance.toString(),
//         'petUuid': petUuids,
//         'calorie': calorie,
//         'time': DateFormat('yyyy-MM-dd hh:mm:ss').format(walkInfo.dateTime.toUtc()),
//       };
//
//       print('DateTime.now() ${walkInfo.dateTime}');
//       print('DateTime.now() ${DateTime.now().toUtc()}');
//       print('walkInfo.dateTime.toUtc() ${walkInfo.dateTime.toUtc()}');
//       dataList.add(data);
//     }
//
//     Map<String, dynamic> body = {
//       'walkUuid': walkUuid,
//       'memberUuid': memberUuid,
//       'data': dataList,
//     };
//
//
//     print('waking Body $body');
//
//
//     ResponseModel responseModel = await _walkService.sendWalkInfo(body);
//
//     if (responseModel == null) {
//       ///TODO
//       ///throw로 할지 그냥 return null로 할지 생각해보기
//       throw "sendWalkInfo error";
//     }
//
//     final tempDir = await getTemporaryDirectory();
//     File tempFile = File('${tempDir.path}/sendWalkInfo.txt');
//
//     tempFile.writeAsStringSync(DateTime.now().toString());
//     tempFile.writeAsStringSync(body.toString());
//     tempFile.writeAsStringSync(responseModel.toString());
//     tempFile.writeAsStringSync('--------------------------');
//
//
//     print('sendWalkInfo log $responseModel');
//   }
//
//   ///Background용
//   Future sendWalkInfoByDataList(String memberUuid, String walkUuid, List<Map<String, dynamic>> dataList, [bool isFinished = false]) async {
//     Map<String, dynamic> body = {
//       'walkUuid': walkUuid,
//       'memberUuid': memberUuid,
//       'data': dataList,
//     };
//
//     print('waking Body $body');
//
//     ResponseModel responseModel = await _walkService.sendWalkInfo(body);
//
//     if (responseModel == null) {
//       ///TODO
//       ///throw로 할지 그냥 return null로 할지 생각해보기
//       throw "error";
//     }
//   }
//
//   Future<bool> getWalkState(String memberUuid, String walkUuid) async {
//     final walkStateResult = await _walkService.getWalkState(memberUuid, walkUuid);
//
//     if(!walkStateResult.result) {
//       //TODO
//       //Error Handling
//       return false;
//     }
//
//     final resultData = walkStateResult.data;
//
//     if(resultData == null) {
//       //TODO
//       //Error Handling
//       return false;
//     }
//
//     if(!resultData.containsKey('walkEnd')) {
//       //TODO
//       //Error Handling
//       return false;
//     }
//
//     bool isWalkEnded = resultData['walkEnd'];
//
//     return isWalkEnded;
//   }
// }
