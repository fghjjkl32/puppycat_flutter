import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/models/search/search_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'search_service.g.dart';

@RestApi()
abstract class SearchService {
  factory SearchService(Dio dio, {String baseUrl}) = _SearchService;

  @GET('/search/nick/mention?memberIdx={memberIdx}&page={page}')
  Future<SearchResponseModel?> getMentionRecommendList(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET('/search/nick/img?memberIdx={memberIdx}&page={page}')
  Future<SearchResponseModel?> getImageTagRecommendList(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET('/search/nick')
  Future<SearchResponseModel?> getNickSearchList(
    @Query("memberIdx") int memberIdx,
    @Query("page") int page,
    @Query("searchWord") String searchWord,
    @Query("limit") int limit,
  );

  @GET('/search/tag')
  Future<SearchResponseModel?> getTagSearchList(
    @Query("memberIdx") int memberIdx,
    @Query("page") int page,
    @Query("searchWord") String searchWord,
    @Query("limit") int limit,
  );

  @GET('/search')
  Future<SearchResponseModel?> getFullSearchList(
    @Query("memberIdx") int memberIdx,
    @Query("searchWord") String searchWord,
  );
}
