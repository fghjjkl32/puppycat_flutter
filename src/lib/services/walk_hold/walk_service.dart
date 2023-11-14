///NOTE
///2023.11.14.
///산책하기 보류로 주석 처리
// import 'package:dio/dio.dart' hide Headers;
// import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
// import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
// import 'package:pet_mobile_social_flutter/models/walk/walk_result_state/walk_result_state_response_model.dart';
// import 'package:retrofit/retrofit.dart';
//
// part 'walk_service.g.dart';
//
// @RestApi()
// abstract class WalkService {
//   factory WalkService(Dio dio, {String baseUrl}) = _WalkService;
//
//   @GET('/walk/cnt')
//   @Headers(<String, dynamic>{
//     "Content-Type": "application/json",
//   })
//   Future<ResponseModel> getTodayWalkCount(@Query("memberUuid") String memberUuid, @Query("together") int together);
//
//   @POST('/walk')
//   @Headers(<String, dynamic>{
//     "Content-Type": "application/json",
//   })
//   Future<ResponseModel> startWalk(@Body() Map<String, dynamic> body);
//
//   @POST('/walk/stop')
//   @Headers(<String, dynamic>{
//     "Content-Type": "application/json",
//   })
//   Future<ResponseModel> stopWalk(@Body() Map<String, dynamic> body);
//
//   @POST('/gps/info')
//   @Headers(<String, dynamic>{
//     "Content-Type": "application/json",
//   })
//   Future<ResponseModel> sendWalkInfo(@Body() Map<String, dynamic> body);
//
//   @GET('/walk/result/state')
//   Future<WalkResultStateResponseModel> getWalkResultState(@Query("memberUuid") String memberUuid);
//
//   @GET('/walk/state')
//   Future<ResponseModel> getWalkState(@Query('memberUuid') String memberUuid, @Query('walkUuid') String walkUuid);
// }
