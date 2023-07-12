import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'save_contents_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class SaveContentsService {
  factory SaveContentsService(Dio dio, {String baseUrl}) = _SaveContentsService;

  @GET('/my/save/contents?memberIdx={memberIdx}&page={page}')
  Future<ContentResponseModel?> getSaveContents(
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );
}
