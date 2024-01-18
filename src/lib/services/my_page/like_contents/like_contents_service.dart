import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'like_contents_service.g.dart';

@RestApi()
abstract class LikeContentsService {
  factory LikeContentsService(Dio dio, {String baseUrl}) = _LikeContentsService;

  @GET('v1/my/like/contents')
  Future<ContentResponseModel> getLikeContents(
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/my/like/contents/detail')
  Future<FeedResponseModel> getLikeDetailContentList(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("imgLimit") int imgLimit,
  );
}
