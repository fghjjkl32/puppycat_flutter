import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'save_contents_service.g.dart';

@RestApi()
abstract class SaveContentsService {
  factory SaveContentsService(Dio dio, {String baseUrl}) = _SaveContentsService;

  @GET('v1/my/save/contents')
  Future<ContentResponseModel> getSaveContents(
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/my/save/contents/detail')
  Future<FeedResponseModel> getSaveDetailContentList(
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("imgLimit") int imgLimit,
  );
}
