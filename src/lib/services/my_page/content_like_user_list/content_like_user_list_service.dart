import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/my_page/content_like_user_list/content_like_user_list_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'content_like_user_list_service.g.dart';

@RestApi()
abstract class ContentLikeUserListService {
  factory ContentLikeUserListService(Dio dio, {String baseUrl}) = _ContentLikeUserListService;

  @GET('v1/contents/{contentsIdx}/like')
  Future<ContentLikeUserListResponseModel> getContentLikeUserList(
    @Path("contentsIdx") int contentsIdx,
    @Query("page") int page,
  );
}
