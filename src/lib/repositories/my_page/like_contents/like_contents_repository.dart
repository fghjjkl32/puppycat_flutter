import 'package:dio/dio.dart';
import 'package:pet_mobile_social_flutter/common/library/dio/api_exception.dart';
import 'package:pet_mobile_social_flutter/config/constanst.dart';
import 'package:pet_mobile_social_flutter/models/main/feed/feed_response_model.dart';
import 'package:pet_mobile_social_flutter/models/my_page/content_list_models/content_response_model.dart';
import 'package:pet_mobile_social_flutter/services/my_page/like_contents/like_contents_service.dart';

class LikeContentsRepository {
  late final LikeContentsService _likeContentsService; // = LikeContentsService(DioWrap.getDioWithCookie(), baseUrl: baseUrl);

  final Dio dio;

  LikeContentsRepository({
    required this.dio,
  }) {
    _likeContentsService = LikeContentsService(dio, baseUrl: baseUrl);
  }

  Future<ContentResponseModel> getLikeContents({
    required int page,
    int limit = 15,
  }) async {
    ContentResponseModel responseModel = await _likeContentsService.getLikeContents(page, limit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'LikeContentsRepository',
        caller: 'getLikeContents',
      );
    }

    return responseModel;
  }

  Future<FeedResponseModel> getLikeDetailContentList({
    required int page,
    int limit = 10,
    int imgLimit = 12,
  }) async {
    FeedResponseModel responseModel = await _likeContentsService.getLikeDetailContentList(page, limit, imgLimit);

    if (!responseModel.result) {
      throw APIException(
        msg: responseModel.message ?? '',
        code: responseModel.code,
        refer: 'LikeContentsRepository',
        caller: 'getLikeDetailContentList',
      );
    }

    return responseModel;
  }
}
