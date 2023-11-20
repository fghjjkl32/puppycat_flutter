import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'like_contents_service.g.dart';

@RestApi()
abstract class LikeContentsService {
  factory LikeContentsService(Dio dio, {String baseUrl}) = _LikeContentsService;

  @GET('v1/my/like/contents?memberIdx={memberIdx}&page={page}&limit=15')
  Future<ContentResponseModel> getLikeContents(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET('v1/my/like/contents/detail?loginMemberIdx={loginMemberIdx}&page={page}&imgLimit=12')
  Future<FeedResponseModel> getLikeDetailContentList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("page") int page,
  );
}
