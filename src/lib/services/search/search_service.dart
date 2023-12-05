import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'search_service.g.dart';

@RestApi()
abstract class SearchService {
  factory SearchService(Dio dio, {String baseUrl}) = _SearchService;

  @GET('v1/search/nick/mention')
  Future<SearchResponseModel> getMentionRecommendList(
    @Query("page") int page,
    @Query("limit") int limit,
  );

  //TODO
  //노션에 참고내용(변경된거) 확인 필요
  @GET('v1/search/nick/img')
  Future<SearchResponseModel> getImageTagRecommendList(
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/search/nick')
  Future<SearchResponseModel> getNickSearchList(
    @Query("page") int page,
    @Query("searchWord") String searchWord,
    @Query("limit") int limit,
  );

  @GET('v1/search/tag')
  Future<SearchResponseModel> getTagSearchList(
    @Query("page") int page,
    @Query("searchWord") String searchWord,
    @Query("limit") int limit,
  );

  @GET('v1/search/tag')
  Future<SearchResponseModel> getLogoutTagSearchList(
    @Query("page") int page,
    @Query("searchWord") String searchWord,
    @Query("limit") int limit,
  );

  @GET('v1/search')
  Future<SearchResponseModel> getFullSearchList(
    @Query("searchWord") String searchWord,
    @Query('page') int? page,
    @Query('limit') int? limit,
  );

  @GET('v1/search')
  Future<SearchResponseModel> getLogoutFullSearchList(
    @Query("searchWord") String searchWord,
  );
}
