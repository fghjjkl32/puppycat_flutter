import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/main/popular_user_list/popular_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/user_list/user_list_response_model.dart';
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
}
