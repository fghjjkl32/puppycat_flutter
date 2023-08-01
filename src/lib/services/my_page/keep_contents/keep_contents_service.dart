import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'keep_contents_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class KeepContentsService {
  factory KeepContentsService(Dio dio, {String baseUrl}) = _KeepContentsService;

  @GET('/my/keep/contents?memberIdx={memberIdx}&page={page}&limit=15')
  Future<ContentResponseModel?> getKeepContents(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET(
      '/my/keep/contents/{contentsIdx}?loginMemberIdx={loginMemberIdx}&imgLimit=12')
  Future<FeedResponseModel?> getMyKeepContentDetail(
    @Path("contentsIdx") int contentsIdx,
    @Path("loginMemberIdx") int loginMemberIdx,
  );

  @DELETE('/contents/keep?memberIdx={memberIdx}&{idx}')
  Future<ResponseModel?> deleteKeepContents(
    @Path("memberIdx") int memberIdx,
    @Path("idx") String idx,
  );

  @DELETE('/contents/keep?memberIdx={memberIdx}&idx={idx}')
  Future<ResponseModel?> deleteOneKeepContents(
    @Path("memberIdx") int memberIdx,
    @Path("idx") int idx,
  );

  @POST('/contents/keep')
  Future<ResponseModel?> postKeepContents(@Body() Map<String, dynamic> body);
}
