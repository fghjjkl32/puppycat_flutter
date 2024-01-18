import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'keep_contents_service.g.dart';

@RestApi()
abstract class KeepContentsService {
  factory KeepContentsService(Dio dio, {String baseUrl}) = _KeepContentsService;

  @GET('v1/my/keep/contents')
  Future<ContentResponseModel> getKeepContents(
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/my/keep/contents/{contentsIdx}')
  Future<FeedResponseModel> getMyKeepContentDetail(
    @Path("contentsIdx") int contentsIdx,
    @Query('imgLimit') int imgLimit,
  );

  @DELETE('v1/contents/keep?{idx}')
  Future<ResponseModel> deleteKeepContents(
    @Path("idx") String idx,
  );

  @DELETE('v1/contents/keep')
  Future<ResponseModel> deleteOneKeepContents(
    @Query("idx") int idx,
  );

  @POST('v1/contents/keep')
  Future<ResponseModel> postKeepContents(@Body() Map<String, dynamic> body);
}
