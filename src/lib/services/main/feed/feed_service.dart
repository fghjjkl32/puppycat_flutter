import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_service.g.dart';

@RestApi()
abstract class FeedService {
  factory FeedService(Dio dio, {String baseUrl}) = _FeedService;

  @DELETE('v1/contents?memberIdx={memberIdx}&{idx}')
  Future<ResponseModel> deleteContents(
    @Path("memberIdx") int memberIdx,
    @Path("idx") String idx,
  );

  @DELETE('v1/contents?memberIdx={memberIdx}&idx={idx}')
  Future<ResponseModel> deleteOneContents(
    @Path("memberIdx") int memberIdx,
    @Path("idx") int idx,
  );

  @POST('v1/{reportType}/{contentsIdx}/report')
  Future<ResponseModel> postContentReport(
    @Path("reportType") String reportType,
    @Path("contentsIdx") int contentsIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('v1/{reportType}/{contentsIdx}/report?memberIdx={memberIdx}')
  Future<ResponseModel> deleteContentReport(
    @Path("reportType") String reportType,
    @Path("contentsIdx") int contentsIdx,
    @Path("memberIdx") int memberIdx,
  );

  //user page feed list - my
  @GET('v1/my/contents?memberIdx={memberIdx}&page={page}&limit=15')
  Future<ContentResponseModel> getMyContentList(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET('v1/my/tag/contents?memberIdx={memberIdx}&page={page}&limit=15')
  Future<ContentResponseModel> getMyTagContentList(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  //user page feed list - user
  @GET(
      'v1/member/{memberIdx}/contents?loginMemberIdx={loginMemberIdx}&page={page}&limit=15')
  Future<ContentResponseModel> getUserContentList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET('v1/member/{memberIdx}/contents?&page={page}&limit=15')
  Future<ContentResponseModel> getLogoutUserContentList(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET(
      'v1/member/{memberIdx}/tag/contents?loginMemberIdx={loginMemberIdx}&page={page}&limit=15')
  Future<ContentResponseModel> getUserTagContentList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET('v1/member/{memberIdx}/tag/contents?&page={page}&limit=15')
  Future<ContentResponseModel> getLogoutUserTagContentList(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET(
      'v1/search/tag/contents?memberIdx={memberIdx}&imgLimit=12&searchWord={searchWord}&page={page}&limit=15')
  Future<ContentResponseModel> getUserHashtagContentList(
    @Path("memberIdx") int memberIdx,
    @Path("searchWord") String searchWord,
    @Path("page") int page,
  );

  @GET(
      'v1/search/tag/contents?imgLimit=12&searchWord={searchWord}&page={page}&limit=15')
  Future<ContentResponseModel> getLogoutUserHashtagContentList(
    @Path("searchWord") String searchWord,
    @Path("page") int page,
  );

  //user contents detail
  @GET(
      'v1/contents/member/detail?loginMemberIdx={loginMemberIdx}&imgLimit=12&memberIdx={memberIdx}&page={page}')
  Future<FeedResponseModel> getUserContentDetailList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET('v1/contents/member/detail?imgLimit=12&memberIdx={memberIdx}&page={page}')
  Future<FeedResponseModel> getLogoutUserContentDetailList(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET(
      'v1/contents/tag/detail?loginMemberIdx={loginMemberIdx}&imgLimit=12&memberIdx={memberIdx}&page={page}')
  Future<FeedResponseModel> getUserTagContentDetail(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET(
      'v1/contents/hashtag/detail?loginMemberIdx={loginMemberIdx}&imgLimit=12&searchWord={searchWord}&page={page}')
  Future<FeedResponseModel> getUserHashtagContentDetailList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("searchWord") String searchWord,
    @Path("page") int page,
  );

  //my contents
  @GET(
      'v1/my/normal/contents/{contentsIdx}?loginMemberIdx={loginMemberIdx}&imgLimit=12')
  Future<FeedResponseModel> getMyContentDetail(
    @Path("contentsIdx") int contentsIdx,
    @Path("loginMemberIdx") int loginMemberIdx,
  );

  @GET(
      'v1/my/normal/contents/detail?loginMemberIdx={loginMemberIdx}&imgLimit=12&memberIdx={memberIdx}&page={page}')
  Future<FeedResponseModel> getMyContentDetailList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET('v1/contents/{contentsIdx}?loginMemberIdx={loginMemberIdx}&imgLimit=12')
  Future<FeedResponseModel> getContentDetail(
    @Path("contentsIdx") int contentsIdx,
    @Path("loginMemberIdx") int loginMemberIdx,
  );

  @GET('v1/contents/{contentsIdx}?imgLimit=12')
  Future<FeedResponseModel> getLogoutContentDetail(
    @Path("contentsIdx") int contentsIdx,
  );

  @GET(
      'v1/my/tag/contents/detail?loginMemberIdx={loginMemberIdx}&imgLimit=12&&page={page}')
  Future<FeedResponseModel> getMyTagContentDetailList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("page") int page,
  );

  //PopularWeek
  @GET(
      'v1/contents/week/popular/detail?loginMemberIdx={loginMemberIdx}&imgLimit=12&&page={page}')
  Future<FeedResponseModel> getPopularWeekDetailList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("page") int page,
  );

  //PopularHour
  @GET(
      'v1/contents/hour/popular/detail?loginMemberIdx={loginMemberIdx}&imgLimit=12&&page={page}')
  Future<FeedResponseModel> getPopularHourDetailList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("page") int page,
  );

  @GET('v1/contents/hour/popular/detail?imgLimit=12&&page={page}')
  Future<FeedResponseModel> getLogoutPopularHourDetailList(
    @Path("page") int page,
  );

  //follow
  @GET('v1/main/follow/{loginMemberIdx}?page={page}')
  Future<FeedResponseModel> getFollowDetailList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("page") int page,
  );

  //recent
  @GET(
      'v1/contents/recent/detail?loginMemberIdx={loginMemberIdx}&imgLimit=12&&page={page}')
  Future<FeedResponseModel> getRecentDetailList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("page") int page,
  );

  @GET('v1/contents/recent/detail?imgLimit=12&&page={page}')
  Future<FeedResponseModel> getRecentLogoutDetailList(
    @Path("page") int page,
  );

  @POST('v1/contents/{contentsIdx}/like')
  Future<ResponseModel> postLike(
    @Path("contentsIdx") int contentsIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('v1/contents/{contentsIdx}/like?memberIdx={memberIdx}')
  Future<ResponseModel> deleteLike({
    @Path("contentsIdx") required int contentsIdx,
    @Path("memberIdx") required int memberIdx,
  });

  @POST('v1/contents/{contentsIdx}/save')
  Future<ResponseModel> postSave(
    @Path("contentsIdx") int contentsIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('v1/contents/{contentsIdx}/save?memberIdx={memberIdx}')
  Future<ResponseModel> deleteSave({
    @Path("contentsIdx") required int contentsIdx,
    @Path("memberIdx") required int memberIdx,
  });

  @POST('v1/contents/{contentsIdx}/hide')
  Future<ResponseModel> postHide(
    @Path("contentsIdx") int contentsIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('v1/contents/{contentsIdx}/hide?memberIdx={memberIdx}')
  Future<ResponseModel> deleteHide({
    @Path("contentsIdx") required int contentsIdx,
    @Path("memberIdx") required int memberIdx,
  });

  @POST("v1/contents")
  Future<ResponseModel> postFeed(@Body() FormData formData);

  @PUT("v1/contents/{contentsIdx}")
  Future<ResponseModel> putFeed(
    @Path("contentsIdx") int contentsIdx,
    @Body() Map<String, dynamic> formData,
  );
}
