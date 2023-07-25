import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'contents_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class ContentsService {
  factory ContentsService(Dio dio, {String baseUrl}) = _ContentsService;

  @DELETE('/contents?memberIdx={memberIdx}&{idx}')
  Future<ResponseModel?> deleteContents(
    @Path("memberIdx") int memberIdx,
    @Path("idx") String idx,
  );
}
