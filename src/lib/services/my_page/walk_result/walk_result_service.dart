import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result/walk_result_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_result_detail/walk_result_detail_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/walk/walk_write_result_detail/walk_write_result_detail_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'walk_result_service.g.dart';

@RestApi()
abstract class WalkResultService {
  factory WalkResultService(Dio dio, {String baseUrl}) = _WalkResultService;

  @GET("/v1/walk/result/{memberUuid}")
  Future<WalkResultResponseModel> getWalkResult(
    @Path("memberUuid") String memberUuid,
    @Query("together") int together,
    @Query("limit") int limit,
    @Query("searchStartDate") String searchStartDate,
    @Query("searchEndDate") String searchEndDate,
  );

  @GET("/v1/walk/result/{memberUuid}")
  Future<WalkResultResponseModel> getWalkResultForMap(
    @Path("memberUuid") String memberUuid,
    @Query("together") int together,
    @Query("limit") int limit,
  );

  @GET("/v1/walk/result/detail?memberUuid={memberUuid}&walkUuid={walkUuid}")
  Future<WalkResultDetailResponseModel> getWalkResultDetail(
    @Path("memberUuid") String memberUuid,
    @Path("walkUuid") String walkUuid,
  );

  @POST("/v1/walk/result")
  Future<ResponseModel?> postWalkResult(@Body() FormData formData);

  @PUT("/v1/walk/result")
  Future<ResponseModel?> putWalkResult(@Body() FormData formData);

  @GET("/v1/walk/write-result/info")
  Future<WalkWriteResultDetailResponseModel> getWalkWriteResultDetail(
    @Query("memberUuid") String memberUuid,
    @Query("walkUuid") String walkUuid,
  );
}
