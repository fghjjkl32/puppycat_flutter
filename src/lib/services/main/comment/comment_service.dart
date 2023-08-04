import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'comment_service.g.dart';

@RestApi(baseUrl: "https://sns-api.devlabs.co.kr:28080/v1")
abstract class CommentService {
  factory CommentService(Dio dio, {String baseUrl}) = _CommentService;

  @GET('/contents/{contentIdx}/comment?page={page}&memberIdx={memberIdx}')
  Future<CommentResponseModel?> getComment(
    @Path("contentIdx") int contentIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @GET(
      '/contents/{contentsIdx}/comment/{commentIdx}/child?memberIdx={memberIdx}&page={page}&limit=10')
  Future<CommentResponseModel?> getReplyComment(
    @Path("contentsIdx") int contentsIdx,
    @Path("commentIdx") int commentIdx,
    @Path("memberIdx") int memberIdx,
    @Path("page") int page,
  );

  @POST('/contents/{contentIdx}/comment')
  Future<ResponseModel?> postComment(
    @Path("contentIdx") int contentIdx,
    @Body() Map<String, dynamic> body,
  );

  @PUT('/contents/{contentIdx}/comment/{commentIdx}')
  Future<ResponseModel?> editComment(
    @Path("contentIdx") int contentIdx,
    @Path("commentIdx") int commentIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/contents/{contentsIdx}/comment/{commentIdx}?memberIdx={memberIdx}')
  Future<ResponseModel?> deleteComment({
    @Path("contentsIdx") required int contentsIdx,
    @Path("commentIdx") required int commentIdx,
    @Path("memberIdx") required int memberIdx,
  });

  @POST('/comment/{commentIdx}/like')
  Future<ResponseModel?> postCommentLike(
    @Path("commentIdx") int commentIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/comment/{commentIdx}/like?memberIdx={memberIdx}')
  Future<ResponseModel?> deleteCommentLike({
    @Path("commentIdx") required int commentIdx,
    @Path("memberIdx") required int memberIdx,
  });
}
