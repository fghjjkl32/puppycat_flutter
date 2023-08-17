import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'save_contents_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class SaveContentsService {
  factory SaveContentsService(Dio dio, {String baseUrl}) = _SaveContentsService;

  @GET('/my/save/contents?memberIdx={memberIdx}&page={page}')
  Future<ContentResponseModel?> getSaveContents(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET(
      '/my/save/contents/detail?loginMemberIdx={loginMemberIdx}&page={page}&imgLimit=12')
  Future<FeedResponseModel?> getSaveDetailContentList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("page") int page,
  );
}
