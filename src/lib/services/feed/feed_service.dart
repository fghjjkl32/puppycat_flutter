import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_service.g.dart';

@RestApi()
abstract class FeedService {
  factory FeedService(Dio dio, {String baseUrl}) = _FeedService;

  @DELETE('v1/contents?{idx}')
  Future<ResponseModel> deleteContents(
    @Path("idx") String idx,
  );

  @DELETE('v1/contents')
  Future<ResponseModel> deleteOneContents(
    @Query("idx") int idx,
  );

  @POST('v1/{reportType}/{contentsIdx}/report')
  Future<ResponseModel> postContentReport(
    @Path("reportType") String reportType,
    @Path("contentsIdx") int contentsIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('v1/{reportType}/{contentsIdx}/report')
  Future<ResponseModel> deleteContentReport(
    @Path("reportType") String reportType,
    @Path("contentsIdx") int contentsIdx,
  );

  //user page feed list - my
  @GET('v1/my/contents')
  Future<ContentResponseModel> getMyContentList(
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/my/tag/contents')
  Future<ContentResponseModel> getMyTagContentList(
    @Query("page") int page,
    @Query("limit") int limit,
  );

  //user page feed list - user
  @GET('v1/member/{memberUuid}/contents')
  Future<ContentResponseModel> getUserContentList(
    @Path("memberUuid") String memberUuid,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/member/{memberUuid}/tag/contents')
  Future<ContentResponseModel> getUserTagContentList(
    @Path("memberUuid") String memberUuid,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/search/tag/contents')
  Future<ContentResponseModel> getUserHashtagContentList(
    @Path("searchWord") String searchWord,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/search/tag/contents?imgLimit=12&searchWord={searchWord}&page={page}&limit=15')
  Future<ContentResponseModel> getLogoutUserHashtagContentList(
    @Path("searchWord") String searchWord,
    @Path("page") int page,
  );

  //user contents detail
  @GET('v1/contents/member/detail')
  Future<FeedResponseModel> getUserContentDetailList(
    @Query("memberUuid") String memberUuid,
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("imgLimit") int imgLimit,
  );

  @GET('v1/contents/tag/detail')
  Future<FeedResponseModel> getUserTagContentDetail(
    @Query("memberUuid") String memberUuid,
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("imgLimit") int imgLimit,
  );

  @GET('v1/contents/hashtag/detail')
  Future<FeedResponseModel> getUserHashtagContentDetailList(
    @Query("searchWord") String searchWord,
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("imgLimit") int imgLimit,
  );

  //my contents
  @GET('v1/my/normal/contents/{contentsIdx}')
  Future<FeedResponseModel> getMyContentDetail(
    @Path("contentsIdx") int contentsIdx,
    @Query('imgLimit') int imgLimit,
  );

  @GET('v1/my/normal/contents/detail')
  Future<FeedResponseModel> getMyContentDetailList(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("imgLimit") int imgLimit,
  );

  @GET('v1/contents/{contentsIdx}')
  Future<FeedResponseModel> getContentDetail(
    @Path("contentsIdx") int contentsIdx,
    @Query('imgLimit') int imgLimit,
  );

  @GET('v1/my/tag/contents/detail')
  Future<FeedResponseModel> getMyTagContentDetailList(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("imgLimit") int imgLimit,
  );

  //PopularWeek
  @GET('v1/contents/week/popular/detail')
  Future<FeedResponseModel> getPopularWeekDetailList(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("imgLimit") int imgLimit,
  );

  //PopularHour
  @GET('v1/contents/hour/popular/detail')
  Future<FeedResponseModel> getPopularHourDetailList(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("imgLimit") int imgLimit,
  );

  //follow
  @GET('v1/main/follow')
  Future<FeedResponseModel> getFollowDetailList(
    @Query("page") int page,
    @Query("limit") int limit,
  );

  //recent
  @GET('v1/contents/recent/detail')
  Future<FeedResponseModel> getRecentDetailList(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("imgLimit") int imgLimit,
  );

  @POST('v1/contents/{contentsIdx}/like')
  Future<ResponseModel> postLike(
    @Path("contentsIdx") int contentsIdx,
  );

  @DELETE('v1/contents/{contentsIdx}/like')
  Future<ResponseModel> deleteLike({
    @Path("contentsIdx") required int contentsIdx,
  });

  @POST('v1/contents/{contentsIdx}/save')
  Future<ResponseModel> postSave(
    @Path("contentsIdx") int contentsIdx,
  );

  @DELETE('v1/contents/{contentsIdx}/save')
  Future<ResponseModel> deleteSave({
    @Path("contentsIdx") required int contentsIdx,
  });

  @POST('v1/contents/{contentsIdx}/hide')
  Future<ResponseModel> postHide(
    @Path("contentsIdx") int contentsIdx,
  );

  @DELETE('v1/contents/{contentsIdx}/hide')
  Future<ResponseModel> deleteHide({
    @Path("contentsIdx") required int contentsIdx,
  });

  @POST("v1/contents")
  Future<ResponseModel> postFeed(@Body() FormData formData);

  @PUT("v1/contents/{contentsIdx}")
  Future<ResponseModel> putFeed(
    @Path("contentsIdx") int contentsIdx,
    @Body() Map<String, dynamic> formData,
  );
}
