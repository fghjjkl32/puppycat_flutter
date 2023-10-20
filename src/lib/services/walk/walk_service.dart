import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/policy/policy_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'walk_service.g.dart';

@RestApi()
abstract class WalkService {
  factory WalkService(Dio dio, {String baseUrl}) = _WalkService;

  @GET('/v1/walk/cnt')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> getTodayWalkCount(@Query("memberUuid") String memberUuid, @Query("together") int together);

  @POST('/v1/walk')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> startWalk(@Body() Map<String, dynamic> body);

  @POST('/v1/walk/stop')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> stopWalk(@Body() Map<String, dynamic> body);

  @POST('/v1/gps/info')
  @Headers(<String, dynamic>{
    "Content-Type": "application/json",
  })
  Future<ResponseModel> sendWalkInfo(@Body() Map<String, dynamic> body);

}
