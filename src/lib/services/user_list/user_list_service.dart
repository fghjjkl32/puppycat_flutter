import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/user_list/content_like_user_list/content_like_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/user_list/popular_user_list/popular_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/user_list/user_list_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_list_service.g.dart';

@RestApi()
abstract class UserListService {
  factory UserListService(Dio dio, {String baseUrl}) = _UserListService;

  @GET('v1/main/favorite')
  Future<UserListResponseModel> getFavoriteUserList(
    @Query('page') int page,
    @Query('limit') int limit,
  );

  @GET('v1/main/popular')
  Future<PopularUserListResponseModel> getPopularUserList();

  @GET('v1/contents/{contentsIdx}/like')
  Future<ContentLikeUserListResponseModel> getContentLikeUserList(
    @Path("contentsIdx") int contentsIdx,
    @Query("page") int page,
  );
}
