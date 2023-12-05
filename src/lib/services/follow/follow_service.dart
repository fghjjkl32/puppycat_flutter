import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'follow_service.g.dart';

@RestApi()
abstract class FollowService {
  factory FollowService(Dio dio, {String baseUrl}) = _FollowService;

  @GET('v1/follower/{memberUuid}/search')
  Future<FollowResponseModel> getFollowerSearchList(
    @Path("memberUuid") String memberUuid,
    @Query("page") int page,
    @Query("searchWord") String searchWord,
    @Query("searchType") String searchType,
    @Query("limit") int limit,
  );

  @GET('v1/follow/{memberIdx}/search')
  Future<FollowResponseModel> getFollowSearchList(
    @Path("memberUuid") String memberUuid,
    @Query("page") int page,
    @Query("searchWord") String searchWord,
    @Query("searchType") String searchType,
    @Query("limit") int limit,
  );

  @GET('v1/follower/{memberUuid}')
  Future<FollowResponseModel> getFollowerList(
    @Path("memberUuid") String memberUuid,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/follow/{memberUuid}')
  Future<FollowResponseModel> getFollowList(
    @Path("memberUuid") String memberUuid,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @POST('v1/follow/{followUuid}')
  Future<ResponseModel> postFollow(
    @Path("followUuid") String followUuid,
  );

  @DELETE('v1/follow/{followUuid}')
  Future<ResponseModel> deleteFollow(
    @Path("followIdx") String followUuid,
  );

  @DELETE('v1/follower/{followUuid}')
  Future<ResponseModel> deleteFollower(
    @Path("followUuid") String followUuid,
  );
}
