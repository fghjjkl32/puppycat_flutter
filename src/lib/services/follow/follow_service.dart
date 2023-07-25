import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/follow/follow_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'follow_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class FollowService {
  factory FollowService(Dio dio, {String baseUrl}) = _FollowService;

  @GET(
      '/follower/{memberIdx}/search?page={page}&limit=30&searchWord={searchWord}&searchType=nick&loginMemberIdx={loginMemberIdx}')
  Future<FollowResponseModel?> getFollowerSearchList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
    @Path("searchWord") String searchWord,
  );

  @GET(
      '/follow/{memberIdx}/search?page={page}&limit=30&searchWord={searchWord}&searchType=nick&loginMemberIdx={loginMemberIdx}')
  Future<FollowResponseModel?> getFollowSearchList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
    @Path("searchWord") String searchWord,
  );

  @GET(
      '/follower/{memberIdx}?page={page}&limit=30&loginMemberIdx={loginMemberIdx}')
  Future<FollowResponseModel?> getFollowerList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET(
      '/follow/{memberIdx}?page={page}&limit=30&loginMemberIdx={loginMemberIdx}')
  Future<FollowResponseModel?> getFollowList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @POST('/follow/{followIdx}')
  Future<ResponseModel?> postFollow(
    @Path("followIdx") int followIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/follow/{followIdx}?memberIdx={memberIdx}')
  Future<ResponseModel?> deleteFollow(
    @Path("followIdx") int followIdx,
    @Path("memberIdx") int memberIdx,
  );

  @DELETE('/follower/{followIdx}?memberIdx={memberIdx}')
  Future<ResponseModel?> deleteFollower(
    @Path("followIdx") int followIdx,
    @Path("memberIdx") int memberIdx,
  );
}
