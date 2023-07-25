import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/block/block_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'feed_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class FeedService {
  factory FeedService(Dio dio, {String baseUrl}) = _FeedService;

  @GET(
      '/contents/member/detail?loginMemberIdx={loginMemberIdx}&imgLimit=12&memberIdx={memberIdx}&page={page}')
  Future<FeedResponseModel?> getUserContentDetailList(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET(
      '/contents/tag/detail?loginMemberIdx={loginMemberIdx}&imgLimit=12&memberIdx={memberIdx}&page={page}')
  Future<FeedResponseModel?> getTagContentDetail(
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET(
      '/my/normal/contents/{contentsIdx}?loginMemberIdx={loginMemberIdx}&imgLimit=12')
  Future<FeedResponseModel?> getUserContentDetail(
    @Path("contentsIdx") int contentsIdx,
    @Path("loginMemberIdx") int loginMemberIdx,
    @Path("page") int page,
  );

  @POST('/contents/{contentsIdx}/like')
  Future<ResponseModel?> postLike(
    @Path("contentsIdx") int contentsIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/contents/{contentsIdx}/like?memberIdx={memberIdx}')
  Future<ResponseModel?> deleteLike({
    @Path("contentsIdx") required int contentsIdx,
    @Path("memberIdx") required int memberIdx,
  });

  @POST('/contents/{contentsIdx}/save')
  Future<ResponseModel?> postSave(
    @Path("contentsIdx") int contentsIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/contents/{contentsIdx}/save?memberIdx={memberIdx}')
  Future<ResponseModel?> deleteSave({
    @Path("contentsIdx") required int contentsIdx,
    @Path("memberIdx") required int memberIdx,
  });
}
