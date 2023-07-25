import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'comment_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class CommentService {
  factory CommentService(Dio dio, {String baseUrl}) = _CommentService;

  @GET('/contents/{contentIdx}/comment?page={page}')
  Future<CommentResponseModel?> getComment(
    @Path("contentIdx") int contentIdx,
    @Path("page") int page,
  );

  @POST('/contents/{contentIdx}/comment')
  Future<ResponseModel?> postComment(
    @Path("contentIdx") int contentIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/contents/{contentsIdx}/comment/{commentIdx}?memberIdx={memberIdx}')
  Future<ResponseModel?> deleteComment({
    @Path("contentsIdx") required int contentsIdx,
    @Path("commentIdx") required int commentIdx,
    @Path("memberIdx") required int memberIdx,
  });
}
