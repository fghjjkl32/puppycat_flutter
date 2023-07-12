import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'tag_contents_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class TagContentsService {
  factory TagContentsService(Dio dio, {String baseUrl}) = _TagContentsService;

  @GET('/my/tag/contents?memberIdx={memberIdx}&page={page}')
  Future<ContentResponseModel?> getTagContents(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );
}
