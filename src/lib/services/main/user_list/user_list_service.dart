import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/main/popular_user_list/popular_user_list_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/user_list/user_list_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'user_list_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class UserListService {
  factory UserListService(Dio dio, {String baseUrl}) = _UserListService;

  @GET('/main/favorite/{memberIdx}?limit=19')
  Future<UserListResponseModel?> getFavoriteUserList(
    @Path("memberIdx") int memberIdx,
  );

  @GET('/main/popular?loginMemberIdx={loginMemberIdx}')
  Future<PopularUserListResponseModel?> getPopularUserList(
    @Path("loginMemberIdx") int loginMemberIdx,
  );
}
