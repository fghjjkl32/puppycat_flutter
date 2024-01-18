import 'package:dio/dio.dart' hide Headers;
import 'package:pet_mobile_social_flutter/models/comment/comment_response_model.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:retrofit/retrofit.dart';

part 'comment_service.g.dart';

@RestApi()
abstract class CommentService {
  factory CommentService(Dio dio, {String baseUrl}) = _CommentService;

  @GET('v1/contents/{contentIdx}/comment')
  Future<CommentResponseModel> getComment(
    @Path("contentIdx") int contentIdx,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/contents/{contentsIdx}/comment/{commentIdx}/child')
  Future<CommentResponseModel> getReplyComment(
    @Path("contentsIdx") int contentsIdx,
    @Path("commentIdx") int commentIdx,
    @Query("page") int page,
    @Query("limit") int limit,
  );

  @GET('v1/contents/{contentsIdx}/comment/{commentIdx}/child?&page={page}&limit=10')
  Future<CommentResponseModel> getLogoutReplyComment(
    @Path("contentsIdx") int contentsIdx,
    @Path("commentIdx") int commentIdx,
    @Path("page") int page,
  );

  @POST('v1/contents/{contentIdx}/comment')
  Future<ResponseModel> postComment(
    @Path("contentIdx") int contentIdx,
    @Body() Map<String, dynamic> body,
  );

  @PUT('v1/contents/{contentIdx}/comment/{commentIdx}')
  Future<ResponseModel> editComment(
    @Path("contentIdx") int contentIdx,
    @Path("commentIdx") int commentIdx,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('v1/contents/{contentsIdx}/comment/{commentIdx}')
  Future<ResponseModel> deleteComment({
    @Path("contentsIdx") required int contentsIdx,
    @Path("commentIdx") required int commentIdx,
    @Query('parentIdx') required int parentIdx,
  });

  @POST('v1/comment/{commentIdx}/like')
  Future<ResponseModel> postCommentLike(
    @Path("commentIdx") int commentIdx,
  );

  @DELETE('v1/comment/{commentIdx}/like')
  Future<ResponseModel> deleteCommentLike({
    @Path("commentIdx") required int commentIdx,
  });

  @GET('v1/contents/{contentsIdx}/comment/{commentIdx}/focus')
  Future<CommentResponseModel> getFocusComments({
    @Path("contentsIdx") required int contentsIdx,
    @Path("commentIdx") required int commentIdx,
    @Queries() required Map<String, dynamic> queries,
  });
}
