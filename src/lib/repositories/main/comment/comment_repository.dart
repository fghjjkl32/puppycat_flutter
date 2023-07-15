import 'package:pet_mobile_social_flutter/common/library/dio/dio_wrap.dart';
import 'package:pet_mobile_social_flutter/models/default_response_model.dart';
import 'package:pet_mobile_social_flutter/models/main/comment/comment_response_model.dart';
import 'package:pet_mobile_social_flutter/services/main/comment/comment_service.dart';

class CommentRepository {
  final CommentService _contentsService =
      CommentService(DioWrap.getDioWithCookie());

  Future<CommentResponseModel> getComment(
      {required int contentIdx, required int page}) async {
    CommentResponseModel? commentResponseModel =
        await _contentsService.getComment(contentIdx, page);

    if (commentResponseModel == null) {
      throw "error";
    }

    return commentResponseModel;
  }

  Future<ResponseModel> postComment({
    required int memberIdx,
    required String contents,
    required int contentIdx,
    int? parentIdx,
  }) async {
    final Map<String, dynamic> body;
    if (parentIdx == null) {
      body = {
        "memberIdx": memberIdx,
        "contents": contents,
      };
    } else {
      body = {
        "memberIdx": memberIdx,
        "contents": contents,
        "parentIdx": parentIdx,
      };
    }

    ResponseModel? commentResponseModel =
        await _contentsService.postComment(contentIdx, body);

    if (commentResponseModel == null) {
      throw "error";
    }

    return commentResponseModel;
  }

  Future<ResponseModel> deleteComment({
    required int contentsIdx,
    required int commentIdx,
    required int memberIdx,
  }) async {
    ResponseModel? commentResponseModel = await _contentsService.deleteComment(
      contentsIdx: contentsIdx,
      commentIdx: commentIdx,
      memberIdx: memberIdx,
    );

    if (commentResponseModel == null) {
      throw "error";
    }

    return commentResponseModel;
  }
}
